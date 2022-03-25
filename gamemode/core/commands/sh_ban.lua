console.AddCommand("rpa_kick", function(ply, target, reason)
	local id = target:UserID()

	if #reason > 0 then
		GAMEMODE:SendChat("NOTICE", string.format("%s has kicked %s (%s)", PlayerName(ply), target:RPName(), reason))
	else
		GAMEMODE:SendChat("NOTICE", string.format("%s has kicked %s", PlayerName(ply), target:RPName()))
	end

	GAMEMODE:WriteLog("security_kick", {
		Admin = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(target),
		Ply = GAMEMODE:LogPlayer(target),
		Reason = #reason > 0 and reason or nil
	})

	game.KickID(id, reason)
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_STRING}, {CFLAG_CHECKIMMUNITY, CFLAG_FORCESINGLETARGET, CFLAG_NOSELFTARGET},
"Bans", "Kicks a player")

console.AddCommand("rpa_ban", function(ply, steamid, duration, reason)
	local target = player.GetBySteamID(steamid)
	local notice = player.GetAll()
	local name = steamid

	if duration < 0 then
		Feedback(ply, "Ban duration has to be 0 or greater.", "ERROR")

		return
	end

	duration = duration * 60 -- Minutes instead of seconds

	if IsValid(target) then
		name = target:RPName()
	else
		notice = player.GetUsergroup(USERGROUP_ADMIN)
	end

	local format
	local args = {PlayerName(ply), name}

	if duration > 0 then
		format = "%s has banned %s for %s"

		table.insert(args, string.NiceTime(duration))
	else
		format = "%s has permanently banned %s"
	end

	if #reason > 0 then
		format = format .. " (%s)"

		table.insert(args, reason)
	end

	GAMEMODE:SendChat("NOTICE", string.format(format, unpack(args)), notice)

	GAMEMODE:WriteLog("security_ban", {
		Admin = GAMEMODE:LogPlayer(ply),
		Char = IsValid(target) and GAMEMODE:LogCharacter(target) or nil,
		Ply = IsValid(target) and GAMEMODE:LogPlayer(target) or GAMEMODE:LogPlayerRaw(steamid),
		Reason = #reason > 0 and reason or nil,
		Duration = duration > 0 and duration or nil
	})

	ban.Add(steamid, duration, ply, reason)
end, COMMAND_ADMIN, {CTYPE_STEAMID, CTYPE_NUMBER, CTYPE_STRING}, {CFLAG_CHECKIMMUNITY, CFLAG_NOSELFTARGET},
"Bans", "Bans a player for the specified time in minutes. Use a duration of 0 for permanent bans")

-- TODO: Replace with ban interface, require manually removing bans instead of just removing them all
console.AddCommand("rpa_unban", function(ply, steamid)
	local bans = ban.Get(steamid, true)

	if #bans < 1 then
		Feedback(ply, "This person isn't banned!", "ERROR")

		return
	end

	for _, v in pairs(bans) do
		ban.Lift(v.id, ply)
	end

	GAMEMODE:SendChat("NOTICE", string.format("%s has unbanned %s", PlayerName(ply), steamid), player.GetUsergroup(USERGROUP_ADMIN))

	GAMEMODE:WriteLog("security_unban", {
		Admin = GAMEMODE:LogPlayer(ply),
		Ply = GAMEMODE:LogPlayerRaw(steamid)
	})
end, COMMAND_ADMIN, {CTYPE_STEAMID}, {CFLAG_NOSELFTARGET},
"Bans", "Removes any bans a player has")