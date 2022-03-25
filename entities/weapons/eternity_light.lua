AddCSLuaFile()

SWEP.PrintName 				= "Handheld searchlight"
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

function SWEP:Initialize()
	if CLIENT then
		self.PixVis = util.GetPixelVisibleHandle()
	end

	self:SetColor(Color(255, 210, 40))
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "On")
end

function SWEP:Deploy()
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	if CLIENT then
		return
	end

	if self:GetOn() then
		self:TurnOff()
	else
		self:TurnOn()
	end

	self.Owner:EmitSound("buttons/lightswitch2.wav", 70, 100, 0.5)
	self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local ply = self.Owner

	if IsValid(ply) and IsValid(self.Light) then
		self.Light:SetPos(ply:EyePos())
		self.Light:SetAngles(ply:EyeAngles())
	end
end

function SWEP:TurnOn()
	local ply = self.Owner

	self:SetOn(true)

	SafeRemoveEntity(self.Light)

	self.Light = ents.Create("env_projectedtexture")

	self.Light:SetPos(ply:EyePos())
	self.Light:SetAngles(ply:EyeAngles())

	self.Light:SetKeyValue("enableshadows", 1)
	self.Light:SetKeyValue("lightfov", 45)

	self.Light:SetKeyValue("nearz", 30)
	self.Light:SetKeyValue("farz", 1024)

	self.Light:SetKeyValue("lightcolor", "255 255 255 2040")

	self.Light:Spawn()
	self.Light:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")

	self:DeleteOnRemove(self.Light)
end

function SWEP:TurnOff()
	self:SetOn(false)

	SafeRemoveEntity(self.Light)
end

function SWEP:OnRemove()
	self:TurnOff()
end

function SWEP:Holster()
	self:TurnOff()

	return true
end

function SWEP:DrawWorldModel()
	local ply = self.Owner

	if IsValid(self.Owner) then
		local hand = ply:LookupBone("ValveBiped.Bip01_R_Hand")

		if hand then
			local pos, ang

			local mat = ply:GetBoneMatrix(hand)

			if mat then
				pos, ang = mat:GetTranslation(), mat:GetAngles()
			else
				pos, ang = ply:GetBonePosition(hand)
			end

			pos = pos + (ang:Forward() * self.Offset.pos.x) + (ang:Right() * self.Offset.pos.y) + (ang:Up() * self.Offset.pos.z)

			ang = ply:EyeAngles()

			ang:RotateAroundAxis(ang:Up(), self.Offset.ang.p)
			ang:RotateAroundAxis(ang:Right(), self.Offset.ang.y)
			ang:RotateAroundAxis(ang:Forward(), self.Offset.ang.r)

			self:SetRenderOrigin(pos)
			self:SetRenderAngles(ang)
		end
	end

	self:SetupBones()
	self:DrawModel()
end

local mat = Material("sprites/light_ignorez")

function SWEP:DrawWorldModelTranslucent()
	if not self:GetOn() then
		return
	end

	local dir = -self:GetRenderAngles():Forward()
	local eye = self:GetPos() - EyePos()
	local dist = eye:Length()

	eye:Normalize()

	local dot = eye:Dot(dir)
	local pos = self:GetRenderOrigin() + (dir * -5)

	local vis = util.PixelVisible(pos, 16, self.PixVis)

	if dot >= 0 and vis > 0 then
		render.SetMaterial(mat)

		local size = math.Clamp(dist * vis * dot * 2, 64, 128)

		dist = math.Clamp(dist, 32, 800)

		local alpha = math.Clamp((1000 - dist) * vis * dot, 0, 255)

		render.DrawSprite(pos, size * 0.4, size * 0.4, Color(255, 255, 255, alpha), vis * dot)
	end
end