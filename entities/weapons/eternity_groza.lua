AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "OTs-14 Groza"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_groza.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_groza.mdl")

SWEP.HoldType 			= "smg"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_auto"},
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "762x39mm"

SWEP.ClipSize 			= 30
SWEP.Delay 				= 0.08

SWEP.HipCone 			= 0.045
SWEP.AimCone 			= 0.006

SWEP.Recoil 			= 1

SWEP.FireSound 			= "weapon_groza"

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.RecoilMult 		= 2

SWEP.FixWorldModel 		= {
	ang = Angle(2, -10, 178),
	pos = Vector(0, 1.3, -1),
	scale = 1
}

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(2, 2, -2)
}

SWEP.AimOffset = {
	ang = Angle(0.1, 0, 0),
	pos = Vector(-3.7, -6, 0.89)
}

SWEP.Animations = {
	fire = {"foregrip_iron_fire", "foregrip_iron_fire_2", "foregrip_iron_fire_a", "foregrip_iron_fire_b", "foregrip_iron_fire_c", "foregrip_iron_fire_d", "foregrip_iron_fire_e", "foregrip_iron_fire_f"},
	reload = "foregrip_reload",
	reload_empty = "foregrip_reload_empty",
	draw = "foregrip_ready"
}

if CLIENT then
	SWEP.VElements 	= {
		["Barrel"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/a_foregrip_groza.mdl", Bone = "A_Foregrip", Bonemerge = true},
		["Modkit"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/a_modkit_groza.mdl", Bone = "A_ModKit", Bonemerge = true, Hidden = true}
	}

	SWEP.WElements 	= {
		["Barrel"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/w_foregrip_groza.mdl", Bone = "ATTACH_Foregrip", Bonemerge = true}
	}
end