ITEM = class.Create("base_replicated")

ITEM.NetworkGroup 		= "Items"

ITEM.Name 				= "base_item"
ITEM.Description 		= "*INVALID*"

ITEM.BlockSpawn 		= false

ITEM.Model 				= Model("models/props_junk/PopCan01a.mdl")
ITEM.Skin 				= 0
ITEM.Scale 				= 1

ITEM.Color 				= Color(255, 255, 255)

ITEM.Material 			= ""

ITEM.Bodygroups 		= {}

ITEM.OutlineColor 		= Color(218, 218, 218)

ITEM.Width 				= 1
ITEM.Height 			= 1

ITEM.Overrides 			= {}
ITEM.OverrideBlacklist 	= {
	["Overrides"] = true,
	["OverrideBlacklist"] = true,
	["NetworkBlacklist"] = true,
	["InventoryID"] = true,
	["EntityID"] = true
}

ITEM.NetworkBlacklist 	= {
	["Overrides"] = true
}

ITEM.InventoryID 		= -1
ITEM.EntityID 			= -1

ITEM.EquipmentSlots 	= {}

ITEM.Flipped 			= false

ITEM.ItemGroup 			= ""
ITEM.ItemTags 			= {}

ITEM.License 			= false
ITEM.UnitPrice 			= 0
ITEM.SellPrice 			= 0

ITEM.Inventories 		= {}

ITEM.ArmorLevel 		= ARMOR_NONE
ITEM.Obscuring 			= false
ITEM.Filtered 			= false

ITEM.Team 				= nil

ITEM.TriggersNPCs 		= false

if CLIENT then
	ITEM.Icons 			= {}
end

includes.File("sh_options.lua")
includes.File("sh_worlditem.lua")
includes.File("sv_db.lua")

function ITEM:GetInventory()
	return GAMEMODE:GetInventory(self.InventoryID)
end

function ITEM:GetOutlineColor()
	return istable(self.OutlineColor) and table.Copy(self.OutlineColor) or self.OutlineColor
end

function ITEM:GetIconText()
end

function ITEM:GetSize()
	if self.Flipped then
		return self.Height, self.Width
	else
		return self.Width, self.Height
	end
end

function ITEM:IsEquipped()
	local inventory = self:GetInventory()

	if not inventory then
		return false
	end

	if not inventory.EquipmentSlot then
		return false
	end

	return inventory.GridName, inventory:GetParent()
end

function ITEM:OnEquip(ply, slot, loading)
	if SERVER and not loading then
		ply:HandlePlayerModel()

		if self.ArmorLevel > 0 then
			ply:HandleArmorLevel()
		end

		if self.Filtered then
			ply:HandleMisc()
		end

		if self.Team then
			ply:HandleTeam()
		end

		ply:HandleNPCRelationships()
	end
end

function ITEM:CanEquip(ply)
	return true
end

function ITEM:CanUnequip(ply)
	return true
end

function ITEM:CanDrop(ply)
	if self:IsEquipped() and not self:CanUnequip(ply) then
		return false
	end

	return true
end

function ITEM:CanDestroy(ply)
	if self:IsEquipped() and not self:CanUnequip(ply) then
		return false
	end

	return true
end

function ITEM:OnUnequip(ply, slot, unloading)
	if SERVER and not unloading then
		ply:HandlePlayerModel()

		if self.ArmorLevel > 0 then
			ply:HandleArmorLevel()
		end

		if self.Filtered then
			ply:HandleMisc()
		end

		if self.Team then
			ply:HandleTeam()
		end

		ply:HandleNPCRelationships()
	end
end

function ITEM:GetName()
	return self.Name
end

function ITEM:GetDescription()
	return self.Description
end

function ITEM:CanInteractWithChild(ply)
	return true
end

function ITEM:GetChildInventory(slot)
	if slot then
		return GAMEMODE:GetInventory(self.Inventories[slot])
	else
		local tab = {}

		for _, v in pairs(self.Inventories) do
			table.insert(tab, GAMEMODE:GetInventory(v))
		end

		return tab
	end
end

function ITEM:CanInteract(ply)
	local inventory = self:GetInventory()

	if not inventory then
		return false
	end

	return inventory:CanInteract(ply)
end

function ITEM:IsInStash()
	local inventory = self:GetInventory()

	if not inventory then
		return false
	end

	return inventory:IsInStash()
end

if CLIENT then
	function ITEM:GetTags()
		local tags = {}

		if self.ItemGroup != "" then
			table.insert(tags, self.ItemGroup)
		end

		for _, v in pairs(self.EquipmentSlots) do
			table.insert(tags, EQUIPMENT_TO_TEXT[v])
		end

		for _, v in pairs(self.ItemTags) do
			table.insert(tags, v)
		end

		return tags
	end

	function ITEM:GetToolTip()
		return markleft.Parse(string.format("<icolor=%s><b><ol>%s</ol></b></icolor>\n\n%s<reset>\n\n<tiny>%s</tiny>", self.NetworkID, string.Escape(self:GetName()), self:GetDescription(), table.concat(self:GetTags(), ", ")), 300)
	end

	local fields = {
		Model = true,
		Skin = true,
		Bodygroups = true,
		Material = true,
		Color = true
	}

	function ITEM:OnUpdated(key, value)
		if fields[key] then
			for k in pairs(self.Icons) do
				if IsValid(k) then
					k:Setup(self)
				end
			end
		end

		if key == "__Loaded" and value == true then
			self:OnLoaded()
		end
	end
end

function ITEM:Destroy(deleting)
	if CLIENT then
		for k in pairs(self.Icons) do
			if IsValid(k) then
				k:Remove()
			end
		end
	else
		local inventory = self:GetInventory()

		if inventory then
			inventory:RemoveItem(self, not deleting)
		end
	end

	self:ParentCall("Destroy")

	if SERVER then
		for _, v in pairs(self:GetChildInventory()) do
			v:Destroy()
		end
	end
end

function ITEM:OnUse(ply, item)
end

function ITEM:CanAccept(inventory, item)
	return true
end

if SERVER then
	function ITEM:OnCreated(id, data)
		if not class.Networked[self.NetworkGroup] then
			class.Networked[self.NetworkGroup] = {}
		end

		class.Networked[self.NetworkGroup][id] = self

		self.NetworkID = id

		for k, v in pairs(data) do
			if self.OverrideBlacklist[k] then
				continue
			end

			self.Overrides[k] = v
			self[k] = v
		end

		self:CreateInventories()

		self.__Loaded = true
		self:OnLoaded()
	end

	function ITEM:CreateInventories()
		for k, v in pairs(self.Inventories) do
			self.Inventories[k] = GAMEMODE:CreateGrid(STORE_ITEM, self.NetworkID, k, unpack(v)).NetworkID
		end
	end

	function ITEM:ProcessArguments()
	end

	function ITEM:OnFirstCreated()
	end

	function ITEM:SetNetworked(bool)
		self:ParentCall("SetNetworked", bool)

		for _, v in pairs(self:GetChildInventory()) do
			v:SetNetworked(bool)
		end
	end

	function ITEM:NewIndex(key, value)
		if self.__Loaded and not self.OverrideBlacklist[key] then
			self.Overrides[key] = value

			self:SaveData()
		end

		self:ParentCall("NewIndex", key, value)
	end

	function ITEM:OnSpawn(ply)
	end

	function ITEM:OnDeath(ply)
	end

	function ITEM:GetModelData(ply)
		return {}
	end

	function ITEM:PostModelData(ply, data)
		return data
	end
end

return ITEM