AddCSLuaFile()
DEFINE_BASECLASS("eternity_melee_base")

SWEP.Base 				= "eternity_melee_base"

SWEP.PrintName 			= "Glass Bottle"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/tnb/weapons/c_bottle.mdl")
SWEP.WorldModel 		= Model("models/tnb/weapons/w_bottle.mdl")

SWEP.HoldType 			= "melee"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Damage 			= 20

SWEP.Animations = {
	idle = "idle01",
	hit = "throw",
	miss = "lob"
}