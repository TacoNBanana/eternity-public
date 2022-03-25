module("part", package.seeall)

Data = Data or {}
Ents = Ents or {}

local function CreateEnt(parent, tab)
	if IsValid(tab.Ent) then
		tab.Ent:Remove()
	end

	local ent = ClientsideModel(tab.Model)

	table.insert(Ents, ent)

	ent:ApplyModel(tab)
	ent:SetParent(parent)

	if not tab.NoMerge then
		ent:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
	end

	ent.RenderOverride = function(self)
		if tab.Invert then
			render.CullMode(MATERIAL_CULLMODE_CW)
		end

		self:SetupBones()
		self:CreateShadow()
		self:DrawModel()

		render.CullMode(MATERIAL_CULLMODE_CCW)
	end

	tab.Ent = ent

	return ent
end

function Add(parent, name, data)
	Data[parent] = Data[parent] or {}

	local parts = Data[parent]

	if parts[name] then
		Clear(parent, name)
	end

	parts[name] = table.Copy(data)

	return CreateEnt(parent, parts[name])
end

function Get(parent, name)
	if Data[parent] then
		return name and Data[parent][name] or Data[parent]
	end
end

function Clear(parent, name)
	if Data[parent] then
		local parts = Data[parent]

		if name then
			local ent = parts[name].Ent

			if IsValid(ent) then
				ent:Remove()
			end

			parts[name] = nil
		else
			for _, v in pairs(parts) do
				if IsValid(v.Ent) then
					v.Ent:Remove()
				end
			end

			Data[parent] = nil
		end
	end
end

function Copy(parent, target)
	if not Data[parent] then
		return
	end

	local data = table.Copy(Data[parent])

	for _, v in pairs(data) do
		v.Ent = nil
	end

	Data[target] = data
end

hook.Add("CreateClientsideRagdoll", "part.CreateClientsideRagdoll", function(ent, ragdoll)
	Copy(ent, ragdoll)
end)

hook.Add("Think", "part.Think", function()
	for parent, tab in pairs(Data) do
		if not IsValid(parent) then
			Data[parent] = nil

			continue
		end

		for _, v in pairs(tab) do
			if not IsValid(v.Ent) then
				CreateEnt(parent, v)
			end

			local nodraw = parent:GetNoDraw()

			if parent:IsDormant() then
				nodraw = true
			elseif parent:IsPlayer() and not nodraw then
				nodraw = not parent:Alive()
			end

			if v.Ent:GetParent() != parent then
				v.Ent:SetParent(parent)
			end

			v.Ent:SetNoDraw(nodraw)
		end
	end

	for k, v in pairs(Ents) do
		if not IsValid(v) then
			Ents[k] = nil

			continue
		end

		if IsValid(v:GetParent()) then
			continue
		end

		Ents[k] = nil

		v:Remove()
	end
end)