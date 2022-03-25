local meta = FindMetaTable("Player")

function GM:PlayerSetHandsModel(ply, ent)
	local species = ply:GetActiveSpecies()

	species:SetupHands(ply, ent)
end

function meta:HandlePlayerModel()
	if not self:HasCharacter() then
		self:ApplyModel({
			Model = table.Random({"models/crow.mdl", "models/pigeon.mdl", "models/seagull.mdl"})
		})

		self:SetModelData({})

		return
	end

	self:UpdateParts()
	self:UpdateHull()

	self:SetupHands()
end

function meta:UpdateHull()
	local hull

	for k, v in pairs(GAMEMODE:GetConfig("PlayerHulls")) do
		if string.find(string.lower(self:GetModel()), k) then
			hull = v

			break
		end
	end

	if not hull then
		self:SetHullData(false)

		return
	end

	self:SetHullData(hull)
end

function meta:UpdateGender(mdl)
	local gender = GAMEMODE:GetModelGender(mdl)

	if gender != self:Gender() then
		self:SetGender(gender)
	end
end

function meta:UpdateParts()
	local species = self:GetActiveSpecies()
	local data = species:GetModelData(self)
	local equipment = self:GetEquipment()

	self:UpdateGender(data._base.Model)

	for _, v in SortedPairs(equipment, true) do
		data = table.Merge(data, v:GetModelData(self))
	end

	for _, v in SortedPairs(equipment, true) do
		data = v:PostModelData(self, data)
	end

	self:SetScale(data._base.Scale or 1)

	self:ApplyModel(data._base)
	self:SetModelData(data)
end

hook.Add("PlayerCharModelChanged", "appearance.PlayerCharModelChanged", function(ply, old, new)
	if ply.SuppressCharacterChanges then
		return
	end

	ply:HandlePlayerModel()
end)

hook.Add("PlayerCharSkinChanged", "appearance.PlayerCharSkinChanged", function(ply, old, new)
	if ply.SuppressCharacterChanges then
		return
	end

	ply:HandlePlayerModel()
end)