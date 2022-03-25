local meta = FindMetaTable("Player")

function meta:LoadInventory()
	local species = self:GetActiveSpecies()
	local main = species.InventorySize

	local inv = {
		Main = GAMEMODE:CreateGrid(STORE_PLAYER, self:CharID(), "Main", unpack(main)).NetworkID
	}

	if species.AllowStash then
		local stash = GAMEMODE:GetConfig("StashSize")

		inv.Stash = GAMEMODE:CreateGrid(STORE_STASH, self:CharID(), "Stash", stash[1], stash[2], false, true).NetworkID
	end

	for _, v in pairs(species.EquipmentSlots) do
		inv[v] = GAMEMODE:CreateGrid(STORE_PLAYER, self:CharID(), v, 1, 1, true, true).NetworkID
	end

	for _, v in pairs(species.WeaponSlots) do
		inv[v] = GAMEMODE:CreateGrid(STORE_PLAYER, self:CharID(), v, 1, 1, true, true).NetworkID
	end

	for _, v in pairs(inv) do
		GAMEMODE:GetInventory(v):SetNetworked(true)
	end

	self:SetInventory(inv)
end

function meta:UnloadInventory()
	for _, v in pairs(self:Inventory()) do
		local inv = GAMEMODE:GetInventory(v)

		if inv then
			inv:SetNetworked(false)
			inv:Destroy()
		end
	end
end

function meta:TakeItem(classname, amount)
	return self:GetInventory("Main"):TakeItem(classname, amount)
end

function GM:CreateGrid(gridtype, id, name, width, height, equipment, single)
	return class.Instance("inventory_grid", {
		GridType = gridtype,
		GridID = id,
		GridName = name,
		Width = width,
		Height = height,
		EquipmentSlot = equipment,
		SingleSlot = single
	})
end

netstream.Hook("MoveItem", function(ply, data)
	local item = GAMEMODE:GetItem(data.ID)

	if not item then
		return
	end

	local from = item:GetInventory()
	local to = GAMEMODE:GetInventory(data.Inventory)

	if not from or not to then
		return
	end

	local x, y = unpack(data.Pos)

	if from == to then
		local x2, y2 = from:GetOrigin(item)

		if x == x2 and y == y2 then
			return
		end
	end

	if not ply:CanMoveItem(item, from, to) then
		return
	end

	local w, h = to:ResolveSize(item:GetSize())

	if data.Flip and not to:CanFit(x, y, h, w, {[item.NetworkID] = true}) then
		return
	elseif not data.Flip and not to:CanFit(x, y, w, h, {[item.NetworkID] = true}) then
		return
	end

	if data.Flip then
		item.Flipped = not item.Flipped
	end

	if not item:IsInStash() and to:IsInStash() then
		ply:VisibleMessage(string.format("%s puts their %s into their stash", ply:RPName(), string.lower(item:GetName())))
	elseif item:IsInStash() and not to:IsInStash() then
		ply:VisibleMessage(string.format("%s takes their %s out of their stash", ply:RPName(), string.lower(item:GetName())))
	end

	to:AddItem(item, x, y)
end, {
	ID = {Type = TYPE_NUMBER},
	Inventory = {Type = TYPE_NUMBER},
	Pos = {Type = TYPE_TABLE},
	Flip = {Type = TYPE_BOOL, Optional = true}
})

netstream.Hook("UseItem", function(ply, data)
	local item = GAMEMODE:GetItem(data.ID)
	local target = GAMEMODE:GetItem(data.Target)

	if not item or not target then
		return
	end

	if not item:CanInteract(ply) or not target:CanInteract(ply) then
		return
	end

	target:OnUse(ply, item)
end, {
	ID = {Type = TYPE_NUMBER},
	Target = {Type = TYPE_NUMBER}
})