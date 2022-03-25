function GM:FindPlayer(ply, arg, flags)
	if not arg or #arg < 1 then
		return false, "No targets found."
	end

	local targets = {}
	local done = false
	local admin = not IsValid(ply) or ply:IsAdmin()

	arg = string.lower(arg)

	if IsValid(ply) then
		if arg == "^" then
			targets = {ply}
			done = true
		elseif arg == "-" then
			local ent = ply:GetEyeTrace().Entity

			if IsValid(ent) and ent:IsPlayer() then
				targets = {ent}
				done = true
			end
		end
	end

	if admin and util.IsValidSteamID(string.upper(arg)) then
		local found = player.GetBySteamID(string.upper(arg))

		if found then
			targets = {found}
			done = true
		end
	end

	local multi = false

	if not done then
		if arg[1] == "@" then
			multi = true
			arg = string.sub(arg, 2)
		end

		for _, v in pairs(player.GetAll()) do
			if not flags[CFLAG_FORCENICK] and v:HasCharacter() and string.find(string.lower(v:RPName()), arg, 1, not multi) then
				table.insert(targets, v)

				continue
			end

			if admin and string.find(string.lower(v:Nick()), arg, 1, not multi) then
				table.insert(targets, v)

				continue
			end
		end
	end

	if flags[CFLAG_CHECKIMMUNITY] and IsValid(ply) then
		targets = table.Filter(targets, function(key, val)
			return val:AdminLevel() <= ply:AdminLevel()
		end)
	end

	if flags[CFLAG_NOSELFTARGET] and IsValid(ply) then
		targets = table.Filter(targets, function(key, val)
			return val != ply
		end)
	end

	if flags[CFLAG_NOADMIN] then
		targets = table.Filter(targets, function(key, val)
			return not val:IsAdmin()
		end)
	end

	if #targets < 1 then
		return false, "No targets found."
	elseif (not multi or flags[CFLAG_FORCESINGLETARGET]) and #targets > 1 then
		return false, "Multiple target matches."
	end

	if flags[CFLAG_FORCESINGLETARGET] then
		return true, targets[1]
	end

	return true, targets
end

function Feedback(ply, msg, classname)
	if IsValid(ply) then
		ply:SendChat(classname or "NOTICE", msg)
	else
		print(msg)
	end
end

function PlayerName(ply)
	if IsValid(ply) then
		return ply:Nick()
	else
		return "CONSOLE"
	end
end

function TargetName(targets, func)
	if istable(targets) and #targets > 1 then
		return #targets .. " players"
	else
		local target = targets

		if istable(targets) then
			target = targets[1]
		end

		return target[func](target)
	end
end

console.SetFeedbackFunction(function(ply, msg)
	if CLIENT then
		GAMEMODE:ProcessChat("ERROR", msg)
	else
		if IsValid(ply) then
			ply:SendChat("ERROR", msg)
		else
			print("[ERROR]: " .. msg)
		end
	end
end)

CTYPE_BOOL = console.AddParser("Boolean", function(ply, arg, flags)
	return true, tobool(arg)
end)

CTYPE_STRING = console.AddParser("String", function(ply, arg, flags)
	local val = string.Trim(tostring(arg))

	return true, val != "nil" and val or ""
end)

CTYPE_NUMBER = console.AddParser("Number", function(ply, arg, flags)
	return true, tonumber(arg) or 0
end)

CTYPE_PLAYER = console.AddParser("Player", function(ply, arg, flags)
	return GAMEMODE:FindPlayer(ply, arg, flags)
end)

CTYPE_LANGUAGE = console.AddParser("Language", function(ply, arg, flags)
	if not arg then
		return false, "Invalid language."
	end

	local lang = _G["LANG_" .. string.upper(arg)]

	if lang then
		return true, lang
	end

	return false, "Invalid language."
end)

CTYPE_SPECIES = console.AddParser("Species", function(ply, arg, flags)
	if not arg then
		return false, "Invalid species."
	end

	local species = _G["SPECIES_" .. string.upper(arg)]

	if species then
		return true, species
	end

	return false, "Invalid species."
end)

CTYPE_STEAMID = console.AddParser("SteamID", function(ply, arg, flags)
	local steamid = arg
	local target

	flags[CFLAG_FORCESINGLETARGET] = true

	if not util.IsValidSteamID(steamid) then
		local ok, output = GAMEMODE:FindPlayer(ply, arg, flags)

		if not ok then
			return ok, output
		end

		steamid = output:SteamID()
		target = output
	end

	if not util.IsValidSteamID(steamid) then
		return false, "Invalid SteamID."
	end

	if flags[CFLAG_CHECKIMMUNITY] and IsValid(ply) then
		local usergroup = IsValid(target) and target:AdminLevel() or GAMEMODE:GetOfflineUsergroup(steamid)

		if ply:AdminLevel() <= usergroup then
			return false, "You cannot target this person."
		end
	end

	return true, steamid
end)

CTYPE_USERGROUP = console.AddParser("Usergroup", function(ply, arg, flags)
	if not arg then
		return false, "Invalid usergroup."
	end

	local rank = _G["USERGROUP_" .. string.upper(arg)]

	if rank then
		return true, rank
	end

	return false, "Invalid usergroup."
end)

CTYPE_BADGE = console.AddParser("Badge", function(ply, arg, flags)
	if not arg then
		return false, "Invalid badge."
	end

	local badge = _G["BADGE_" .. string.upper(arg)]

	if badge then
		return true, badge
	end

	return false, "Invalid badge."
end)

CTYPE_LICENSE = console.AddParser("License", function(ply, arg, flags)
	if not arg then
		return false, "Invalid license."
	end

	local license = _G["LICENSE_" .. string.upper(arg)]

	if license then
		return true, license
	end

	return false, "Invalid license."
end)

CTYPE_TOOLTRUST = console.AddParser("Tooltrust", function(ply, arg, flags)
	if not arg then
		return false, "Invalid tooltrust."
	end

	local trust = _G["TOOLTRUST_" .. string.upper(arg)]

	if trust then
		return true, trust
	end

	return false, "Invalid tooltrust."
end)

CTYPE_PERMISSION = console.AddParser("Permission", function(ply, arg, flags)
	if not arg then
		return false, "Invalid permission."
	end

	local permission = _G["PERMISSION_" .. string.upper(arg)]

	if permission then
		return true, permission
	end

	return false, "Invalid permission."
end)


COMMAND_ALL = console.AddAccess(function(ply)
	return true
end)

COMMAND_PERM_PERMAPROP = console.AddAccess(function(ply)
	return ply:IsAdmin() or ply:HasPermission(PERMISSION_PERMAPROPS)
end, "You need to be an admin to do this.")

COMMAND_ADMIN = console.AddAccess(function(ply)
	return ply:IsAdmin()
end, "You need to be an admin to do this.")

COMMAND_SA = console.AddAccess(function(ply)
	return ply:IsSuperAdmin()
end, "You need to be a superadmin to do this.")

COMMAND_DEV = console.AddAccess(function(ply)
	return ply:IsDeveloper()
end, "You need to be a developer to do this.", true)

console.AddClientCommand("rp_uptime", function()
	print("Server uptime: " .. string.NiceTime(CurTime()))
end, COMMAND_ALL, {}, {},
"Clientside", "Prints out how long the server has been running.")

console.AddCommand("rp_togglehud", function(ply)
	ply:SetSetting("hud_enabled", not ply:GetSetting("hud_enabled"))
end, COMMAND_ALL, {}, {},
"Clientside", "Toggles your HUD on or off.")

console.AddCommand("rp_togglelegacy", function(ply)
	ply:SetSetting("hud_legacy", not ply:GetSetting("hud_legacy"))
end, COMMAND_ALL, {}, {},
"Clientside", "Toggles between legacy and modern HUD modes.")

console.AddCommand("rp_toggleholster", function(ply)
	ply:ToggleHolster()
end, COMMAND_ALL, {}, {},
"Clientside", "Toggles the current weapon's holster status, if supported.")

console.AddCommand("rp_thirdperson", function(ply)
	ply:SetSetting("hud_thirdperson", not ply:GetSetting("hud_thirdperson"))
end, COMMAND_ALL, {}, {},
"Clientside", "Toggles the current weapon's holster status, if supported.")

console.AddClientCommand("rp_stopmusic", function(ply)
	if GAMEMODE.PlayURL then
		GAMEMODE.PlayURL:Stop()
		GAMEMODE.PlayURL = nil
	end

	if GAMEMODE.Music then
		GAMEMODE.Music:Stop()
		GAMEMODE.Music = nil
	end
end, COMMAND_ALL, {}, {},
"Clientside", "Stops any currently playing music tracks or URLs")

console.AddCommand("rp_roll", function(ply, args)
	local num, sides, sign, mod

	num, sides, sign, mod = string.match(args, "^ *(%d+)d(%d+) *([%+%-]?) *(%d*) *$")

	num = tonumber(num)
	sides = tonumber(sides)
	mod = tonumber(mod)

	if not (num and sides) then
		ply:SendChat("ERROR", "Missing arguments.")

		return
	end

	num = math.Clamp(num, 1, 10)
	sides = math.Clamp(sides, 2, 20)

	local results = {}
	local total = 0

	for i = 1, num do
		local roll = math.random(sides)

		total = total + roll

		table.insert(results, roll)
	end

	local output
	local str = table.concat(results, " + ")

	if #sign > 0 and mod != 0 then
		local mult = tonumber(sign .. mod)

		total = total + mult
		output = string.format("%s rolled %id%i%s%i: (%s) %s %i = %i", ply:RPName(), num, sides, sign, mod, str, sign, mod, total)
	else
		output = string.format("%s rolled %id%i: (%s) = %i", ply:RPName(), num, sides, str, total)
	end

	local range = GAMEMODE:GetConfig("ChatRanges").Speak
	local targets = GAMEMODE:GetChatTargets(ply:EyePos(), range, 0)

	GAMEMODE:SendChat("NOTICE", output, targets)
end, COMMAND_ALL, {CTYPE_STRING}, {CFLAG_NOCONSOLE},
"Clientside", "Rolls a dice, format is NdX+m, where N = # of dice, X = # of sides per die, m = optional modifier")