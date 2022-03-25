include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then
		return
	end

	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal * 5)
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply

	return ent
end

function ENT:addRotors()
	self:base("wac_hc_base").addRotors(self)

	self.topRotor:SetNotSolid(true)
	self.backRotor:SetNotSolid(true)
	self.backRotor:SetNoDraw(true)
end

function ENT:KillTopRotor()
	self:setEngine(false)
	self:SetNWFloat("up", 0)
	self:SetNWFloat("uptime", 0)
	self.rotorRpm = 0
	self:setVar("rotorRpm", 0)

	self.topRotor:Remove()
	self.topRotor = nil
end

function ENT:CustomThink()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self:SetAngularVelocity(phys:GetAngleVelocity())
	end
end