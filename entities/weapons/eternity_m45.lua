AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "M45 Tactical Shotgun"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_m45.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_m45.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.ShotgunReload 		= true

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "8ga"

SWEP.ClipSize 			= 6
SWEP.Delay 				= -1

SWEP.HipCone 			= 0.4
SWEP.AimCone 			= 0.03

SWEP.Recoil 			= 1.2

SWEP.FireSound 			= Sound("weapon_m45")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(1, -1, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-10, 35, 0),
	pos = Vector(2, 0, -1)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(-1, -3, -1)
}

SWEP.Animations = {
	draw = "draw",
	fire = {"fire1", "fire2", "fire3"},
	reload = "reload_enter",
	reloadinsert = "reload_loop",
	reloadfinish = "reload_exit"
}