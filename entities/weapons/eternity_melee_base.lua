AddCSLuaFile()
DEFINE_BASECLASS("eternity_base")

SWEP.Base 			= "eternity_base"

SWEP.DrawCrosshair 	= false

SWEP.Damage 		= 15
SWEP.CDamage 		= 0

SWEP.Delay 			= 0

SWEP.DefaultOffset 	= {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 0, 0)
}

SWEP.LoweredOffset 	= {
	ang = Angle(0, 0, 0),
	pos = Vector(5, 0, -7)
}

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Holstered")

	self:NetworkVar("Int", 0, "ItemID")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "NextIdle")
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	self:PlayAnimation("idle")
end

function SWEP:Think()
	BaseClass.Think(self)

	if self:GetNextIdle() > 0 and self:GetNextIdle() <= CurTime() then
		self:PlayAnimation("idle")
		self:SetNextIdle(-1)
	end
end

function SWEP:GetItem()
	return GAMEMODE:GetItem(self:GetItemID())
end

function SWEP:ShouldLower()
	return self:GetHolstered()
end

function SWEP:OnAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if CLIENT then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:OnHit()
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
end

function SWEP:OnMiss()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PrimaryAttack()
	if self:ShouldLower() then
		return
	end

	local ply = self.Owner

	self:OnAttack()

	local trace = {
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + (ply:GetAimVector() * 50),
		filter = ply,
		mins = Vector(-8, -8, -8),
		maxs = Vector(8, 8, 8)
	}

	local tr = util.TraceHull(trace)
	local duration = 0

	if tr.Hit then
		self:OnHit()

		trace.endpos = ply:GetShootPos() + (ply:GetAimVector() * 100)

		local line = util.TraceLine(trace)
		local damage, damagetype = self:GetDamage()

		local dmg = DamageInfo()
		dmg:SetAttacker(ply)
		dmg:SetDamage(damage)
		dmg:SetDamageForce(tr.Normal * 50)
		dmg:SetDamagePosition(tr.HitPos)
		dmg:SetDamageType(damagetype)
		dmg:SetInflictor(self)

		if tr.Entity.DispatchTraceAttack then
			tr.Entity:DispatchTraceAttack(dmg, tr)
		end

		if SERVER then
			local cdamage = self:GetCDamage()

			if cdamage > 0 then
				if tr.Entity:IsPlayer() then
					tr.Entity:TakeCDamage(cdamage)
				elseif IsValid(tr.Entity:FakePlayer()) then
					tr.Entity:FakePlayer():TakeCDamage(cdamage)
				end
			end
		end

		if IsFirstTimePredicted() and line.Hit then
			local data = EffectData()

			data:SetOrigin(line.HitPos)
			data:SetStart(line.StartPos)
			data:SetNormal(line.HitNormal)
			data:SetSurfaceProp(line.SurfaceProps)
			data:SetDamageType(damagetype)
			data:SetHitBox(line.HitBox)
			data:SetEntity(line.Entity)

			util.Effect("Impact", data)

			if self.Effect then
				util.Effect(self.Effect, data)
			end
		end

		duration = self:PlayAnimation("hit")
	else
		self:OnMiss()

		duration = self:PlayAnimation("miss")
	end

	self:SetNextIdle(CurTime() + duration)

	if self.Delay > 0 then
		duration = self.Delay
	end

	self:SetNextModeSwitch(CurTime() + duration)
	self:SetNextPrimaryFire(CurTime() + duration)
end

function SWEP:SecondaryAttack()
end

function SWEP:GetDamage()
	return self.Damage, DMG_CRUSH
end

function SWEP:GetCDamage()
	return self.CDamage
end

function SWEP:ToggleHolster()
	if CurTime() < self:GetNextModeSwitch() then
		return
	end

	local bool = not self:GetHolstered()
	local duration = 1

	self:SetHolstered(bool)

	self:SetNextModeSwitch(CurTime() + duration)
	self:SetNextPrimaryFire(CurTime() + duration)
end