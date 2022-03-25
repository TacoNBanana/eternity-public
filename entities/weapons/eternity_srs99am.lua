AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "SRS99-AM"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_srs99am.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_srs99am.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "145x114mm"

SWEP.ClipSize 			= 4
SWEP.Delay 				= 1

SWEP.HipCone 			= 0.5
SWEP.AimCone 			= 0

SWEP.Recoil 			= 1.2

SWEP.FireSound 			= Sound("weapon_srs99am")

SWEP.RecoilMult 		= 0

SWEP.Scope 				= {
	Enabled = true,
	Zoom = {5, 8, 20}
}

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(1, -1, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-10, 35, 0),
	pos = Vector(2, 0, -2)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-4.68, -5, -1.155)
}

SWEP.Animations = {
	fire = {"fire_rand1", "fire_rand2", "fire_rand3"},
	reload = "reload",
	reload_empty = "reload_empty",
	draw = "draw"
}