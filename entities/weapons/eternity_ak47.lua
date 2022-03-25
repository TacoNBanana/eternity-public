AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "AK-47"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_cod/mwr/c_ak47.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_cod/mwr/w_ak47.mdl")

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

SWEP.FireSound 			= "weapon_ak47"

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.RecoilMult 		= 0

SWEP.FixWorldModel 		= {
	ang = Angle(92, 3, 185),
	pos = Vector(7, 1.3, -2),
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
	pos = Vector(-2.41, -7, 0.81)
}

SWEP.Animations = {
	fire = "fire_ads",
	reload_empty = "reload_empty",
	draw = "pullout_first"
}

SWEP.SoundScripts = {
	reload = {
		{time = 15 / 30, snd = "TFA_MWR_AK47.ClipOut"},
		{time = 55 / 30, snd = "TFA_MWR_AK47.ClipIn"}
	},
	reload_empty = {
		{time = 15 / 30, snd = "TFA_MWR_AK47.ClipOut"},
		{time = 55 / 30, snd = "TFA_MWR_AK47.ClipIn"},
		{time = 75 / 30, snd = "TFA_MWR_AK47.Chamber"}
	}
}

if CLIENT then
	SWEP.VElements 	= {
		["Modkit"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_cod/mwr/c_ak47_ra.mdl", Bone = "j_gun", Size = Vector(0.5, 0.5, 0.5), Bonemerge = true, Hidden = true}
	}
end