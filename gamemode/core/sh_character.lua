local meta = FindMetaTable("Player")

GM.CharacterAccessors = {}

function GM:AddCharacterAccessor(name, default, private, storetype)
	self.CharacterAccessors[name] = {
		Default = default,
		Storetype = storetype
	}

	accessor.Player(name, default, private)

	if SERVER then
		hook.Add("Player" .. name .. "Changed", "CharacterAccessorChanged", function(ply, old, new)
			ply:SaveCharacterAccessor(name, new)
		end)
	end
end

accessor.Player("CharID", -1)
accessor.Player("Inventory", {})
accessor.Player("Gender", GENDER_OTHER)
accessor.Player("ModelData", {})
accessor.Player("ArmorLevel", 0)
accessor.Player("Squad", "")
accessor.Player("SquadLeader", false)

GM:AddCharacterAccessor("RPName", "", false, "VARCHAR(30)")
GM:AddCharacterAccessor("Description", "", false, "VARCHAR(2048)")
GM:AddCharacterAccessor("CharModel", "models/tnb/citizens/male_07.mdl", false, "VARCHAR(256)")
GM:AddCharacterAccessor("CharSkin", 0, false, "INT")
GM:AddCharacterAccessor("Species", SPECIES_HUMAN, false, "INT")
GM:AddCharacterAccessor("Languages", 1, false, "INT") -- First language defined
GM:AddCharacterAccessor("ActiveLanguage", LANG_NONE, false, "INT")
GM:AddCharacterAccessor("BusinessLicenses", 0, false, "INT")
GM:AddCharacterAccessor("InitialSetup", 0, true, "BOOLEAN")
GM:AddCharacterAccessor("Spawngroup", "", true, "VARCHAR(30)")
GM:AddCharacterAccessor("Hidden", 0, false, "BOOLEAN")

function GM:CheckNameValidity(name, characters)
	if not characters then
		characters = self:GetConfig("AllowedCharacters")
	end

	for _, v in pairs(string.Explode("", name)) do
		if not string.find(characters, v, 1, true) then
			return false
		end
	end

	return true
end

function GM:CheckCharacterValidity(species, data)
	if not self:IsPropertyDisabled(species, "RPName") then
		local name = tostring(data.RPName) or ""
		local min, max = self:GetConfig("MinNameLength"), self:GetConfig("MaxNameLength")

		if #name < min then
			return false, string.format("Name must be longer than %s characters", min)
		elseif #name > max then
			return false, string.format("Name can't be longer than %s characters", max)
		end

		if not self:CheckNameValidity(name) then
			return false, "Name contains invalid characters"
		end
	end

	if not self:IsPropertyDisabled(species, "Description") then
		local desc = tostring(data.Description) or ""
		local max = self:GetConfig("MaxDescLength")

		if #desc > max then
			return false, string.format("Description can't be longer than %s characters", max)
		end
	end

	local valid = false

	for _, v in pairs(species.PlayerModels) do
		if data.CharModel == v then
			valid = true

			break
		end
	end

	if not valid then
		return false, "Invalid model"
	end

	if data.CharSkin < 0 or (CLIENT and data.CharSkin > NumModelSkins(data.CharModel)) then
		return false, "Invalid skin"
	end

	return true
end

function GM:GetPlayerByCharID(id)
	for _, v in pairs(player.GetAll()) do
		if v:CharID() == id then
			return v
		end
	end
end

function meta:HasCharacter()
	return self:CharID() != -1
end

function meta:CharacterCount()
	return table.Count(self:Characters())
end

function meta:GetExamineRange(visible)
	if visible and GAMEMODE.Flashbang - CurTime() > 2 then
		return 0
	end

	local range = GAMEMODE:GetConfig("ExamineRange")
	local weapon = self:GetActiveWeapon()

	if IsValid(weapon) and weapon.GetExamineRange then
		range = weapon:GetExamineRange(range)
	end

	return range
end

hook.Add("PlayerSpawnDataChanged", "character.PlayerSpawnDataChanged", function(ply, old, new)
	ply.SpawnData = pon.decode(new)
end)