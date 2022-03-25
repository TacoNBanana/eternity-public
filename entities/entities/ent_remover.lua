AddCSLuaFile()
DEFINE_BASECLASS("ent_picker")

ENT.Base 			= "ent_picker"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Entity Remover"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Color 			= Color(255, 0, 0)

if SERVER then
	function ENT:OnInitialLoad()
		BaseClass.OnInitialLoad(self)

		local ent = self:GetPickedEntity()

		if IsValid(ent) then
			ent.Removing = true
			ent:Remove()
		end
	end
end