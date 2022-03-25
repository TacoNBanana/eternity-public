local meta = FindMetaTable("Player")

function meta:GetInventory(name)
	return class.GetNetworked("Inventory", self:Inventory()[name])
end

function GM:GetInventory(id)
	return class.GetNetworked("Inventory", id)
end

function GM:GetInventoryByType(gridtype, id, name)
	for _, v in pairs(class.Networked.Inventory) do
		if v.GridType == gridtype and v.GridID == id and v.GridName == name then
			return v
		end
	end
end

function meta:CanMoveItem(item, from, to)
	if not from:CanInteract(self) or not to:CanInteract(self) then
		return false
	end

	if not from:CanRemove(item) then
		return false
	end

	if not to:CanAccept(item) then
		return false
	end

	return true
end

function meta:GetEquipment(slot)
	if slot then
		local inventory = self:GetInventory(slot)

		if not inventory then
			return
		end

		return self:GetInventory(slot):GetItem(1, 1)
	else
		local tab = {}
		local species = self:GetActiveSpecies()

		for _, v in pairs(species.EquipmentSlots) do
			local inventory = self:GetInventory(v)

			if not inventory then
				continue
			end

			tab[v] = inventory:GetItem(1, 1) or nil
		end

		for _, v in pairs(species.WeaponSlots) do
			local inventory = self:GetInventory(v)

			if not inventory then
				continue
			end

			tab[v] = inventory:GetItem(1, 1) or nil
		end

		return tab
	end
end

function meta:GetItemCount(classname, recursive, checkstash)
	local amount = 0

	for k, v in pairs(self:Inventory()) do
		if k == "Stash" and not checkstash then
			continue
		end

		amount = amount + GAMEMODE:GetInventory(v):GetItemCount(classname, recursive)
	end

	return amount
end

function meta:HasItem(classname, amount)
	return self:GetInventory("Main"):HasItem(classname, amount or 1)
end