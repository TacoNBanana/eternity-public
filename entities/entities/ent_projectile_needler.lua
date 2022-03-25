AddCSLuaFile()

ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.Base 					= "ent_projectile_base"

ENT.Author 					= "TankNut"

ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

ENT.AutomaticFrameAdvance	= true

ENT.Model 					= Model("models/vuthakral/halo/weapons/w_needle.mdl")

ENT.Velocity 				= 2794

ENT.UseGravity 				= false

ENT.TurnRate 				= 15

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)

	self:NetworkVar("Entity", 0, "Target")
end

if SERVER then
	function ENT:OnHit(tr)
		self:FireBullets({
			Src = self:GetPos(),
			Dir = self:GetForward(),
			Attacker = self:GetOwner(),
			Spread = Vector(0, 0, 0),
			Tracer = 0,
			Damage = 6,
			Callback = function(attacker, trace, dmg)
				dmg:SetDamageType(DMG_ENERGYBEAM)
			end
		})

		self:SetPos(tr.HitPos)
		self:SetStopPos(tr.HitPos)

		local ent = tr.Entity

		if ent != game.GetWorld() then
			self:SetParent(ent)

			ent.Needles = ent.Needles or {}
			ent.Needles[self] = true

			if table.Count(ent.Needles) > 6 and not ent.BlockSuperCombine then
				ent.BlockSuperCombine = true

				self.SuperCombine = true
			end
		end

		self:NextThink(CurTime() + (self.SuperCombine and 0.35 or 4))
	end

	function ENT:Process(delta)
		local target = self:GetTarget()

		if not IsValid(target) then
			return
		end

		local center = target:WorldSpaceCenter()

		local diff = (center - self:GetPos()):Angle()
		local vel = self:GetVel()

		local speed = vel:Length()
		local ang = vel:Angle()

		local localang = self:WorldToLocalAngles(diff)

		if localang.y > 90 or localang.y < -90 then
			return
		end

		ang.p = math.ApproachAngle(ang.p, diff.p, self.TurnRate * delta)
		ang.y = math.ApproachAngle(ang.y, diff.y, self.TurnRate * delta)
		ang.r = 0

		self:SetVel(ang:Forward() * speed)
	end

	function ENT:Think()
		if self:GetStopPos() != vector_origin then
			local parent = self:GetParent()

			if IsValid(parent) then
				parent.Needles[self] = nil

				if self.SuperCombine then
					for k in pairs(parent.Needles) do
						if k != self then
							parent.Needles[k] = nil
							k:Remove()
						end
					end

					self:EmitSound("needler_supercombine")

					util.BlastDamage(self, self:GetOwner(), self:GetPos(), 30, 350)

					local ed = EffectData()

					ed:SetOrigin(self:GetPos())
					ed:SetStart(self:GetPos())

					util.Effect("drc_halo_ne_sc", ed)

					parent.BlockSuperCombine = nil
				end
			end

			if not self.SuperCombine then
				self:EmitSound("needler_shatter")
			end

			self:Remove()

			return
		end

		self.BaseClass.Think(self)

		return true
	end
end

if CLIENT then
	local sprite = Material("sprites/light_glow02_add")
	local color = Color(220, 0, 255)

	function ENT:Draw()
		render.SetLightingMode(2)
			self:DrawModel()
		render.SetLightingMode(0)
	end

	function ENT:DrawTranslucent()
		local pos = self:GetPos()

		render.SetMaterial(sprite)

		render.DrawSprite(pos, 8, 8, color)
		render.DrawSprite(pos, 8, 8, color)
	end
end