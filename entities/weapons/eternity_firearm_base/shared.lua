AddCSLuaFile()
DEFINE_BASECLASS("eternity_base")

SWEP.Base = "eternity_base"

AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_model.lua")
AddCSLuaFile("cl_offsets.lua")

AddCSLuaFile("sh_firemodes.lua")
AddCSLuaFile("sh_recoil.lua")

if CLIENT then
	include("cl_hud.lua")
	include("cl_model.lua")
	include("cl_offsets.lua")
end

include("sh_firemodes.lua")
include("sh_recoil.lua")

SWEP.Firemodes 		= {}

SWEP.PumpAction 	= false
SWEP.ShotgunReload 	= false

SWEP.Animated 		= false
SWEP.AnimatedADS 	= false

SWEP.AmmoGroup 		= ""

SWEP.ClipSize 		= 0
SWEP.Delay 			= 0

SWEP.HipCone 		= 0
SWEP.AimCone 		= 0

SWEP.Recoil 		= 0

SWEP.FireSound 		= ""

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 0, 0)
}

function SWEP:Initialize()
	self:SetupModel()
	self:SetupFiremodes()
	self:SetFiremode(nil, 1)

	self.StoredBullets = 0
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	if self:GetItem() then
		self:DoItemSetup()
	end
end

function SWEP:GetItem()
	return GAMEMODE:GetItem(self:GetItemID())
end

function SWEP:DoItemSetup()
	if self.ItemLoaded then
		return
	end

	self.ItemLoaded = true

	local item = self:GetItem()

	for k, v in pairs(item.AmmoSave) do
		self.SavedAmmo[k] = {Clip = v[1], Ammo = v[2]}
	end

	self:SetFiremode(nil, 1)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "FiremodeIndex")
	self:NetworkVar("Int", 1, "ItemID")

	self:NetworkVar("Bool", 0, "Holstered")
	self:NetworkVar("Bool", 1, "AbortReload")
	self:NetworkVar("Bool", 2, "NeedPump")
	self:NetworkVar("Bool", 3, "FirstReload")
	self:NetworkVar("Bool", 4, "ToggleADS")
	self:NetworkVar("Bool", 5, "Broken")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "FinishReload")

	self:NetworkVar("String", 0, "AmmoType")
end

function SWEP:CanFire()
	if self:GetBroken() then
		return false
	end

	return self:GetFiremode():CanFire()
end

function SWEP:PrimaryAttack()
	if self.ShotgunReload and self:IsReloading() then
		self:SetAbortReload(true)

		return
	end

	if not self:CanFire() then
		if not self:GetBroken() and CLIENT then
			self:EmitSound("weapons/ar2/ar2_empty.wav")
		end

		self:SetNextPrimaryFire(CurTime() + 0.2)

		return
	end

	self:GetFiremode():Fire()
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) and self:GetFiremode():CanSwitch() then
		self:CycleFiremode()
	elseif self:UseADSToggle() then
		self:SetToggleADS(not self:GetToggleADS())
	end
end

function SWEP:Think()
	BaseClass.Think(self)

	if self:GetItem() then
		self:DoItemSetup()
	end

	if IsFirstTimePredicted() then
		self:CalculateSpread()
	end

	if CLIENT and LocalPlayer() != self.Owner then
		return
	end

	self:GetFiremode():Think()
	self:SoundThink()
end

function SWEP:IsReloading()
	return self:GetFinishReload() != 0
end

function SWEP:CanReload()
	return self:GetFiremode():CanReload()
end

function SWEP:Reload()
	if not self:CanReload() then
		return
	end

	return self:GetFiremode():Reload()
end

function SWEP:UseADSToggle()
	if not IsValid(self.Owner) then
		return false
	end

	if CLIENT and LocalPlayer() == self.Owner then
		return GAMEMODE:GetSetting("weapon_toggleads")
	elseif SERVER then
		return self.Owner:GetSetting("weapon_toggleads")
	end

	return false
end

function SWEP:AimingDownSights()
	local ply = self.Owner

	if self:ShouldLower() then
		return false
	end

	if ply:KeyDown(IN_USE) then
		return false
	end

	return self:UseADSToggle() and self:GetToggleADS() or ply:KeyDown(IN_ATTACK2)
end

function SWEP:SetupModel()
	self:SetupWM()

	if CLIENT then
		local pos, ang

		if IsValid(self.VM) then
			pos = self.VM:GetPos()
			ang = self.VM:GetAngles()
		end

		self:SetupCustomVM(self.ViewModel)

		if pos and ang then
			self.VM:SetPos(pos)
			self.VM:SetAngles(ang)
		end
	end
end

function SWEP:OnReloaded()
	BaseClass.OnReloaded(self)

	self:SetupFiremodes()
	self:SetFiremode(self:GetFiremodeIndex(), self:GetFiremodeIndex())
end

function SWEP:GetDurability()
	local item = self:GetItem()

	if not item then
		return 100
	end

	local delay = self.Delay

	if delay == -1 then
		delay = 0.5
	end

	-- Overall durability = 100 / ((delay * 5) / clipsize)
	-- Example for AKM: 100 / ((0.1 * 5) / 30) = 6000 rounds before breaking

	local decrease = ((delay * GAMEMODE:GetConfig("DurabilityMultiplier")) / self.ClipSize) * self.StoredBullets

	return math.max(item.Durability - decrease, 0)
end

if SERVER then
	function SWEP:OnRemove()
		self:HandleDurability(true)
	end

	function SWEP:HandleDurability(force) -- If not forced durability will only update when the weapon actually breaks
		if self.StoredBullets == 0 then
			return
		end

		local item = self:GetItem()

		if not item then
			return
		end

		local new = self:GetDurability()

		if new <= 0 or force then
			self.StoredBullets = 0
			item:SetDurability(new, self.Owner)
		end
	end
end