local receivers = {
	print = function(ply, ...)
		local args = {...}

		if IsValid(ply) then
			table.insert(args, 1, string.format("[%s|%s]", ply:Nick(), ply:SteamID()))
		end

		print(unpack(args))
	end,
	PrintTable = function(ply, ...)
		if IsValid(ply) then
			print(string.format("[%s|%s]", ply:Nick(), ply:SteamID()))
		end

		PrintTable(...)
	end
}

function GM:HandleDebugOutput(func, args, target, from)
	if not receivers[func] then
		return
	end

	if CLIENT then
		netstream.Send("DebugOutput", {
			Func = func,
			Args = args,
			From = target -- Player that sent us the code to run
		})
	else
		if not IsValid(target) then
			receivers[func](from, unpack(args))
		else
			netstream.Send("DebugOutput", {
				Func = func,
				Args = args,
				Ply = from -- Player that sent the output to relay
			}, target)
		end
	end
end

function GM:RunDebug(ply, str)
	if not IsValid(ply) and not ply:IsDeveloper() then
		return
	end

	local func = CompileString(str, "@" .. ply:SteamID(), false)

	if isfunction(func) then
		local tab = {
			print = function(...)
				GAMEMODE:HandleDebugOutput("print", {...}, ply)
			end,
			PrintTable = function(...)
				GAMEMODE:HandleDebugOutput("PrintTable", {...}, ply)
			end,
			printf = function(...)
				GAMEMODE:HandleDebugOutput("print", {string.format(...)}, ply)
			end,
			ply = ply,
			this = ply:GetEyeTrace().Entity
		}

		if CLIENT then
			tab.lp = LocalPlayer()
		end

		setfenv(func, setmetatable(tab, {__index = _G}))

		local _, res = pcall(func)

		if res then
			self:HandleDebugOutput("print", {res}, ply)
		end
	else
		self:HandleDebugOutput("print", {func}, ply)
	end
end

if CLIENT then
	netstream.Hook("DebugOutput", function(data)
		if not receivers[data.Func] then
			return
		end

		receivers[data.Func](data.Ply, unpack(data.Args))
	end)

	netstream.Hook("RunLua", function(data)
		GAMEMODE:RunDebug(data.Ply, data.Str)
	end)
else
	netstream.Hook("DebugOutput", function(ply, data)
		if not receivers[data.Func] then
			return
		end

		GAMEMODE:HandleDebugOutput(data.Func, data.Args, data.From, ply)
	end)
end