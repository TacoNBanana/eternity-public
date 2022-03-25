GM:RegisterLogType("character_created", LOG_CHARACTER, function(data)
	local name = string.lower(GAMEMODE:GetSpecies(data.Species).Name)

	return string.format("%s has made a new %s character: %s", GAMEMODE:FormatPlayer(data.Ply), name, GAMEMODE:FormatCharacter(data.Char))
end)

GM:RegisterLogType("character_loaded", LOG_CHARACTER, function(data)
	if data.From then
		return string.format("%s swapped characters from %s to %s", GAMEMODE:FormatPlayer(data.Ply), GAMEMODE:FormatCharacter(data.From), GAMEMODE:FormatCharacter(data.Char))
	else
		return string.format("%s has loaded %s", GAMEMODE:FormatPlayer(data.Ply), GAMEMODE:FormatCharacter(data.Char))
	end
end)

GM:RegisterLogType("character_deleted", LOG_CHARACTER, function(data)
	return string.format("%s has deleted character %s", GAMEMODE:FormatPlayer(data.Ply), data.CharID)
end)

GM:RegisterLogType("character_setdesc", LOG_CHARACTER, function(data)
	return string.format("%s has changed their description", GAMEMODE:FormatCharacter(data.Char))
end)

GM:RegisterLogType("character_setname", LOG_CHARACTER, function(data)
	return string.format("%s has changed their name to %s", GAMEMODE:FormatCharacter(data.Char), data.New)
end)

GM:RegisterLogType("character_buylicense", LOG_CHARACTER, function(data)
	return string.format("%s has bought the %s license", GAMEMODE:FormatCharacter(data.Char), string.lower(LICENSES[data.License].Name))
end)