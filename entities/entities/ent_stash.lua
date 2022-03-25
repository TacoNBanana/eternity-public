AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 					= "ent_worldent"
ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.PrintName 				= "Stash"
ENT.Category 				= "Eternity"

ENT.Spawnable 				= true
ENT.AdminOnly 				= true

ENT.Model 					= Model("models/props_c17/Lockers001a.mdl")
ENT.Color 					= Color(0, 127, 31)

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

		self:SetUseType(SIMPLE_USE)
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local edit = LocalPlayer():IsInEditMode()
		local ready = self:IsReady()

		if edit or not ready then
			local mins = self:OBBMins() - Vector(0.1, 0.1, 0.1)
			local maxs = self:OBBMaxs() + Vector(0.1, 0.1, 0.1)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, ColorAlpha(self.Color, 50), true)

			GAMEMODE:DrawWorldText(self:WorldSpaceCenter(), self.PrintName, true)
		end
	end
else
	function ENT:Use(ply)
		if not self:IsReady() then
			return
		end

		if not ply:GetActiveSpecies().AllowStash then
			ply:SendChat("ERROR", "You can't use a stash!")

			return
		end

		ply:SetLastStash(self)

		local inventory = ply:GetInventory("Stash")

		ply:OpenGUI("InventoryPopup", "Stash", {inventory.NetworkID})
	end
end