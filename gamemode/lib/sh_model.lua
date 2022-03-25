module("model", package.seeall)

local hiddenMat = "engine/occlusionproxy"
local modelCache = {}

function GetMaterials(ent)
	local mdl = ent:GetModel()

	if not modelCache[mdl] then
		modelCache[mdl] = ent:GetMaterials()
	end

	return modelCache[mdl]
end

function SetNumBodygroup(ent, group, index)
	local id

	for _, v in pairs(ent:GetBodyGroups()) do
		if string.gsub(v.name, " ", "_") == group then
			id = v.id

			break
		end
	end

	if id then
		ent:SetBodygroup(id, index)
	end
end

function SetSubmodels(ent, models)
	for _, group in pairs(ent.GetBodyGroups()) do
		for index, submodel in pairs(group.submodels) do
			if table.HasValue(models, submodel) then
				ent:SetBodygroup(group.id, index)
			end
		end
	end
end

function HideHead(ent)
	for k, v in pairs(GetMaterials(ent)) do
		if not string.find(v, "hands") and not string.find(v, "gloves") then
			ent:SetSubMaterial(k - 1, hiddenMat)
		end
	end
end