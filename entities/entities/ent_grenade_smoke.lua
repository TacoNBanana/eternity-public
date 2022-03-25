AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 		= "ent_base"

ENT.Model 		= Model("models/weapons/w_npcnade.mdl")

ENT.SmokeColor 	= Vector(135, 135, 135)

function ENT:SetTimer(delay)
	self.Detonate = CurTime() + delay

	self:NextThink(CurTime())
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end
end

function ENT:Explode()
	local ed = EffectData()

	ed:SetOrigin(self:WorldSpaceCenter())
	ed:SetStart(self.SmokeColor)
	ed:SetEntity(self)

	util.Effect("eternity_smokegrenade", ed)

	SafeRemoveEntityDelayed(self, math.random(50, 90))
end

function ENT:Think()
	if CLIENT then
		return
	end

	if self.Detonate and self.Detonate <= CurTime() then
		self:Explode()
		self:NextThink(math.huge)

		return true
	end

	self:NextThink(CurTime() + 0.1)

	return true
end