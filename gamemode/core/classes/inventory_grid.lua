local CLASS = class.Create("base_replicated")

CLASS.NetworkGroup 	= "Inventory"

CLASS.GridType 		= STORE_NONE
CLASS.GridID 		= -1
CLASS.GridName 		= ""

CLASS.Grid 			= {}
CLASS.Items 		= {}

CLASS.Width 		= 1
CLASS.Height 		= 1

CLASS.SingleSlot 	= false
CLASS.EquipmentSlot = false

if CLIENT then
	CLASS.GridPanels 	= {}
end

function CLASS:GetItem(x, y)
	local id = self.Grid[x][y]

	if not id then
		return false
	end

	return GAMEMODE:GetItem(id)
end

function CLASS:GetItems(classname)
	local tab = {}

	for k, v in pairs(self.Items) do
		local item = GAMEMODE:GetItem(k)

		if not classname or (item:GetClassName() == classname) then
			table.insert(tab, {Item = item, Sort = string.format("%s-%s", v.y, v.x)})
		end
	end

	table.SortByMember(tab, "Sort", true)

	for k, v in pairs(tab) do
		tab[k] = v.Item
	end

	return tab
end

function CLASS:ResolveSize(w, h)
	if self.SingleSlot then
		return 1, 1
	else
		return w, h
	end
end

function CLASS:GetGridName()
	return self.EquipmentSlot and EQUIPMENT_TO_TEXT[self.GridName] or self.GridName
end

function CLASS:CanRemove(item)
	if self.EquipmentSlot and not item:CanUnequip(self:GetParent()) then
		return false
	end

	return true
end

function CLASS:CanAccept(item)
	if self.EquipmentSlot then
		if not table.HasValue(item.EquipmentSlots, self.GridName) then
			return false
		end

		if not item:CanEquip(self:GetParent()) then
			return false
		end
	end

	if self.GridType == STORE_ITEM then
		-- Don't store ourselves
		if table.HasValue(item.Inventories, self.NetworkID) then
			return false
		end

		local parent = self:GetParent()

		if not parent:CanAccept(self, item) then
			return false
		end

		-- Recursively check our parent item to see if we're trying to create a paradox
		while true do
			if parent == item then
				return false
			end

			local inventory = parent:GetInventory()

			if not inventory or inventory.GridType != STORE_ITEM then
				break
			end

			parent = inventory:GetParent()
		end
	end

	return true
end

function CLASS:GetOrigin(item)
	local tab = self.Items[item.NetworkID]

	return tab.x, tab.y
end

function CLASS:CanFit(x, y, w, h, filter)
	filter = filter or {}

	if self.EquipmentSlot then
		return not self.Grid[1][1]
	end

	if x + w - 1 > self.Width or y + h - 1 > self.Height then
		return false
	end

	for offsetx = 0, w - 1 do
		for offsety = 0, h - 1 do
			local val = self.Grid[x + offsetx][y + offsety]

			if val and not filter[val] then
				return false
			end
		end
	end

	return true
end

function CLASS:FindItemFit(item, filter)
	local w, h = self:ResolveSize(item:GetSize())

	local flipped = false
	local ok, x, y = self:FindFit(w, h, filter)

	if not ok then
		flipped = true
		ok, x, y = self:FindFit(h, w, filter)

		if not ok then
			return false
		end
	end

	return true, flipped, x, y
end

function CLASS:FindFit(w, h, filter)
	w, h = self:ResolveSize(w, h)

	if w > self.Width or h > self.Height then
		return false
	end

	for y = 1, self.Height - h + 1 do
		for x = 1, self.Width - w + 1 do
			if self:CanFit(x, y, w, h, filter) then
				return true, x, y
			end
		end
	end

	return false
end

function CLASS:GetItemCount(classname, recursive)
	local amount = 0
	local stacking = class.Get(classname):IsTypeOf("base_stacking")

	for _, v in pairs(self:GetItems(classname)) do
		if stacking then
			amount = amount + v.Stack
		else
			amount = amount + 1
		end
	end

	if recursive then
		for _, v in pairs(self:GetItems()) do
			for _, inv in pairs(v.Inventories) do
				amount = amount + GAMEMODE:GetInventory(inv):GetItemCount(classname, true)
			end
		end
	end

	return amount
end

function CLASS:HasItem(classname, amount)
	return self:GetItemCount(classname) >= (amount or 1)
end

function CLASS:FindItem(classname)
	local matches = self:GetItems(classname)

	if #matches > 0 then
		return matches[1]
	end

	return false
end

function CLASS:GetContainer()
	if self.GridType != STORE_CONTAINER then
		return false
	end

	for _, v in pairs(ents.FindByClass("ent_*")) do
		if v.IsReady and v:IsReady() and v:GetEntityID() == self.GridID then
			return v
		end
	end
end

function CLASS:CanInteract(ply)
	if ply:Restrained() then
		return false
	end

	if self.GridType == STORE_PLAYER then
		if ply:IsAdmin() then
			return true
		end

		return self.GridID == ply:CharID()
	elseif self.GridType == STORE_ITEM then
		local item = GAMEMODE:GetItem(self.GridID)

		return item:CanInteract(ply) and item:CanInteractWithChild(ply)
	elseif self.GridType == STORE_CONTAINER then
		return self:GetContainer():CanAccessInventory(ply)
	elseif self.GridType == STORE_STASH then
		if ply:IsAdmin() then
			return true
		end

		if self.GridID != ply:CharID() then
			return false
		end

		local ent = ply:LastStash()

		if not IsValid(ent) then
			return false
		end

		return ent:WithinInteractRange(ply)
	end
end

function CLASS:GetParent()
	if self.GridType == STORE_PLAYER or self.GridType == STORE_STASH then
		return GAMEMODE:GetPlayerByCharID(self.GridID)
	elseif self.GridType == STORE_ITEM then
		return GAMEMODE:GetItem(self.GridID)
	elseif self.GridType == STORE_CONTAINER then
		return self:GetContainer()
	end
end

function CLASS:IsInStash()
	return self:GetTopLevelInventory().GridType == STORE_STASH
end

function CLASS:GetTopLevelInventory()
	local parent = self

	while true do
		if parent.GridType != STORE_ITEM then
			return parent
		end

		parent = parent:GetParent():GetInventory()
	end
end

if CLIENT then
	function CLASS:OnUpdated(key, value)
		if key == "Items" then
			for v in pairs(self.GridPanels) do
				if IsValid(v) then
					v:Setup(self)
				else
					self.GridPanels[v] = nil
				end
			end
		end
	end
end

if SERVER then
	function CLASS:OnCreated(args)
		for k, v in pairs(args) do
			self[k] = v
		end

		for i = 1, self.Width do
			self.Grid[i] = {}
		end

		if not class.Networked[self.NetworkGroup] then
			class.Networked[self.NetworkGroup] = {}
		end

		self.NetworkID = table.insert(class.Networked[self.NetworkGroup], self)
		self:LoadItems()
	end

	function CLASS:SetNetworked(bool)
		self:ParentCall("SetNetworked", bool)

		for item in pairs(self.Items) do
			GAMEMODE:GetItem(item):SetNetworked(bool)
		end
	end

	function CLASS:Destroy()
		for item in pairs(self.Items) do
			GAMEMODE:GetItem(item):Destroy()
		end

		self:ParentCall("Destroy")
	end

	function CLASS:LoadItems()
		GAMEMODE:LoadInventoryItems(self)
	end

	function CLASS:AddItem(item, x, y, loading)
		local inventory = item:GetInventory()

		if inventory then
			inventory:RemoveItem(item)
		end

		item:SetNetworked(self:GetNetworked())

		local grid = self.Grid
		local w, h = self:ResolveSize(item:GetSize())

		for offsetx = 0, w - 1 do
			for offsety = 0, h - 1 do
				if (x + offsetx) > self.Width or (y + offsety) > self.Height then
					continue
				end

				grid[x + offsetx][y + offsety] = item.NetworkID
			end
		end

		self.Grid = table.Copy(grid)

		self.Items[item.NetworkID] = {x = x, y = y}
		self.Items = table.Copy(self.Items)

		item.InventoryID = self.NetworkID

		if not loading then
			item:SaveLocation()
		end

		if self.EquipmentSlot then
			local ply = self:GetParent()

			if not loading then
				GAMEMODE:WriteLog("item_equip", {
					Ply = GAMEMODE:LogPlayer(ply),
					Char = GAMEMODE:LogCharacter(ply),
					Item = GAMEMODE:LogItem(item)
				})
			end

			item:OnEquip(ply, self.GridName, loading)
		end
	end

	function CLASS:RemoveItem(item, unloading)
		local pos = self.Items[item.NetworkID]
		local grid = self.Grid
		local w, h = self:ResolveSize(item:GetSize())

		for x = 0, w - 1 do
			for y = 0, h - 1 do
				if (pos.x + x) > self.Width or (pos.y + y) > self.Height then
					continue
				end

				grid[pos.x + x][pos.y + y] = nil
			end
		end

		self.Grid = table.Copy(grid)

		self.Items[item.NetworkID] = nil
		self.Items = table.Copy(self.Items)

		item.InventoryID = nil

		if self.EquipmentSlot then
			local ply = self:GetParent()

			if not unloading then
				GAMEMODE:WriteLog("item_unequip", {
					Ply = GAMEMODE:LogPlayer(ply),
					Char = GAMEMODE:LogCharacter(ply),
					Item = GAMEMODE:LogItem(item)
				})
			end

			item:OnUnequip(ply, self.GridName, unloading)
		end
	end

	function CLASS:TakeItem(classname, amount)
		for y = 1, self.Height do
			for x = 1, self.Width do
				local item = self:GetItem(x, y)

				if not item or item:GetClassName() != classname then
					continue
				end

				if item:IsTypeOf("base_stacking") then
					amount = amount - item:AdjustAmount(-amount)
				else
					GAMEMODE:DeleteItem(item)
					amount = amount - 1
				end

				if amount <= 0 then
					return
				end
			end
		end
	end
end

class.Register("inventory_grid", CLASS)