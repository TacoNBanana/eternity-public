local meta = FindMetaTable("Player")
local emeta = FindMetaTable("Entity")

function meta:GetSandboxLimit(str)
	local config = GAMEMODE:GetConfig("SandboxLimits")[self:ToolTrust()]

	return config[str] or cvars.Number("sbox_max" .. str, 0)
end

function meta:CheckLimits(index)
	if self:GetCount(index) >= self:GetSandboxLimit(index) then
		return false
	end

	return true
end

local propblacklist = {
	["persist"] = true,
	["drive"] = true,
	["bonemanipulate"] = true,
	["remove"] = true,
	["npc_bigger"] = true,
	["npc_smaller"] = true
}

function GM:CanProperty(ply, property, ent)
	if not ply:IsAdmin() then
		return false
	end

	if ent:PermaProp() then
		return false
	end

	if propblacklist[prop] then
		return false
	end

	return true
end

function GM:CanDrive(ply, ent)
	return false
end

function GM:RemovePlayer(ply, target, tr)
	local ed = EffectData()

	ed:SetEntity(target)

	util.Effect("entity_remove", ed, true, true)

	local weapon = ply:GetActiveWeapon()

	if IsValid(weapon) then
		weapon:EmitSound("Airboat.FireGunRevDown")
		weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		ply:SetAnimation(PLAYER_ATTACK1)

		ed = EffectData()
		ed:SetOrigin(tr.HitPos)
		ed:SetStart(ply:GetShootPos())
		ed:SetAttachment(1)
		ed:SetEntity(weapon)

		util.Effect("ToolTracer", ed)
	end

	ed = EffectData()
	ed:SetOrigin(tr.HitPos)
	ed:SetNormal(tr.HitNormal)
	ed:SetEntity(target)
	ed:SetAttachment(tr.PhysicsBone)

	util.Effect("selection_indicator", ed)

	if SERVER then
		local nick = target:RPName()

		target:Kick("Kicked by " .. ply:Nick())

		GAMEMODE:SendChat("NOTICE", string.format("%s has removed %s.", ply:Nick(), nick))
	end
end

function meta:CanUseTool(tool)
	if self:IsAdmin() then
		return true
	end

	if self:ToolTrust() == TOOLTRUST_BANNED then
		return false
	end

	for i = TOOLTRUST_BASIC, self:ToolTrust() do
		local tools = GAMEMODE:GetConfig("ToolTrust")[i]

		for _, v in pairs(tools) do
			if string.find(tool, v) then
				return true
			end
		end
	end

	return false
end

function emeta:IsProtectedEntity()
	if self:PermaProp() then
		return true
	end

	for _, v in pairs(GAMEMODE:GetConfig("ProtectedEntities")) do
		if string.find(self:GetClass(), v) then
			return true
		end
	end

	return false
end

local toolblacklist = {
	["paint"] = true,
	["duplicator"] = true,
	["creator"] = true,
	["rb655_easy_inspector"] = true,
	["leafblower"] = true
}

local worldblacklist = {
	["remover"] = true,
	["advmat"] = true,
	["submaterial"] = true,
	["material"] = true,
	["colour"] = true,
	["rb655_easy_bodygroup"] = true,
	["nocollideworld"] = true
}

function GM:WriteToolLog(ply, tr, tool)
	if toolblacklist[tool] then
		return false
	end

	if worldblacklist[tool] and tr.Entity == game.GetWorld() then
		return false
	end

	if IsValid(tr.Entity) and tr.Entity:GetClass() == "gmod_" .. tool then
		return false
	end

	return true
end

function GM:CanTool(ply, tr, tool)
	local ent = tr.Entity

	if ply:IsDeveloper() and IsValid(ent) and ent:IsPlayer() and tool == "remover" then
		self:RemovePlayer(ply, ent, tr)

		return true
	end

	if not ply:CanUseTool(tool) then
		return false
	end

	if IsValid(ent) then
		if (ent:IsPlayer() or ent:IsNPC()) and not ply:IsAdmin() then
			return false
		end

		if IsValid(ent:FakePlayer()) then
			return false
		end

		if ent:IsProtectedEntity() then
			return false
		end

		if ent.CanTool and not ent:CanTool(ply, tool) then
			return false
		end
	end

	if ply:IsAdmin() then
		if SERVER and self:WriteToolLog(ply, tr, tool) then
			GAMEMODE:WriteLog("sandbox_tool", {
				Char = GAMEMODE:LogCharacter(ply),
				Ply = GAMEMODE:LogPlayer(ply),
				Tool = tool,
				Ent = tostring(tr.Entity)
			})
		end

		return true
	else
		local bool = self.BaseClass:CanTool(ply, tr, tool)

		if SERVER and bool and self:WriteToolLog(ply, tr, tool) then
			GAMEMODE:WriteLog("sandbox_tool", {
				Char = GAMEMODE:LogCharacter(ply),
				Ply = GAMEMODE:LogPlayer(ply),
				Tool = tool,
				Ent = tostring(tr.Entity)
			})
		end

		return true
	end
end

function GM:PhysgunPickup(ply, ent)
	if ent:IsProtectedEntity() or (ent.CanPhys and not ent:CanPhys(ply)) then
		return false
	end

	if ply:IsAdmin() and ent:IsPlayer() and ply:AdminLevel() >= ent:AdminLevel() then
		ent:SetMoveType(MOVETYPE_NOCLIP)

		return true
	end

	if not ply:IsAdmin() then
		local steam = ent:SteamID()

		if ply:ToolTrust() != TOOLTRUST_ADVANCED and steam and steam != ply:SteamID() then
			return false
		end

		if ent:IsNPC() then
			return false
		end
	end

	return self.BaseClass:PhysgunPickup(ply, ent)
end

function GM:PhysgunDrop(ply, ent)
	self.BaseClass:PhysgunDrop(ply, ent)

	if not ply:IsAdmin() then
		ent:SetVelocity(Vector())
	end

	if ent:IsPlayer() then
		ent:SetMoveType(MOVETYPE_WALK)
	end
end