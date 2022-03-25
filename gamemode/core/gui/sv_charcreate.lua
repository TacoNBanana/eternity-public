local whitelist = {
	"RPName",
	"Description",
	"CharModel",
	"CharSkin",
	"Species"
}

netstream.Hook("CreateCharacter", function(ply, data)
	if not ply:HasSpeciesWhitelist(data.Species) then
		return
	end

	if table.Count(ply:Characters()) >= GAMEMODE:GetConfig("MaxCharacters") then
		return
	end

	local species = GAMEMODE.Species[data.Species]

	if GAMEMODE:CheckCharacterValidity(species, data) then
		local db = {}

		for _, v in pairs(whitelist) do
			if data[v] and not species.DisabledProperties[v] then
				db[v] = data[v]
			end
		end

		local id = ply:CreateNewCharacter(db)

		ply:LoadCharacter(id)
	end
end)