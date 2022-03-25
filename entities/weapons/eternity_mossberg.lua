AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Mossberg 590"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_m590_olli.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_m590_olli.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi", Vars = {Name = "Pump-action"}}
}

SWEP.PumpAction 		= true
SWEP.ShotgunReload 		= true

SWEP.Animated 			= true
SWEP.AnimatedADS 		= false

SWEP.AmmoGroup 			= "12ga"

SWEP.ClipSize 			= 6
SWEP.Delay 				= 0.4

SWEP.HipCone 			= 0.04
SWEP.AimCone 			= 0.01

SWEP.Recoil 			= 1.5

SWEP.FireSound 			= "weapon_mossberg"

SWEP.FixWorldModel 		= {
	ang = Angle(2, -10, 180),
	pos = Vector(0, 0, 0),
	scale = 1
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-1.99, -8, 1)
}

SWEP.Animations = {
	draw = "base_ready",
	fire = {"iron_fire_1", "iron_fire_2"},
	pump = {"iron_fire_cock_1", "iron_fire_cock_2"},
	reload = "base_reload_start",
	reloadinsert = "base_reload_insert",
	reloadfinish = "base_reload_end"
}

if CLIENT then
	SWEP.VElements 	= {
		["Modkit"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/a_modkit_05.mdl", Bone = "A_Modkit", Pos = Vector(-0.07, -1.3, 2), Ang = Angle(90, 0, 90), Hidden = true}
	}
end