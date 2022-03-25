AddCSLuaFile()
DEFINE_BASECLASS("eternity_melee_base")

SWEP.RenderGroup 		= RENDERGROUP_BOTH

SWEP.Base 				= "eternity_melee_base"

SWEP.PrintName 			= "Energy Sword"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/vuthakral/halo/weapons/c_hum_energysword.mdl")
SWEP.WorldModel 		= Model("models/vuthakral/halo/weapons/w_energysword.mdl")

SWEP.HoldType 			= "knife"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Damage 			= 120

SWEP.LoweredOffset 	= {
	ang = Angle(-20, 0, 0),
	pos = Vector(0, 0, 0)
}

SWEP.Animations = {
	idle = "idle",
	hit = "swingprim",
	miss = "lunge"
}

function SWEP:OnAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:OnHit()
	self:EmitSound("D_HaloES.HitFlesh")
end

function SWEP:OnMiss()
	self:EmitSound("D_HaloES.Melee")
end