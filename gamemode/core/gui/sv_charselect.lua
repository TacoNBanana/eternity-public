netstream.Hook("LoadCharacter", function(ply, data)
	if not isnumber(data.ID) then
		return
	end

	if ply:Restrained() then
		return
	end

	local character = ply:Characters()[data.ID]

	if not character or not ply:HasSpeciesWhitelist(character.Species) then
		return
	end

	ply:LoadCharacter(data.ID)
end)

netstream.Hook("DeleteCharacter", function(ply, data)
	if not isnumber(data.ID) or not ply:Characters()[data.ID] then
		return
	end

	ply:DeleteCharacter(data.ID)
end)