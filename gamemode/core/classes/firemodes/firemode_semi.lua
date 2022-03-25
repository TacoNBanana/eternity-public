FIREMODE = class.Create()

FIREMODE.Name 			= "Semi"

FIREMODE.Automatic 		= false

-- false reverts back to the weapon
FIREMODE.ClipSize 		= false
FIREMODE.AmmoGroup 		= false

FIREMODE.Weapon = nil

function FIREMODE:OnCreated(weapon)
	self.Weapon = weapon
end

function FIREMODE:Get(var)
	return self[var] or self.Weapon[var]
end

function FIREMODE:GetAmmoItem()
	return self.Weapon:GetItem():GetAmmo(self:Get("AmmoGroup"))
end

function FIREMODE:SwitchTo()
	self.Weapon.Primary.ClipSize = self:Get("ClipSize")
	self.Weapon.Primary.Automatic = self.Automatic

	local group = self:Get("AmmoGroup")
	local saved = self.Weapon.SavedAmmo[group]

	if saved then
		self.Weapon:SetClip1(saved.Clip)
		self.Weapon:SetAmmoType(saved.Ammo)

		self.Weapon.SavedAmmo[group] = nil
	else
		self.Weapon:SetClip1(0)
		self.Weapon:SetAmmoType("")
	end
end

function FIREMODE:SwitchFrom()
	self.Weapon.SavedAmmo[self:Get("AmmoGroup")] = {Clip = self.Weapon:Clip1(), Ammo = self.Weapon:GetAmmoType()}
end

function FIREMODE:CanSwitch()
	return not self.Weapon:IsReloading()
end

function FIREMODE:CanFire()
	if self.Weapon:GetAmmoType() == "" then
		return false
	end

	if self.Weapon:ShouldLower() then
		return false
	end

	if self.Weapon.Primary.ClipSize > 0 and self.Weapon:Clip1() <= 0 then
		return false
	end

	return true
end

function FIREMODE:GetDelay()
	local delay = self:Get("Delay")

	if delay == -1 then
		return delay
	end

	return delay * math.ClampedRemap(self.Weapon:GetDurability(), 85, 0, 1, 1.2)
end

function FIREMODE:Fire()
	local ply = self.Weapon.Owner
	local delay = self:GetDelay()

	ply:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local animated = self.Weapon.Animated

	if self.Weapon:AimingDownSights() then
		animated = self.Weapon.AnimatedADS
	end

	local animation = "fire"

	if self.Weapon:Clip1() <= 1 and self.Weapon.Animations.fire_last then
		animation = "fire_last"
	end

	if delay == -1 then
		delay = self.Weapon:PlayAnimation(animation)
	elseif animated then
		self.Weapon:PlayAnimation(animation)
	else
		self.Weapon:PlayAnimation(animation, 1, 1)
	end

	GAMEMODE:GetAmmo(self.Weapon:GetAmmoType()):OnFired(ply, self.Weapon, self.Weapon.CurrentCone)

	self.Weapon:DoRecoil(self.Weapon.Recoil)

	if CLIENT and IsFirstTimePredicted() then
		self.Weapon:DoVMRecoil(self.Weapon.Recoil)
	end

	if self.Weapon.PumpAction and self.Weapon:Clip1() > 1 then
		self.Weapon:SetNeedPump(true)
	end

	self.Weapon:TakePrimaryAmmo(1)
	self.Weapon:SetNextPrimaryFire(CurTime() + delay)

	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		self.Weapon.StoredBullets = self.Weapon.StoredBullets + 1
	end

	if SERVER then
		self.Weapon:HandleDurability()
	end
end

function FIREMODE:CanReload()
	local item = self:GetAmmoItem()

	if not item then
		return false
	end

	if self.Weapon:ShouldLower() then
		return false
	end

	if self.Weapon:IsReloading() then
		return false
	end

	if self.Weapon:GetNextPrimaryFire() > CurTime() then
		return false
	end

	if item.Ammo == self.Weapon:GetAmmoType() and self.Weapon:Clip1() >= self.Weapon.Primary.ClipSize then
		return false
	end

	return true
end

function FIREMODE:Reload()
	local animation = "reload"
	local act = ACT_VM_RELOAD

	if self.Weapon:Clip1() == 0 and self.Weapon.Animations.reload_empty then
		animation = "reload_empty"
		act = ACT_VM_RELOAD_EMPTY
	end

	self.Weapon.Owner:SetAnimation(PLAYER_RELOAD)
	self.Weapon:SendWeaponAnim(act)

	local duration = self.Weapon:PlayAnimation(animation)

	if self.Weapon.PumpAction and self.Weapon:Clip1() == 0 then
		self.Weapon:SetNeedPump(true)
	end

	if self.Weapon.ShotgunReload then
		self.Weapon:SetFirstReload(true)
	end

	self.Weapon:SetFinishReload(CurTime() + duration)
	self.Weapon:SetNextPrimaryFire(CurTime() + duration)
end

function FIREMODE:Think()
	if self.Weapon:IsReloading() and self.Weapon:GetFinishReload() <= CurTime() then
		self:HandleReload()
	end

	if self.Weapon:GetNextPrimaryFire() < CurTime() and not self.Weapon:IsReloading() and self.Weapon:GetNeedPump() then
		self.Weapon:SetNeedPump(false)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)

		local duration = self.Weapon:PlayAnimation("pump")

		self.Weapon:SetNextPrimaryFire(CurTime() + duration)
	end
end

function FIREMODE:HandleReload()
	self.Weapon:SetFinishReload(0)

	local item = self:GetAmmoItem()

	if not item then
		return
	end

	local amt = 0
	local ammotype = self.Weapon:GetAmmoType()
	local clip = self.Weapon:Clip1()

	if ammotype != item.Ammo then
		if SERVER and clip > 0 and ammotype != "" then
			self.Weapon.Owner:GiveItem("ammo_" .. ammotype, clip)
			self.Weapon:SetClip1(0)
		end

		amt = self.Weapon.Primary.ClipSize
	else
		amt = self.Weapon.Primary.ClipSize - clip
	end

	if self.Weapon.ShotgunReload then
		if self.Weapon:GetFirstReload() then
			self.Weapon:SetFirstReload(false)

			amt = 0
		else
			amt = 1
		end
	end

	amt = math.Min(amt, item.Stack)

	self.Weapon:SetClip1(self.Weapon:Clip1() + amt)
	self.Weapon:SetAmmoType(item.Ammo)

	if IsFirstTimePredicted() then
		item:AdjustAmount(-amt)
	end

	if self.Weapon.ShotgunReload then
		if self.Weapon:Clip1() >= self.Weapon.Primary.ClipSize or self.Weapon:GetAbortReload() or item.Stack == 0 then
			self.Weapon:SetAbortReload(false)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

			local duration = self.Weapon:PlayAnimation("reloadfinish")

			self.Weapon:SetNextPrimaryFire(CurTime() + duration)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)

			local duration = self.Weapon:PlayAnimation("reloadinsert")

			self.Weapon:SetFinishReload(CurTime() + duration)
		end
	end
end

return FIREMODE