local meta = FindMetaTable("Player")

function GM:HandleItemRemappings()
	local config = self:GetConfig("ItemRemappings")

	for k, v in pairs(config) do
		while config[v] do
			v = config[v]
		end

		dbal.Update("eternity", "$items", {Class = v}, "Class = ?", k)
	end
end

function GM:LoadItem(data, inventory)
	if not class.Exists(data.Class) then
		return
	end

	local item = class.Instance(data.Class, data.id, pon.decode(data.CustomData))

	if data.StoreType == STORE_WORLD then
		local tab = pon.decode(data.StorePos)

		local pos = Vector(tab.vx, tab.vy, tab.vz)
		local ang = Angle(tab.ap, tab.ay, tab.ar)

		item:SetWorldItem(pos, ang, true)
	elseif inventory then
		local pos = pon.decode(data.StorePos)

		inventory:AddItem(item, pos.x, pos.y, true)
	end

	return item
end

function GM:LoadInventoryItems(inventory)
	for _, v in ipairs(dbal.Query("eternity", "SELECT * FROM $items WHERE StoreType = ? AND StoreID = ? AND StoreName = ?", inventory.GridType, inventory.GridID, inventory.GridName)) do
		self:LoadItem(v, inventory)
	end
end

function GM:LoadWorldItems()
	for _, v in ipairs(dbal.Query("eternity", "SELECT * FROM $items WHERE StoreType = ? AND StoreName = ?", STORE_WORLD, game.GetMap())) do
		self:LoadItem(v)
	end
end

function GM:CreateItem(classname)
	if not class.Exists(classname) then
		return
	end

	local id = dbal.Insert("eternity", "$items", {Class = classname}).LastInsert
	local data = dbal.Query("eternity", "SELECT * FROM $items WHERE id = ?", id)[1]
	local item = self:LoadItem(data)

	item:OnFirstCreated()

	return item
end

function GM:DeleteItem(id)
	local item

	if isnumber(id) then
		item = GAMEMODE:GetItem(id)
	else
		item = id
		id = item.NetworkID
	end

	dbal.Query("eternity", "DELETE FROM $items WHERE id = ?", id)

	if item then
		item:Destroy(true)
	end
end

function GM:GetOfflineItem(id)
	local item = self:GetItem(id)

	if item then
		return item, false
	end

	local data = dbal.Query("eternity", "SELECT * FROM $items WHERE id = ?", id)[1]

	if not data then
		return
	end

	item = class.Instance(data.Class, data.id, pon.decode(data.CustomData))

	return item, true
end

function GM:UpdateOfflineItem(id, field, value)
	local item, unload = self:GetOfflineItem(id)

	item[field] = value

	if unload then
		item:Destroy()
	end
end

function meta:GiveItem(classname, amount, nostack)
	if not class.Exists(classname) then
		return false
	end

	amount = amount or 1

	local item = class.Get(classname)
	local stacking = item:IsTypeOf("base_stacking")

	if stacking then
		if not nostack then
			for _, v in pairs(self:GetInventory("Main"):GetItems(classname)) do
				amount = amount - v:AdjustAmount(amount)

				if amount <= 0 then
					return
				end
			end
		end

		local count = item.MaxStack > 0 and math.ceil(amount / item.MaxStack) or 1

		for i = 1, count do
			local instance = GAMEMODE:CreateItem(classname)

			amount = amount - instance:AdjustAmount(amount)

			if not instance:OnWorldUse(self) then
				instance:SetWorldItem(self:GetItemDropLocation(), Angle())
			end

			if count == 1 then
				return instance
			end
		end
	else
		for i = 1, amount do
			local instance = GAMEMODE:CreateItem(classname)

			if not instance:OnWorldUse(self) then
				instance:SetWorldItem(self:GetItemDropLocation(), Angle())
			end

			if amount == 1 then
				return instance
			end
		end
	end
end

hook.Add("InitPostEntity", "items.InitPostEntity", function()
	GAMEMODE:HandleItemRemappings()
	GAMEMODE:LoadWorldItems()
end)