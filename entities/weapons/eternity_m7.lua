AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "M7 SMG"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_m7.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_m7.mdl")

SWEP.HoldType 			= "smg"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_auto"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "5x23mm"

SWEP.ClipSize 			= 60
SWEP.Delay 				= 0.066

SWEP.HipCone 			= 0.4
SWEP.AimCone 			= 0.05

SWEP.Recoil 			= 0.9

SWEP.FireSound 			= Sound("weapon_m7")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(1, -1, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-5, 35, 0),
	pos = Vector(2, 0, -2)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-1, -3, -1)
}

SWEP.Animations = {
	fire = "fire_fp",
	reload = "reload",
	draw = "draw"
}