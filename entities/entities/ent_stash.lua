AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 					= "ent_worldent"
ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.PrintName 				= "Stash"
ENT.Category 				= "Eternity"

ENT.Spawnable 				= true
ENT.AdminOnly 				= true

ENT.Model 					= Model("models/props_c17/Lockers001a.mdl")

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

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")
end

if SERVER then
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