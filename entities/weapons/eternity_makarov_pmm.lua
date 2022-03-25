AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Makarov PMM"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/khrcw2/pistols/makarov.mdl")
SWEP.WorldModel 		= Model("models/khrcw2/pistols/w_makarov.mdl")

SWEP.VMBodyGroups 		= {
	[0] = 1,
	[2] = 2,
	[3] = 1
}

SWEP.WMBodyGroups 		= {
	[0] = 1,
	[2] = 2,
}

SWEP.HoldType 			= "revolver"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "9x18mm"

SWEP.ClipSize 			= 12
SWEP.Delay 				= 0.1

SWEP.HipCone 			= 0.06
SWEP.AimCone 			= 0.0075

SWEP.Recoil 			= 1

SWEP.FireSound 			= "weapon_makarov_pmm"

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
	ang = Angle(0.4, 0, 0),
	pos = Vector(-1.655, -3, 0.34)
}

SWEP.Animations = {
	fire = {"base_fire", "base_fire2", "base_fire3"},
	fire_last = "base_firelast",
	reload = "base_reload",
	reload_empty = "base_reloadempty",
	draw = "base_ready"
}

SWEP.SoundScripts = {
	base_reload = {
		{time = 17 / 30, snd = "Weapon_PM.Boltback"},
		{time = 24 / 30, snd = "Weapon_PM.Magout"},
		{time = 58 / 30, snd = "Weapon_PM.Magin"},
		{time = 62 / 30, snd = "Weapon_PM.MagHit"},
	},
	base_reloadempty = {
		{time = 17 / 30, snd = "Weapon_PM.Boltback"},
		{time = 24 / 30, snd = "Weapon_PM.Magout"},
		{time = 58 / 30, snd = "Weapon_PM.Magin"},
		{time = 62 / 30, snd = "Weapon_PM.MagHit"},
		{time = 71 / 30, snd = "Weapon_PM.Boltrelease"},
	}
}