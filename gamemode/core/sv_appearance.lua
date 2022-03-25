local meta = FindMetaTable("Player")

function GM:PlayerSetHandsModel(ply, ent)
	local tab = table.Copy(player_manager.TranslatePlayerHands(ply:GetModel()))

	for _, v in pairs(ply:GetEquipment()) do
		if v.Gloves then
			tab.body = string.SetChar(tab.body, 2, "1")
		end

		if v.HandsModel then
			tab.model = v.HandsModel
		end
	end

	ent:SetModel(tab.model)
	ent:SetSkin(tab.skin)
	ent:SetBodyGroups(tab.body)
end

function meta:HandlePlayerModel()
	if not self:HasCharacter() then
		self:ApplyModel({
			Model = table.Random({"models/crow.mdl", "models/pigeon.mdl", "models/seagull.mdl"})
		})

		self:SetModelData({})

		return
	end

	self:UpdateGender()
	self:UpdateParts()
	self:UpdateHull()

	self:SetupHands()
end

function meta:UpdateHull()
	local hull = GAMEMODE:GetConfig("PlayerHulls")[string.lower(self:GetModel())]

	if not hull then
		self:SetHullData(false)

		return
	end

	self:SetHullData(hull)
end

function meta:UpdateGender()
	local gender = GAMEMODE:GetModelGender(self:GetModel())

	if gender != self:Gender() then
		self:SetGender(gender)
	end
end

function meta:UpdateParts()
	local species = self:GetActiveSpecies()
	local data = species:GetModelData(self)
	local equipment = self:GetEquipment()

	for _, v in SortedPairs(equipment, true) do
		data = table.Merge(data, v:GetModelData(self))
	end

	for _, v in SortedPairs(equipment, true) do
		data = v:PostModelData(self, data)
	end

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