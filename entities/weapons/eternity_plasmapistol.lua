AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Type-25 Plasma Pistol"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_plasmapistol.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_plasmapistol.mdl")

SWEP.HoldType 			= "revolver"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_plasmapistol"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.Delay 				= 0.15

SWEP.HeatRate 			= 12
SWEP.CoolRate 			= 40

SWEP.HipCone 			= 0.06
SWEP.AimCone 			= 0.03

SWEP.Recoil 			= 0.9

SWEP.FireSound 			= Sound("weapon_plasmapistol")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(2, 1, -2)
}

SWEP.LoweredOffset = {
	ang = Angle(-15, 0, 0),
	pos = Vector(2, 1, -1)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(1, 1, 0)
}

SWEP.Animations = {
	fire = {"fire_fp", "fire_fp1", "fire_fp2"},
	draw = "draw",
	overheat = "overheat_start",
	overheat_finish = "overheat_finish"
}

if CLIENT then
	SWEP.CoolColor = Color(0, 255, 100):ToVector()
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
	self:NetworkVar("Bool", 5, "Overheating")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "FinishReload")
	self:NetworkVar("Float", 2, "FireStart")
	self:NetworkVar("Float", 3, "Heat")

	self:NetworkVar("String", 0, "AmmoType")
end

function SWEP:PrimaryAttack()
	if not self:CanFire() then
		self:SetNextPrimaryFire(CurTime() + 0.2)

		return
	end

	if not self:IsFiring() then
		self:SetFireStart(CurTime())
	end

	self:GetFiremode():Fire()
end

function SWEP:IsOverheating()
	return self:GetOverheating()
end

if CLIENT then
	function SWEP:FinishOverheat()
		self:PlayAnimation("overheat_finish", 1, 0, false, self.VM, true)
		self:EmitSound("drc.pp_oh_exit")
	end
else
	function SWEP:SaveAmmo()
	end
end