AddCSLuaFile()

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "MP7A1"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/tnb/weapons/c_mp7.mdl")
SWEP.WorldModel 		= Model("models/tnb/weapons/w_mp7.mdl")

SWEP.HoldType 			= "smg"
SWEP.HoldTypeLowered 	= "passive"

SWEP.Firemodes 			= {
	{Mode = "firemode_auto"},
	{Mode = "firemode_semi"}
}

SWEP.AmmoGroup 			= "46x30mm"

SWEP.ClipSize 			= 20
SWEP.Delay 				= 0.075

SWEP.HipCone 			= 0.04
SWEP.AimCone 			= 0.005

SWEP.Recoil 			= 0.9

SWEP.FireSound 			= "weapon_mp7"

SWEP.RecoilMult 		= 2

SWEP.AimOffset = {
	ang = Angle(0.5, 0, 0),
	pos = Vector(-6.40, -8, 0.75)
}

SWEP.Animations = {
	fire = "fire01"
}

function SWEP:FireAnimationEvent(pos, ang, event)
	if event == 5001 then
		return true
	end
end