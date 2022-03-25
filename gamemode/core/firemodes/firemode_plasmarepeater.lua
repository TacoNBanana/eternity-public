FIREMODE = class.Create("firemode_plasmarifle")

FIREMODE.Automatic 	= true

FIREMODE.ClipSize 	= -1
FIREMODE.Name 		= "Type-51"

function FIREMODE:GetDelay()
	local heat = self.Weapon:GetHeat() * 0.01
	local trigger = self:Get("DelayTrigger")

	if heat > trigger then
		return math.Remap(heat, trigger, 1, self:Get("MinDelay"), self:Get("MaxDelay"))
	end

	return self:Get("MinDelay")
end

function FIREMODE:CanReload()
	if self.Weapon:IsReloading() then
		return false
	end

	if self.Weapon:GetHeat() == 0 then
		return false
	end

	return true
end

function FIREMODE:Reload()
	local duration = self.Weapon:PlayAnimation("vent_start")

	if CLIENT then
		self.Weapon:EmitSound("drc.repeater_ventopen")
	end

	self.Weapon:EmitSound("drc.repeater_ventloop")

	self.Weapon:SetFinishReload(CurTime() + duration)
	self.Weapon:SetNextPrimaryFire(CurTime() + duration)
end

function FIREMODE:CanFire()
	if self.Weapon:GetAmmoType() == "" then
		return false
	end

	if self.Weapon:ShouldLower() then
		return false
	end

	if self.Weapon:IsReloading() then
		return false
	end

	if self.Weapon:GetHeat() >= 100 then
		return false
	end

	if self.Weapon.Primary.ClipSize > 0 and self.Weapon:Clip1() <= 0 then
		return false
	end

	return true
end

function FIREMODE:Fire()
	local ply = self.Weapon.Owner
	local delay = self:GetDelay()

	ply:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	self.Weapon:SetHeat(self.Weapon:GetHeat() + self:Get("HeatRate"))

	local animated = self.Weapon.Animated

	if self.Weapon:AimingDownSights() then
		animated = self.Weapon.AnimatedADS
	end

	local animation = "fire"

	if delay == -1 then
		delay = self.Weapon:PlayAnimation(animation)
	elseif animated then
		self.Weapon:PlayAnimation(animation)
	else
		self.Weapon:PlayAnimation(animation, 1, 1)
	end

	self:GetAmmo():OnFired(ply, self.Weapon, self.Weapon.CurrentCone)

	self.Weapon:DoRecoil(self.Weapon.Recoil)

	if CLIENT and IsFirstTimePredicted() then
		self.Weapon:DoVMRecoil(self.Weapon.Recoil)
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + delay)
end

function FIREMODE:Think(delta)
	self.LastReload = self.LastReload or false

	if SERVER and not self.Weapon:IsFiring() then
		local rate = self.Weapon:IsReloading() and self:Get("ActiveCoolRate") or self:Get("CoolRate")

		self.Weapon:SetHeat(math.max(self.Weapon:GetHeat() - (rate * delta), 0))
	end

	if self.Weapon:IsReloading() and self.Weapon:GetFinishReload() <= CurTime() and self.Weapon:GetHeat() == 0 then
		local duration = self.Weapon:PlayAnimation("vent_finish")

		self.Weapon:StopSound("drc.repeater_ventloop")

		self.Weapon:SetFinishReload(0)
		self.Weapon:SetNextPrimaryFire(CurTime() + duration)
	end

	if CLIENT and not self.Weapon:IsReloading() and self.LastReload then
		self.Weapon:EmitSound("drc.repeater_ventclose")
		self.Weapon:PlayAnimation("vent_finish", 1, 0, false, self.VM, true)
	end

	self.LastReload = self.Weapon:IsReloading()
end

return FIREMODE