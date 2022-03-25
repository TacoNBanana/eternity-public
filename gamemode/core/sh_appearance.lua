local meta = FindMetaTable("Entity")

function GM:GetModelGender(mdl)
	local gender = GENDER_OTHER

	if string.find(mdl, "/male_") then
		gender = GENDER_MALE
	elseif string.find(mdl, "/female_") then
		gender = GENDER_FEMALE
	end

	return gender
end

function GM:GetGenderString(mdl)
	local gender = GAMEMODE:GetModelGender(mdl)

	if gender == GENDER_MALE then
		return "male"
	elseif gender == GENDER_FEMALE then
		return "female"
	end

	return ""
end

function meta:GetGender()
	return GAMEMODE:GetModelGender(self:GetModel())
end

function meta:ApplyModel(tab)
	self:SetModel(tab.Model)
	self:SetSkin(tab.Skin or 0)

	if self:IsPlayer() then
		self:SetPlayerColor(tab.PlayerColor or Vector(0.24, 0.34, 0.41))
	end

	for _, v in pairs(self:GetBodyGroups()) do
		self:SetBodygroup(v.id, 0)
	end

	if tab.Bodygroups then
		for k, v in pairs(tab.Bodygroups) do
			model.SetNumBodygroup(self, k, v)
		end
	end

	self:SetSubMaterial()

	if tab.Materials then
		local materials

		for k, v in pairs(tab.Materials) do
			if isstring(k) then
				if not materials then
					materials = model.GetMaterials(self)

					if table.MakeAssociative(materials)["___error"] then
						error(string.format("Attempt to use string material replacement on %s affected by ___error", self:GetModel()))
					end
				end

				for index, mat in pairs(materials) do
					if mat == k then
						self:SetSubMaterial(index - 1, v)
					end
				end
			else
				self:SetSubMaterial(k, v)
			end
		end
	end

	if tab.HideHead then
		model.HideHead(self)
	end

	if tab.Pos then
		self:SetPos(tab.Pos)
	end

	if tab.Ang then
		self:SetAngles(tab.Ang)
	end

	if CLIENT then
		if tab.Scale then
			local mat = Matrix()

			mat:Scale(tab.Scale)

			self:EnableMatrix("RenderMultiply", mat)
		end

		if tab.Invert then
			self.RenderOverride = function(ent)
				render.CullMode(MATERIAL_CULLMODE_CW)
				ent:DrawModel()
				render.CullMode(MATERIAL_CULLMODE_CCW)
			end
		end
	end
end

hook.Add("PlayerHullDataChanged", "appearance.PlayerHullDataChanged", function(ply, old, new)
	if istable(new) then
		ply:SetHull(new[1], new[2])
		ply:SetHullDuck(new[1], new[2])

		ply:SetViewOffset(new[3])
		ply:SetViewOffsetDucked(new[3])
	else
		ply:ResetHull()

		ply:SetViewOffset(Vector(0, 0, 64))
		ply:SetViewOffsetDucked(Vector(0, 0, 28))
	end
end)