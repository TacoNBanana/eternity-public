-- Languages

console.AddClientCommand("rpa_languages", function(ply, target)
	log.Default(string.format("Languages for %s [%s]:", target:RPName(), target:CharID()))

	for _, v in pairs(target:GetLanguages()) do
		log.Default(string.format("\t%s", LANGUAGES[v].Name))
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_FORCESINGLETARGET},
"Languages", "Lists all the languages a character knows.")

console.AddCommand("rpa_givelang", function(ply, targets, lang)
	local name = string.lower(LANGUAGES[lang].Name)

	for _, v in pairs(targets) do
		v:GiveLanguage(lang)
		v:SendChat("NOTICE", string.format("%s gave you the ability to speak %s", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_language", {
			Admin = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(v),
			Ply = GAMEMODE:LogPlayer(v),
			Lang = lang,
			Give = true
		})
	end

	Feedback(ply, string.format("You've given %s the ability to speak %s", TargetName(targets, "RPName"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_LANGUAGE}, {},
"Languages", "Gives a character the ability to speak a new language.")

console.AddCommand("rpa_takelang", function(ply, targets, lang)
	local name = string.lower(LANGUAGES[lang].Name)

	for _, v in pairs(targets) do
		v:TakeLanguage(lang)
		v:SendChat("NOTICE", string.format("%s took away your ability to speak %s", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_language", {
			Admin = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(v),
			Ply = GAMEMODE:LogPlayer(v),
			Lang = lang,
		})
	end

	Feedback(ply, string.format("You've taken the ability to speak %s from %s", name, TargetName(targets, "RPName")))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_LANGUAGE}, {},
"Languages", "Removes the ability to speak a language from a player. Removing all languages will render them mute.")


-- Whitelists

console.AddClientCommand("rpa_whitelists", function(ply, target)
	log.Default(string.format("Whitelists for %s [%s]:", target:Nick(), target:SteamID()))

	for _, v in pairs(target:GetAvailableSpecies()) do
		log.Default(string.format("\t%s", v.Name))
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_FORCESINGLETARGET},
"Whitelists", "Lists all whitelists a player has.")

console.AddCommand("rpa_givewhitelist", function(ply, targets, species)
	local name = string.lower(GAMEMODE:GetSpecies(species).Name)

	for _, v in pairs(targets) do
		v:GiveSpeciesWhitelist(species)
		v:SendChat("NOTICE", string.format("%s has added you to the %s whitelist", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_whitelist", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Species = species,
			Give = true
		})
	end

	Feedback(ply, string.format("You've added %s to the %s whitelist", TargetName(targets, "Nick"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_SPECIES}, {},
"Whitelists", "Adds a player to a species whitelist.")

console.AddCommand("rpa_takewhitelist", function(ply, targets, species)
	local speciesclass = GAMEMODE:GetSpecies(species)
	local name = string.lower(speciesclass.Name)

	for _, v in pairs(targets) do
		v:TakeSpeciesWhitelist(species)
		v:SendChat("NOTICE", string.format("%s has removed you from the %s whitelist", PlayerName(ply), name))

		if v:GetActiveSpecies() == speciesclass then
			v:NoCharacter()
		end

		GAMEMODE:WriteLog("admin_whitelist", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Species = species
		})
	end

	Feedback(ply, string.format("You've removed %s from the %s whitelist", TargetName(targets, "Nick"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_SPECIES}, {},
"Whitelists", "Removes a player from a species whitelist, characters belonging to this species will become inaccessible until the player is added back.")


-- Scoreboard badges

console.AddCommand("rpa_givebadge", function(ply, targets, badge)
	local name = string.lower(BADGES[badge].Name)

	for _, v in pairs(targets) do
		v:GiveBadge(badge)
		v:SendChat("NOTICE", string.format("%s has given you the %s badge", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_badge", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Badge = badge,
			Give = true
		})
	end

	Feedback(ply, string.format("You've given %s the %s badge", TargetName(targets, "Nick"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_BADGE}, {},
"Scoreboard badges", "Gives a player a scoreboard badge.")

console.AddCommand("rpa_takebadge", function(ply, targets, badge)
	local name = string.lower(BADGES[badge].Name)

	for _, v in pairs(targets) do
		v:TakeBadge(badge)
		v:SendChat("NOTICE", string.format("%s has removed your %s badge", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_badge", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Badge = badge
		})
	end

	Feedback(ply, string.format("You've taken the %s badge from %s", name, TargetName(targets, "Nick")))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_BADGE}, {},
"Scoreboard badges", "Takes a scoreboard badge from a player.")


-- Business licenses

console.AddClientCommand("rpa_licenses", function(ply, target)
	log.Default(string.format("Business licenses for %s [%s]:", target:RPName(), target:CharID()))

	for _, v in pairs(target:GetLicenses()) do
		log.Default(string.format("\t%s", LICENSES[v].Name))
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_FORCESINGLETARGET},
"Business licenses", "Lists all business licenses a character has.")

console.AddCommand("rpa_givelicense", function(ply, targets, license)
	local name = string.lower(LICENSES[license].Name)

	for _, v in pairs(targets) do
		v:GiveLicense(license)
		v:SendChat("NOTICE", string.format("%s has given you the %s license", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_license", {
			Admin = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(v),
			Ply = GAMEMODE:LogPlayer(v),
			License = license,
			Give = true
		})
	end

	Feedback(ply, string.format("You've given %s the %s license", TargetName(targets, "Nick"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_LICENSE}, {},
"Business licenses", "Gives a business license to a character.")

console.AddCommand("rpa_takelicense", function(ply, targets, license)
	local name = string.lower(LICENSES[license].Name)

	for _, v in pairs(targets) do
		v:TakeLicense(license)
		v:SendChat("NOTICE", string.format("%s has removed your %s license", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_license", {
			Admin = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(v),
			Ply = GAMEMODE:LogPlayer(v),
			License = license
		})
	end

	Feedback(ply, string.format("You've taken the %s license from %s", name, TargetName(targets, "Nick")))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_LICENSE}, {},
"Business licenses", "Takes a business license from a character.")


-- Phys/tooltrust

console.AddCommand("rpa_settooltrust", function(ply, targets, trust)
	trust = math.Clamp(trust, TOOLTRUST_BANNED, TOOLTRUST_ADVANCED)

	for _, v in pairs(targets) do
		v:SetToolTrust(trust)

		if trust == TOOLTRUST_BANNED then
			v:StripWeapon("weapon_physgun")
			v:StripWeapon("gmod_tool")
			v:SendChat("NOTICE", string.format("%s has removed your tooltrust", PlayerName(ply)))
		else
			local name = (trust == TOOLTRUST_ADVANCED) and "advanced" or "basic"

			v:Give("weapon_physgun")
			v:Give("gmod_tool")
			v:SendChat("NOTICE", string.format("%s has given you %s tooltrust", PlayerName(ply), name))
		end

		GAMEMODE:WriteLog("admin_tooltrust", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Trust = trust
		})
	end

	if trust == TOOLTRUST_BANNED then
		Feedback(ply, string.format("You've taken tooltrust from %s", TargetName(targets, "Nick")))
	else
		local name = (trust == TOOLTRUST_ADVANCED) and "advanced" or "basic"

		Feedback(ply, string.format("You've given %s %s tooltrust", TargetName(targets, "Nick"), name))
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_TOOLTRUST}, {CFLAG_CHECKIMMUNITY, CFLAG_NOADMIN},
"Sandbox", "Sets a player's tooltrust level. Setting it to banned will strip them of their phys/toolgun.")

-- Permissions

console.AddCommand("rpa_givepermissions", function(ply, targets, perm)
	local name = string.lower(PERMISSIONS[perm].Name)

	for _, v in pairs(targets) do
		v:GivePermission(perm)
		v:SendChat("NOTICE", string.format("%s has given you %s permissions", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_permission", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Perm = perm,
			Give = true
		})
	end

	Feedback(ply, string.format("You've given %s %s permissions", TargetName(targets, "Nick"), name))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_PERMISSION}, {CFLAG_NOADMIN},
"Permissions", "Gives a player permissions.")

console.AddCommand("rpa_takepermissions", function(ply, targets, perm)
	local name = string.lower(PERMISSIONS[perm].Name)

	for _, v in pairs(targets) do
		v:TakePermission(perm)
		v:SendChat("NOTICE", string.format("%s has taken your %s permissions", PlayerName(ply), name))

		GAMEMODE:WriteLog("admin_permission", {
			Admin = GAMEMODE:LogPlayer(ply),
			Ply = GAMEMODE:LogPlayer(v),
			Perm = perm
		})
	end

	Feedback(ply, string.format("You've taken %s's %s permissions", name, TargetName(targets, "Nick")))
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_PERMISSION}, {CFLAG_NOADMIN},
"Permissions", "Takes a player's permissions.")