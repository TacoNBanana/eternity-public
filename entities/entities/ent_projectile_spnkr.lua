AddCSLuaFile()
DEFINE_BASECLASS("ent_projectile_base")

ENT.Base 					= "ent_projectile_base"

ENT.RenderGroup 			= RENDERGROUP_OPAQUE

ENT.Author 					= "TankNut"

ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

ENT.AutomaticFrameAdvance	= true

ENT.Model 					= Model("models/vuthakral/halo/weapons/spnkr_rocket.mdl")

ENT.Velocity 				= 8000

ENT.UseGravity 				= false

ENT.LoopSound 				= Sound("vuthakral/halo/weapons/spnkr/rocketloop.wav")

ENT.Damage 					= 200
ENT.Radius 					= 200

function ENT:Initialize()
	BaseClass.Initialize(self)

	if SERVER then
		local trail = ents.Create("env_rockettrail")

		trail:SetSaveValue("m_SpawnRate", 100)
		trail:SetSaveValue("m_ParticleLifetime", 0.5)

		trail:SetSaveValue("m_EndColor", Vector(0, 0, 0))

		trail:SetSaveValue("m_StartSize", 8)
		trail:SetSaveValue("m_EndSize", 32)

		trail:SetSaveValue("m_SpawnRadius", 4)

		trail:SetSaveValue("m_MinSpeed", 2)
		trail:SetSaveValue("m_MaxSpeed", 16)

		trail:SetPos(self:GetPos())
		trail:SetAngles(self:GetAngles())

		trail:SetParent(self)

		trail:Spawn()
		trail:Activate()

		self:EmitSound(self.LoopSound)
	end
end

if SERVER then
	function ENT:OnHit(tr)
		local ent = tr.Entity

		if IsValid(ent) and ent:IsPlayer() then
			local info = DamageInfo()

			info:SetDamage(2000)
			info:SetAttacker(self:GetOwner())
			info:SetInflictor(self)
			info:SetDamageType(DMG_BLAST)

			ent:TakeDamageInfo(info)
		end

		self:StopSound(self.LoopSound)

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
			Type = EXPLOSION_SPNKR
		})

		SafeRemoveEntity(self)
	end
end