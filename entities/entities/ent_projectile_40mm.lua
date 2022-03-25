AddCSLuaFile()
DEFINE_BASECLASS("ent_projectile_base")

ENT.Base 					= "ent_projectile_base"

ENT.RenderGroup 			= RENDERGROUP_OPAQUE

ENT.Author 					= "TankNut"

ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

ENT.AutomaticFrameAdvance	= true

ENT.Model 					= Model("models/vuthakral/halo/weapons/m139_grenade.mdl")

ENT.Velocity 				= 2000

ENT.UseGravity 				= true
ENT.GravityMultiplier 		= 1

ENT.Damage 					= 100
ENT.Radius 					= 100

function ENT:Initialize()
	BaseClass.Initialize(self)

	if SERVER then
		local trail = ents.Create("env_smoketrail")

		trail:SetSaveValue("m_Opacity", 0.2)
		trail:SetSaveValue("m_SpawnRate", 96)
		trail:SetSaveValue("m_ParticleLifetime", 1)

		trail:SetSaveValue("m_StartColor", Vector(0.1, 0.1, 0.1))
		trail:SetSaveValue("m_EndColor", Vector(0, 0, 0))

		trail:SetSaveValue("m_StartSize", 12)
		trail:SetSaveValue("m_EndSize", 48)

		trail:SetSaveValue("m_SpawnRadius", 4)

		trail:SetSaveValue("m_MinSpeed", 4)
		trail:SetSaveValue("m_MaxSpeed", 24)

		trail:SetPos(self:GetPos())
		trail:SetAngles(self:GetAngles())

		trail:SetParent(self)

		trail:Spawn()
		trail:Activate()
	end
end

if SERVER then
	function ENT:OnHit(tr)
		local ent = tr.Entity

		if IsValid(ent) and ent:IsPlayer() then
			local info = DamageInfo()

			info:SetDamage(self.Damage)
			info:SetAttacker(self:GetOwner())
			info:SetInflictor(self)
			info:SetDamageType(DMG_BLAST)

			ent:TakeDamageInfo(info)
		end

		util.ScreenShake(tr.HitPos, 25, 150, 1, self.Radius)

		local explo = ents.Create("env_explosion")
		explo:SetOwner(self:GetOwner())
		explo:SetPos(tr.HitPos)
		explo:SetKeyValue("spawnflags", 64)
		explo:SetKeyValue("iMagnitude", self.Damage)
		explo:SetKeyValue("iRadiusOverride", self.Radius)
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode")

		netstream.Send("DistantExplosion", {
			Pos = tr.HitPos,
			Type = EXPLOSION_40MM
		})

		SafeRemoveEntity(self)
	end
end