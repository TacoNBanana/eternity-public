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

SWEP.Scope 			= {}

function SWEP:Initialize()
	self:SetupModel()
	self:SetupFiremodes()
	self:SetFiremode(nil, 1)

	self:SetZoomIndex(1)
	self.LastThink = CurTime()
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
		self.SavedAmmo[k] = table.Copy(v)
	end

	self:SetFiremode(nil, 1)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "FiremodeIndex")
	self:NetworkVar("Int", 1, "ItemID")
	self:NetworkVar("Int", 2, "ZoomIndex")

	self:NetworkVar("Bool", 0, "Holstered")
	self:NetworkVar("Bool", 1, "AbortReload")
	self:NetworkVar("Bool", 2, "NeedPump")
	self:NetworkVar("Bool", 3, "FirstReload")
	self:NetworkVar("Bool", 4, "ToggleADS")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "FinishReload")
	self:NetworkVar("Float", 2, "FireStart")

	self:NetworkVar("String", 0, "AmmoType")
end

function SWEP:CanFire()
	return self:GetFiremode():CanFire()
end

function SWEP:IsFiring()
	return self:GetFireStart() != -1
end

function SWEP:GetFireDuration()
	if not self:IsFiring() then
		return 0
	end

	return CurTime() - self:GetFireStart()
end

function SWEP:PrimaryAttack()
	if self.ShotgunReload and self:IsReloading() then
		self:SetAbortReload(true)

		return
	end

	if not self:CanFire() then
		return
	end

	if not self:IsFiring() then
		self:SetFireStart(CurTime())
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
	local delta = CurTime() - self.LastThink

	BaseClass.Think(self)

	if self:GetItem() then
		self:DoItemSetup()
	end

	if self:GetFireStart() != -1 and (not self.Owner:KeyDown(IN_ATTACK) or not self:CanFire()) then
		self:SetFireStart(-1)
	end

	if IsFirstTimePredicted() then
		self:CalculateSpread()
	end

	if CLIENT and LocalPlayer() != self.Owner then
		return
	end

	self:GetFiremode():Think(delta)
	self:SoundThink()
	self:ScopeThink()

	if SERVER and self.NextAmmoSave and self.NextAmmoSave < CurTime() then
		self:SaveAmmo()
	end

	if IsFirstTimePredicted() then
		self.LastThink = CurTime()
	end
end

function SWEP:ScopeThink()
	if not self.Scope.Enabled then
		return
	end

	if self:AimingDownSights() and istable(self.Scope.Zoom) and (not game.SinglePlayer() or SERVER) then
		local cmd = self.Owner:GetCurrentCommand()
		local wheel = math.Clamp(cmd:GetMouseWheel(), -1, 1)

		if wheel != 0 then
			local index = self:GetZoomIndex() + wheel

			if index > 0 and index <= #self.Scope.Zoom then
				self:SetZoomIndex(index)
			end
		end
	end

	if CLIENT then
		if not self:AimingDownSights() or self:IsReloading() then
			self.Scoped = false
		elseif not self.Scoped and self:GetADSFactor() > 0.9 then
			self.Scoped = true
		end
	end
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

function SWEP:TranslateFOV(fov)
	return fov / self:GetZoomLevel()
end

function SWEP:GetZoomLevel()
	if not self.Scope.Enabled then
		return 1
	end

	if (CLIENT and self.Scoped) or (SERVER and self:AimingDownSights()) then
		local zoom = self.Scope.Zoom

		if istable(zoom) then
			zoom = zoom[self:GetZoomIndex()]
		end

		return zoom
	end

	return 1
end

function SWEP:GetExamineRange(range)
	return range * self:GetZoomLevel()
end

function SWEP:OnReloaded()
	BaseClass.OnReloaded(self)

	self:SetupFiremodes()
	self:SetFiremode(self:GetFiremodeIndex(), self:GetFiremodeIndex())
end

if CLIENT then
	local fov = GetConVar("fov_desired")
	local ratio = GetConVar("zoom_sensitivity_ratio")

	function SWEP:AdjustMouseSensitivity()
		return (LocalPlayer():GetFOV() / fov:GetFloat()) * ratio:GetFloat()
	end
end

if SERVER then
	function SWEP:OnRemove()
		self:SaveAmmo()
	end

	function SWEP:QueueSave()
		self.NextAmmoSave = CurTime() + 5
	end

	function SWEP:SaveAmmo()
		self.NextAmmoSave = nil

		local item = self:GetItem()

		if not item then
			return
		end

		local tab = table.Copy(self.SavedAmmo)
		local firemode = self:GetFiremode()

		tab[firemode:Get("AmmoGroup")] = {Clip = self:Clip1(), Ammo = self:GetAmmoType()}

		item.AmmoSave = tab
	end
end