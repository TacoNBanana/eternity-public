DEFINE_BASECLASS("eternity_light")
AddCSLuaFile()

SWEP.Base 					= "eternity_light"

SWEP.PrintName 				= "Handheld floodlight"
SWEP.Author 				= "TankNut"

SWEP.RenderGroup 			= RENDERGROUP_BOTH

SWEP.Slot 					= 2

SWEP.UseHands 				= false
SWEP.ViewModel 				= Model("models/weapons/c_arms.mdl")
SWEP.WorldModel 			= Model("models/lamps/torch.mdl")

SWEP.DrawCrosshair 			= false

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.Offset = {
	pos = Vector(5, 5, 4),
	ang = Angle(0, 0, 0)
}

function SWEP:TurnOn()
	local ply = self.Owner

	self:SetOn(true)

	SafeRemoveEntity(self.Light)

	self.Light = ents.Create("env_projectedtexture")

	self.Light:SetPos(ply:EyePos())
	self.Light:SetAngles(ply:EyeAngles())

	self.Light:SetKeyValue("enableshadows", 1)
	self.Light:SetKeyValue("lightfov", 90)

	self.Light:SetKeyValue("nearz", 30)
	self.Light:SetKeyValue("farz", 2048)

	self.Light:SetKeyValue("lightcolor", "255 255 255 2040")

	self.Light:Spawn()
	self.Light:Input("SpotlightTexture", NULL, NULL, "effects/flashlight/soft")

	self:DeleteOnRemove(self.Light)
end