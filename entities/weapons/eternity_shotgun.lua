AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "SPAS-12"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/c_shotgun.mdl")
SWEP.WorldModel 		= Model("models/weapons/w_shotgun.mdl")

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
SWEP.Delay 				= 0.2

SWEP.HipCone 			= 0.04
SWEP.AimCone 			= 0.01

SWEP.Recoil 			= 1.5

SWEP.FireSound 			= "weapon_shotgun"

SWEP.AimOffset = {
	ang = Angle(-0.2, 0, 0),
	pos = Vector(-8.95, -8, 4.3)
}

SWEP.Animations = {
	fire = "fire01",
	reload = "reload1",
	reloadinsert = "reload2",
	reloadfinish = "reload3"
}

SWEP.SoundScripts = {
	pump = {
		{time = 0, snd = "Weapon_Shotgun.Special1"}
	},
	reload2 = {
		{time = 0, snd = "Weapon_Shotgun.Reload"}
	}
}