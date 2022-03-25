AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 			= "ent_base"
ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:SpawnFunction(ply, tr, class)
	if not ply:IsInEditMode() then
		ply:SendChat("ERROR", "You have to be in edit mode to do this!")

		return
	end

	return BaseClass.SpawnFunction(self, ply, tr, class)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")
end

function ENT:IsReady()
	return self:GetEntityID() > 0
end

function ENT:CanPhys(ply)
	return not self:IsReady() and ply:IsInEditMode()
end

function ENT:CanTool(ply, tool)
	return not self:IsReady() and ply:IsInEditMode()
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not interact or not ply:IsInEditMode() then
		return tab
	end

	if self:IsReady() then
		table.insert(tab, {
			Name = "Delete",
			Callback = function()
				self:Delete()
			end
		})
	elseif self:CanSave() then
		table.insert(tab, {
			Name = "Save",
			Callback = function()
				self:Save()
			end
		})
	end

	return tab
end

function ENT:CanSave()
	return true
end

function ENT:CanAccessInventory(ply)
	return self:WithinInteractRange(ply)
end

if SERVER then
	function ENT:GetCustomData()
		return {}
	end

	function ENT:LoadCustomData(data)
	end

	function ENT:OnInitialLoad()
	end

	function ENT:Save()
		undo.ReplaceEntity(self, NULL)
		cleanup.ReplaceEntity(self, NULL)

		constraint.RemoveAll(self)

		GAMEMODE:SaveWorldEnt(self)
	end

	function ENT:Delete()
		GAMEMODE:DeleteWorldEnt(self)
	end
end