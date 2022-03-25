AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Soundscape Disabler"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/hunter/blocks/cube025x025x025.mdl")
ENT.Color 			= Color(0, 255, 255)

function ENT:SpawnFunction(ply, tr, class)
	if #ents.FindByClass(class) > 0 then
		ply:SendChat("ERROR", "This entity can't be spawned more than once!")

		return
	end

	return BaseClass.SpawnFunction(self, ply, tr, class)
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetMaterial("models/shiny")
end

if CLIENT then
	function ENT:Draw()
		local edit = LocalPlayer():IsInEditMode()
		local ready = self:IsReady()

		if edit or not ready then
			self:DrawModel()

			local mins = self:OBBMins() - Vector(0.1, 0.1, 0.1)
			local maxs = self:OBBMaxs() + Vector(0.1, 0.1, 0.1)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, ColorAlpha(self.Color, 50), true)

			GAMEMODE:DrawWorldText(self:WorldSpaceCenter(), self.PrintName, true)
		end
	end
else
	function ENT:OnInitialLoad()
		for _, v in pairs(ents.FindByClass("env_soundscape")) do
			v:Fire("Disable")
		end
	end
end