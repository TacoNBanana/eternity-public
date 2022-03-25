AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "M6C/SOCOM"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_m6s.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_m6s.mdl")

SWEP.HoldType 			= "revolver"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "127x40mm"

SWEP.ClipSize 			= 12
SWEP.Delay 				= 0.166

SWEP.HipCone 			= 0.05
SWEP.AimCone 			= 0.015

SWEP.Recoil 			= 0.9

SWEP.FireSound 			= Sound("weapon_m6s")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(2, 2, 1)
}

SWEP.LoweredOffset = {
	ang = Angle(-15, 0, 0),
	pos = Vector(2, 3, 1)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-1, 2, 1)
}

SWEP.Animations = {
	fire = {"fire_rand1", "fire_rand2", "fire_rand3"},
	reload = "reload",
	draw = "draw"
}