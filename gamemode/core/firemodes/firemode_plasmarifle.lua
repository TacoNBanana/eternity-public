FIREMODE = class.Create("firemode_semi")

FIREMODE.Automatic 	= true

FIREMODE.ClipSize 	= -1
FIREMODE.Name 		= "Type-25"
FIREMODE.Ammo 		= "ammo_plasmarifle"

FIREMODE.OverheatSound = "drc.plasmarifle_overheat"

function FIREMODE:SwitchTo()
	self.Weapon.Primary.ClipSize = self:Get("ClipSize")
	self.Weapon.Primary.Automatic = self.Automatic

	self.Weapon:SetClip1(-1)
	self.Weapon:SetAmmoType(self:Get("Ammo"))
end

function FIREMODE:SwitchFrom()
end

function FIREMODE:GetDelay()
	return self.Weapon:GetFireDuration() > self:Get("DelayRamp") and self:Get("MinDelay") or self:Get("MaxDelay")
end

function FIREMODE:CanReload()
	return false
end

function FIREMODE:Reload()
end

function FIREMODE:CanFire()
	if self.Weapon:GetAmmoType() == "" then
		return false
	end

	if self.Weapon:ShouldLower() then
		return false
	end

	if self.Weapon:IsOverheating() then
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
	local overheating = self.Weapon:GetHeat() >= 100

	if overheating then
		self.Weapon:SetOverheating(true)

		animation = "overheat"
	end

	if delay == -1 then
		delay = self.Weapon:PlayAnimation(animation)
	elseif animated then
		self.Weapon:PlayAnimation(animation)
	else
		self.Weapon:PlayAnimation(animation, 1, 1)
	end

	self:GetAmmo():OnFired(ply, self.Weapon, self.Weapon.CurrentCone)

	self.Weapon:DoRecoil(self.Weapon.Recoil)

	if overheating then
		self.Weapon:EmitSound(self:Get("OverheatSound"))
	end

	if CLIENT and IsFirstTimePredicted() then
		self.Weapon:DoVMRecoil(self.Weapon.Recoil)
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + delay)
end

function FIREMODE:Think(delta)
	if SERVER and not self.Weapon:IsFiring() then
		self.Weapon:SetHeat(math.max(self.Weapon:GetHeat() - (self:Get("CoolRate") * delta), 0))

		if self.Weapon:IsOverheating() and self.Weapon:GetHeat() == 0 then
			self.Weapon:SetOverheating(false)
			self.Weapon:CallOnClient("FinishOverheat")
		end
	end
end

if CLIENT then
	function FIREMODE:GetAmmoDisplay()
		return "<font=eternity.ammo><ol>" .. math.Round(self.Weapon:GetHeat())
	end

	function FIREMODE:GetFiremodeDisplay()
		return "<font=eternity.labelgiant><ol>" .. self.Name
	end
end

return FIREMODE