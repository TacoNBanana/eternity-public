AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "USP Match"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_usp_match.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_usp_match.mdl")

SWEP.HoldType 			= "revolver"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "45acp"

SWEP.ClipSize 			= 12
SWEP.Delay 				= 0.1

SWEP.HipCone 			= 0.06 -- Hipfire spread
SWEP.AimCone 			= 0.0075 -- ADS spread

SWEP.Recoil 			= 1 -- Sticking around 1 is generally the best course of action, any lower than 0.9 and it'll end up negligible

SWEP.FireSound 			= "weapon_usp" -- sh_sounds.lua

SWEP.Animated 			= true -- False means the weapon won't play any animations when firing, mostly used for the MP7 which has some really stupid viewmodel animations
SWEP.AnimatedADS 		= true -- Ditto but only when aiming down sights

SWEP.FixWorldModel 		= { -- Needed for some (TFA) models because they don't have bonemerge support, optional
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
	ang = Angle(-0.3, 0, 0),
	pos = Vector(-2.015, -4, 0.4)
}

SWEP.Animations = { -- Animation names taken from the spawnicon viewer, fire_last and reload_empty are optional
	fire = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
	fire_last = "iron_firelast",
	reload = "base_reload",
	reload_empty = "base_reload_empty",
	draw = "base_ready"
}