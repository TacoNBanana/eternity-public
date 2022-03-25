module("console", package.seeall)

Commands = {}
Parsers = {}
Access = {}

local function DefaultFeedback(ply, msg)
	ply:ChatPrint(msg)
end

local function SendFeedback(ply, msg)
	if Feedback then
		Feedback(ply, msg)
	else
		DefaultFeedback(ply, msg)
	end
end

function SetFeedbackFunction(callback)
	Feedback = callback
end

function AddAccess(callback, feedback, hidden)
	return table.insert(Access, {
		Callback = callback,
		Feedback = feedback,
		Hidden = hidden or false
	})
end

function AddParser(name, callback)
	return table.insert(Parsers, {Name = name, Callback = callback})
end

function HasAccess(ply, access)
	access = Access[access]

	if not access then
		return false
	end

	return access.Callback(ply)
end

local function CheckAccess(ply, access)
	access = Access[access]

	if access then
		if access.Callback(ply) then
			return true
		elseif access.Feedback then
			SendFeedback(ply, access.Feedback)
		end
	else
		return false
	end
end

local function ParseCommandString(str)
	local quote = str[1] != '"'
	local args = {}

	for k in string.gmatch(str, "[^\"]+") do
		quote = not quote

		if quote then
			table.insert(args, k)
		else
			for v in string.gmatch(k, "%S+") do
				table.insert(args, v)
			end
		end
	end

	return args
end

local function ParseArgs(ply, args, typelist, flags)
	local tab = {}

	for k, v in pairs(typelist) do
		local parser = Parsers[v]
		local arg = args[k]

		if not parser then
			SendFeedback(ply, "Missing CTYPE parser, tell a developer.")

			return false
		end

		if k == #typelist then
			arg = tostring(table.concat(args, " ", k))
		end

		if flags[CFLAG_NOCONSOLE] and not IsValid(ply) then
			print("This command cannot be ran from the server console!")
		end

		local ok, val = parser.Callback(ply, arg, flags)

		if not ok then
			SendFeedback(ply, val)

			return false
		else
			tab[k] = val
		end
	end

	return tab
end

local function ParseCommand(ply, cmd, str)
	local command = Commands[cmd]

	if not command then
		return
	end

	if IsValid(ply) and not CheckAccess(ply, command.Access) then
		return
	end

	coroutine.WrapFunc(function()
		local raw = ParseCommandString(str)
		local args = ParseArgs(ply, raw, command.TypeList, command.Flags)

		if not args then
			return
		end

		command.Callback(ply, unpack(args))
	end)
end

function AddCommand(commands, callback, access, typelist, flags, category, description)
	if not istable(commands) then
		commands = {commands}
	end

	for _, v in pairs(commands) do
		if SERVER then
			concommand.Add(v, function(ply, cmd, args, str)
				ParseCommand(ply, cmd, str)
			end)

			Commands[v] = {
				Callback = callback,
				Access = access,
				TypeList = typelist or {},
				Flags = flags and table.MakeAssociative(flags) or {},
			}
		elseif not Access[access].Hidden then
			Commands[v] = {
				Access = access,
				TypeList = typelist or {},
				Category = category or "Unsorted",
				Description = description
			}

			concommand.Add(v, function(ply, cmd, args, str)
				netstream.Send("ConsoleCommand", {
					Command = cmd,
					Arguments = str
				})
			end)
		end
	end
end

function AddClientCommand(commands, callback, access, typelist, flags, category, description)
	if CLIENT then
		if not istable(commands) then
			commands = {commands}
		end

		for _, v in pairs(commands) do
			concommand.Add(v, function(ply, cmd, args, str)
				ParseCommand(ply, cmd, str)
			end)

			Commands[v] = {
				Callback = callback,
				Access = access,
				TypeList = typelist or {},
				Flags = flags and table.MakeAssociative(flags) or {},
				Category = category or "Unsorted",
				Description = description
			}
		end
	end
end

netstream.Hook("ConsoleCommand", function(ply, data)
	ParseCommand(ply, data.Command, data.Arguments)
end)