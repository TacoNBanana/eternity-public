AddCSLuaFile()
DEFINE_BASECLASS("eternity_firearm_base")

SWEP.Base 				= "eternity_firearm_base"

SWEP.PrintName 			= "Type-33 Needler"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_needler.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_needler.mdl")

SWEP.HoldType 			= "smg"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Firemodes 			= {
	{Mode = "firemode_needler"}
}

SWEP.Animated 			= true
SWEP.AnimatedADS 		= true

SWEP.AmmoGroup 			= "needler"

SWEP.ClipSize 			= 24

SWEP.DelayRamp 			= 0.8

SWEP.MinDelay 			= 0.083
SWEP.MaxDelay 			= 0.125

SWEP.HipCone 			= 0.1
SWEP.AimCone 			= 0.03

SWEP.Recoil 			= 0.2

SWEP.FireSound 			= Sound("weapon_needler")

SWEP.RecoilMult 		= 0

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(2, 2, -1)
}

SWEP.LoweredOffset = {
	ang = Angle(-10, 0, 0),
	pos = Vector(2, 1, -1)
}

SWEP.AimOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 2, 1)
}

SWEP.Animations = {
	fire = "fire",
	draw = "draw",
	reload = "reload"
}

if CLIENT then
	function SWEP:Think()
		BaseClass.Think(self)

		if IsValid(self.VM) then
			self.VM:SetPoseParameter("drc_ammo", self:Clip1() / self.ClipSize)
		end
	end
end