AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "M41 SPNKR"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_spnkr.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_spnkr.mdl")

SWEP.HoldType 			= "rpg"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "102mm"

SWEP.ClipSize 			= 2
SWEP.Delay 				= 1

SWEP.HipCone 			= 0.05
SWEP.AimCone 			= 0

SWEP.Recoil 			= 1.2

SWEP.FireSound 			= Sound("weapon_spnkr")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(1, -1, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-20, 20, 0),
	pos = Vector(2, 0, -2)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-1, -4, -1)
}

SWEP.Animations = {
	fire = "fire_rand1",
	fire_last = "fire_rand3",
	reload = "reload",
	draw = "draw"
}