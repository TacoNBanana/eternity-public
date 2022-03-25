AddCSLuaFile()
DEFINE_BASECLASS("eternity_melee_base")

SWEP.Base 				= "eternity_melee_base"

SWEP.PrintName 			= "Shovel"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/tnb/weapons/c_shovel.mdl")
SWEP.WorldModel 		= Model("models/tnb/weapons/w_shovel.mdl")

SWEP.HoldType 			= "melee2"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Damage 			= 30

SWEP.Animations = {
	idle = "idle01",
	hit = "hitkill1",
	miss = "misscenter1"
}