GM:RegisterLogType("security_password", LOG_SECURITY, function(data)
	return string.format("%s access denied: Incorrect password", GAMEMODE:FormatPlayer(data.Ply))
end)

GM:RegisterLogType("security_private", LOG_SECURITY, function(data)
	return string.format("%s access denied: Private mode (%s < %s)", GAMEMODE:FormatPlayer(data.Ply), USERGROUPS[data.Given], USERGROUPS[data.Required])
end)

GM:RegisterLogType("security_banned", LOG_SECURITY, function(data)
	return string.format("%s access denied: Banned", GAMEMODE:FormatPlayer(data.Ply))
end)

GM:RegisterLogType("security_kick", LOG_SECURITY, function(data)
	if data.Reason then
		return string.format("%s has kicked %s (%s)", GAMEMODE:FormatPlayer(data.Admin), GAMEMODE:FormatPlayer(data.Ply), data.Reason)
	else
		return string.format("%s has kicked %s", GAMEMODE:FormatPlayer(data.Admin), GAMEMODE:FormatPlayer(data.Ply))
	end
end)

GM:RegisterLogType("security_ban", LOG_SECURITY, function(data)
	local format
	local args = {GAMEMODE:FormatPlayer(data.Admin), GAMEMODE:FormatPlayer(data.Ply)}

	if data.Duration then
		format = "%s has banned %s for %s"

		table.insert(args, string.NiceTime(data.Duration))
	else
		format = "%s has permanently banned %s"
	end

	if data.Reason then
		format = format .. " (%s)"

		table.insert(args, data.Reason)
	end

	return string.format(format, unpack(args))
end)

GM:RegisterLogType("security_unban", LOG_SECURITY, function(data)
	return string.format("%s has unbanned %s", GAMEMODE:FormatPlayer(data.Admin), GAMEMODE:FormatPlayer(data.Ply))
end)

GM:RegisterLogType("security_inactivity", LOG_SECURITY, function(data)
	return string.format("%s has been kicked for inactivity", GAMEMODE:FormatPlayer(data.Ply))
end)

GM:RegisterLogType("security_itemtransfer", LOG_SECURITY, function(data)
	return string.format("%s tried to pick up %s on %s", GAMEMODE:FormatPlayer(data.Ply), GAMEMODE:FormatItem(data.Item), GAMEMODE:FormatCharacter(data.Char))
end)