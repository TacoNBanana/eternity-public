local meta = FindMetaTable("Entity")
local pmeta = FindMetaTable("Player")

local function IsGib(ent)
	if ent:GetClass() == "gib" then
		return true
	end

	if ent:GetClass() == "prop_physics" and ent:GetModel() and string.find(ent:GetModel(), "gib") and ent:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then
		return true
	end

	return false
end

hook.Add("OnEntityCreated", "npc.OnEntityCreated", function(ent)
	if not IsValid(ent) then
		return
	end

	if ent:IsNPC() then
		ent.HatedPlayers = {}

		local skill = GAMEMODE:GetConfig("NPCSkill")

		if skill[ent:GetClass()] then
			ent:SetCurrentWeaponProficiency(skill[ent:GetClass()])
		end

		ent:HandleRelationships()
	elseif IsGib(ent) then
		timer.Simple(GAMEMODE:GetConfig("RagdollTimeout"), function()
			if not IsValid(ent) then
				return
			end

			ent:Remove()
		end)
	end
end)

hook.Add("OnNPCKilled", "npc.OnNPCKilled", function(npc)
	local pos = npc:GetPos()
	local radius = npc:GetModelRadius()
	local weapon = npc:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:Remove()
	end

	timer.Simple(0, function()
		for _, v in pairs(ents.FindInSphere(pos, radius)) do
			if not IsValid(v) then
				continue
			end

			if string.Left(v:GetClass(), 5) == "item_" then
				v:Remove()
			end
		end
	end)
end)

function pmeta:ClearNPCRelationships()
	for _, v in pairs(ents.GetAll()) do
		if v:IsNPC() and v.HatedPlayers then
			v.HatedPlayers[self] = nil
		end
	end
end

function pmeta:HandleNPCRelationships()
	for _, v in pairs(ents.GetAll()) do
		if v:IsNPC() and v.HandlePlayerRelationship then
			v:HandlePlayerRelationship(self)
		end
	end
end

function meta:HandleRelationships()
	for _, v in pairs(player.GetAll()) do
		self:HandlePlayerRelationship(v)
	end
end

function meta:HandlePlayerRelationship(ply)
	if not IsValid(ply) then
		return
	end

	if ply:Team() == TEAM_UNKNOWN then
		self:AddEntityRelationship(ply, D_LI, 99)

		return
	end

	if self.HatedPlayers[ply] then
		self:AddEntityRelationship(ply, D_HT, 99)

		return
	end

	local relationships = GAMEMODE:GetConfig("NPCRelationships")[self:GetClass()]

	if not relationships then
		return
	end

	local disposition = relationships[ply:Team()]

	if not disposition then
		return
	end

	if disposition == D_NU then
		for _, v in pairs(ply:GetEquipment()) do
			if v.TriggersNPCs then
				disposition = D_HT

				break
			end
		end
	end

	if disposition == D_HT then
		self.HatedPlayers[ply] = true
	end

	self:AddEntityRelationship(ply, disposition, 99)
end