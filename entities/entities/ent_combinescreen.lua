AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_OPAQUE

ENT.PrintName 		= "Combine Screen"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/props_combine/combine_intmonitor001.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end
end

if SERVER then
	function ENT:Think()
		self:NextThink(CurTime() + 0.1)

		if not self:IsReady() then
			return true
		end

		local state = 1

		for _, v in pairs(player.GetAll()) do
			if not IsValid(v) or not self:TestPVS(v) or v:IsInNoClip() then
				continue
			end

			local pos = self:WorldSpaceCenter()
			local eye = v:EyePos()

			if pos:Distance(eye) < 128 then
				local dx = (eye - pos):Dot(self:GetAngles():Forward())
				local dy = (eye - pos):Dot(self:GetAngles():Right())
				local ang = math.atan2(dx, dy) / math.pi

				if ang > 0.1 and ang < 0.9 then
					state = 0

					break
				end
			end
		end

		self:SetSkin(state)

		return true
	end
end