AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 			= "ent_base"
ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Initialize()
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end

function ENT:CanPhys(ply)
	return false
end

function ENT:CanTool(ply, tool)
	return false
end