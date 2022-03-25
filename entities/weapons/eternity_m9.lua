AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Beretta M9"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_beretta.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_m9.mdl")

SWEP.HoldType 			= "revolver"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "9x19mm"

SWEP.ClipSize 			= 15
SWEP.Delay 				= 0.1

SWEP.HipCone 			= 0.06
SWEP.AimCone 			= 0.0075

SWEP.Recoil 			= 1

SWEP.FireSound 			= "weapon_m9"

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.FixWorldModel 		= {
	ang = Angle(-1, -5, 178),
	pos = Vector(5, 1.3, -1.5),
	scale = 1
}

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(2, 2, -2)
}

SWEP.LoweredOffset = {
	ang = Angle(-15, 0, 0),
	pos = Vector(2, 2, -1)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-2.2, -4, 0.4)
}

SWEP.Animations = {
	fire = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	fire_last = "iron_firelast",
	reload = "base_reload",
	reload_empty = "base_reload_empty",
	draw = "base_ready"
}