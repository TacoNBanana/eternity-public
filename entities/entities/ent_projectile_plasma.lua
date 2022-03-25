AddCSLuaFile()
DEFINE_BASECLASS("ent_projectile_base")

ENT.Base 					= "ent_projectile_base"

ENT.RenderGroup 			= RENDERGROUP_TRANSLUCENT

ENT.Author 					= "TankNut"

ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

ENT.AutomaticFrameAdvance	= true

ENT.Velocity 				= 6350

ENT.UseGravity 				= false

ENT.Length 					= 50
ENT.Color 					= Color(0, 255, 255)

ENT.DamageRange 			= {20, 40}

function ENT:Initialize()
	BaseClass.Initialize(self)

	self:DrawShadow(false)

	if CLIENT then
		local pos = self:GetPos()
		local mins, maxs = pos, pos + (self:GetForward() * -self.Length)

		OrderVectors(mins, maxs)

		self:SetRenderBoundsWS(mins, maxs)
	end
end

if SERVER then
	function ENT:OnHit(tr)
		self:FireBullets({
			Src = self:GetPos(),
			Dir = self:GetForward(),
			Attacker = self:GetOwner(),
			Spread = Vector(0, 0, 0),
			Tracer = 0,
			Damage = math.random(unpack(self.DamageRange)),
			Callback = function(attacker, trace, dmg)
				dmg:SetDamageType(DMG_ENERGYBEAM)
			end
		})

		self:SetPos(tr.HitPos)
		self:SetStopPos(tr.HitPos)

		netstream.Send("ImpactSound", {HitPos = tr.HitPos, Plasma = true})

		SafeRemoveEntityDelayed(self, 1)
	end
end

if CLIENT then
	local mat = Material("effects/draconic_halo/hunter_beam")
	local sprite = Material("sprites/glow04_noz")

	function ENT:DrawTranslucent()
		if self.StopRender then
			return
		end

		local origin = self:GetPos()

		if origin:Distance(self:GetOwner():GetShootPos()) < self.Length * 2 then
			return
		end

		local length = self.Length
		local stop = self:GetStopPos()

		if stop != vector_origin and stop:Distance(origin) < 0.1 then
			self.StopRender = true
		end

		local dist = self:GetStartPos():Distance(origin)
		local start = (dist / length) / 4

		render.SetMaterial(mat)
		render.DrawBeam(origin, origin + (self:GetForward() * -length), 20, start + 1, start, self.Color)

		render.SetMaterial(sprite)
		render.DrawSprite(origin, 20, 20, self.Color)
	end
end