AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Type-51 Plasma Repeater"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_plasmarepeater.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_plasmarepeater.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_plasmarepeater"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.DelayTrigger 		= 0.4

SWEP.MinDelay 			= 0.1
SWEP.MaxDelay 			= 0.333

SWEP.HeatRate 			= 2
SWEP.CoolRate 			= 4
SWEP.ActiveCoolRate 	= 20

SWEP.HipCone 			= 0.2
SWEP.AimCone 			= 0.03

SWEP.Recoil 			= 0.9

SWEP.FireSound 			= Sound("weapon_plasmarifle")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(-2, 0, 0),
	pos = Vector(2, 0, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-10, 25, 0),
	pos = Vector(3, 1, -1)
}

SWEP.AimOffset = {
	ang = Angle(-2, 0, 0),
	pos = Vector(1, -1, -1)
}

SWEP.Animations = {
	fire = {"fire_fp", "fire_fp1", "fire_fp2"},
	draw = "draw",
	overheat = "overheat_start",
	overheat_finish = "overheat_finish"
}

if CLIENT then
	SWEP.CoolColor = Color(0, 255, 255):ToVector()
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
		self:EmitSound("drc.plasmarifle_overheat_end")
	end
else
	function SWEP:SaveAmmo()
	end
end