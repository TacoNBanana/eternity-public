AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "AKM"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_akz.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_akz.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_auto"},
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "762x39mm"

SWEP.ClipSize 			= 30
SWEP.Delay 				= 0.1

SWEP.HipCone 			= 0.08
SWEP.AimCone 			= 0.005

SWEP.Recoil 			= 1.2

SWEP.FireSound 			= "weapon_akm"

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.RecoilMult 		= 2

SWEP.FixWorldModel 		= {
	ang = Angle(2, -5, 178),
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
	ang = Angle(0.4, -0.015, 0),
	pos = Vector(-2.93, -8, 0.88)
}

SWEP.Animations = {
	fire = {"iron_fire", "iron_fire_a", "iron_fire_b", "iron_fire_c", "iron_fire_d", "iron_fire_e", "iron_fire_f", "iron_fire_f2"},
	reload = "base_reload",
	reload_empty = "base_reload_empty",
	draw = "base_ready"
}

if CLIENT then
	SWEP.VElements 	= {
		["Modkit"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/a_modkit_akz.mdl", Bone = "A_Foregrip", Pos = Vector(0, -0.245, 0.159), Ang = Angle(0, -90, 0), Size = Vector(0.611, 0.611, 0.611), Bonemerge = true, Hidden = true}
	}
end