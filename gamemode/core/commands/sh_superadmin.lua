console.AddCommand("rpa_setusergroup", function(ply, target, usergroup)
	local name = string.lower(USERGROUPS[usergroup])

	target:SetAdminLevel(usergroup)
	target:SendChat("NOTICE", string.format("%s has set your usergroup to %s", PlayerName(ply), name))

	Feedback(ply, string.format("You've set %s's usergroup to %s", target:Nick(), name))

	GAMEMODE:WriteLog("admin_usergroup", {
		Admin = GAMEMODE:LogPlayer(ply),
		Ply = GAMEMODE:LogPlayer(target),
		Usergroup = usergroup
	})
end, COMMAND_SA, {CTYPE_PLAYER, CTYPE_USERGROUP}, {CFLAG_CHECKIMMUNITY, CFLAG_FORCESINGLETARGET, CFLAG_NOSELFTARGET, CFLAG_FORCENICK},
"Superadmin", "Sets a player's usergroup.")

console.AddCommand("rpa_setprivatemode", function(ply, usergroup)
	local name = string.lower(USERGROUPS[usergroup])

	if IsValid(ply) and usergroup > ply:AdminLevel() then
		Feedback(ply, "Setting this private mode would lock you out as well!", "ERROR")

		return
	end

	GAMEMODE.Config.PrivateMode = usergroup

	GAMEMODE:WriteLog("admin_privatemode", {
		Admin = GAMEMODE:LogPlayer(ply),
		Usergroup = usergroup
	})

	for _, v in pairs(player.GetAll()) do
		if v:AdminLevel() >= usergroup then
			continue
		end

		game.KickID(v:UserID(), "This server is currently locked to whitelisted users, sorry!")
	end

	Feedback(ply, string.format("You've set the server's private mode to %ss or higher", name))
end, COMMAND_SA, {CTYPE_USERGROUP}, {},
"Superadmin", "Sets the private mode for the server, kicking players in the process.")

console.AddCommand("rpa_nodamage", function(ply, targets, bool)
	local format = bool and "%s gave you godmode" or "%s took your godmode"

	for _, v in pairs(targets) do
		v:SetNoDamage(bool)
		v:SendChat("NOTICE", string.format(format, PlayerName(ply)))
	end

	if bool then
		Feedback(ply, string.format("You've given godmode to %s", TargetName(targets, "RPName")))
	else
		Feedback(ply, string.format("You've taken godmode from %s", TargetName(targets, "RPName")))
	end

	GAMEMODE:WriteLog("admin_nodamage", {
		Admin = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(target),
		Ply = GAMEMODE:LogPlayer(target),
		Bool = bool
	})
end, COMMAND_SA, {CTYPE_PLAYER, CTYPE_BOOL}, {CFLAG_CHECKIMMUNITY},
"Superadmin", "Disables damage on a player.")