AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "SKS"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/tfa_ins2/c_sks.mdl")
SWEP.WorldModel 		= Model("models/weapons/tfa_ins2/w_sks.mdl")

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "762x39mm" -- Match with ITEM.AmmoGroup, might break otherwise

SWEP.ClipSize 			= 20
SWEP.Delay 				= 0.2

SWEP.HipCone 			= 0.1
SWEP.AimCone 			= 0.005

SWEP.Recoil 			= 1.4

SWEP.FireSound 			= "weapon_sks"

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.RecoilMult 		= 5 -- Visual only, good for giving things some extra kick

SWEP.FixWorldModel 		= {
	ang = Angle(3, -5, 178),
	pos = Vector(5, 1.3, -1),
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
	ang = Angle(0.1, 0, 0),
	pos = Vector(-2.91, -2.5, 2.06)
}

SWEP.Animations = {
	fire = "iron_fire",
	fire_last = "iron_firelast",
	reload = "base_reload",
	reload_empty = "base_reload_empty",
	draw = "base_ready"
}

if CLIENT then
	SWEP.VElements 	= { -- Best way to fill this out is to just copy the info from the TFA weapon you're copying the model from, "Modkit" is automatically activated when *any* attachments are present
		["Modkit"] = {Type = SCK_MODEL, mdl = "models/weapons/tfa_ins2/upgrades/a_modkit_04.mdl", Bone = "A_Optic", Pos = Vector(0, -0.245, 0.159), Ang = Angle(0, -90, 0), Size = Vector(0.611, 0.611, 0.611), Bonemerge = true, Hidden = true}
	}
end