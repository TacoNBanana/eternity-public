AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 	= "ent_base"

ENT.Model 	= Model("models/weapons/w_npcnade.mdl")

ENT.Damage 	= 175
ENT.Radius 	= 250

function ENT:SetTimer(delay)
	self.Detonate = CurTime() + delay
	self.Beep = CurTime()

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

		local attachment = self:LookupAttachment("fuse")
		local pos = self:GetAttachment(attachment).Pos

		local main = ents.Create("env_sprite")

		main:SetPos(pos)
		main:SetParent(self)
		main:SetKeyValue("model", "sprites/redglow1.vmt")
		main:SetKeyValue("scale", 0.2)
		main:SetKeyValue("GlowProxySize", 4)
		main:SetKeyValue("rendermode", 5)
		main:SetKeyValue("renderamt", 200)
		main:Spawn()
		main:Activate()

		local trail = ents.Create("env_spritetrail")

		trail:SetPos(pos)
		trail:SetParent(self)
		trail:SetKeyValue("spritename", "sprites/bluelaser1.vmt")
		trail:SetKeyValue("startwidth", 8)
		trail:SetKeyValue("endwidth", 1)
		trail:SetKeyValue("lifetime", 0.5)
		trail:SetKeyValue("rendermode", 5)
		trail:SetKeyValue("rendercolor", "255 0 0")
		trail:Spawn()
		trail:Activate()

		self:DeleteOnRemove(main)
		self:DeleteOnRemove(trail)
	end
end

function ENT:Explode()
	local pos = self:WorldSpaceCenter()

	util.ScreenShake(pos, 25, 150, 1, self.Radius)

	local explo = ents.Create("env_explosion")
	explo:SetOwner(self:GetOwner())
	explo:SetPos(pos)
	explo:SetKeyValue("iMagnitude", self.Damage)
	explo:SetKeyValue("iRadiusOverride", self.Radius)
	explo:Spawn()
	explo:Activate()
	explo:Fire("Explode")

	self:Remove()
end

function ENT:Think()
	if CLIENT then
		return
	end

	if self.Beep and self.Beep <= CurTime() then
		self:EmitSound("Grenade.Blip")

		local time = 1

		if self.Detonate and self.Detonate - CurTime() <= 1.5 then
			time = 0.3
		end

		self.Beep = CurTime() + time
	end

	if self.Detonate and self.Detonate <= CurTime() then
		self:Explode()
		self:NextThink(math.huge)

		return true
	end

	self:NextThink(CurTime() + 0.1)

	return true
end