AddCSLuaFile()
DEFINE_BASECLASS("eternity_melee_base")

SWEP.Base 				= "eternity_melee_base"

SWEP.PrintName 			= "Crowbar"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel 		= Model("models/weapons/w_crowbar.mdl")

SWEP.HoldType 			= "melee"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Damage 			= 20

SWEP.Animations = {
	idle = "idle01",
	hit = {"hitcenter1", "hitcenter2", "hitcenter3"},
	miss = {"misscenter1", "misscenter2"}
}