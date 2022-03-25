ITEM = class.Create("base_item")

ITEM.Model 				= Model("models/weapons/w_mach_m249para.mdl")

ITEM.ItemGroup 			= "Weapon"

ITEM.OverrideBlacklist 	= {
	["Overrides"] = true,
	["OverrideBlacklist"] = true,
	["NetworkBlacklist"] = true,
	["InventoryID"] = true,
	["EntityID"] = true,
	["Weapon"] = true
}

ITEM.Weapon 			= nil
ITEM.WeaponClass 		= ""

ITEM.AmmoSlots 			= {}
ITEM.AmmoSave 			= {}

ITEM.TriggersNPCs 		= true

function ITEM:OnEquip(ply, slot, loading)
	if SERVER and not loading then
		self:GiveWeapon(ply)

		ply:HandleNPCRelationships()
	end
end

function ITEM:OnUnequip(ply, slot, unloading)
	if SERVER then
		self:SaveAmmo()

		if not unloading then
			self:TakeWeapon(ply)

			ply:HandleNPCRelationships()
		end
	end
end

function ITEM:GetWeapon()
	if not self.Weapon then
		return
	end

	return Entity(self.Weapon)
end

function ITEM:GetAmmo(slot)
	return self:GetChildInventory(slot):GetItem(1, 1)
end

function ITEM:CanAccept(inventory, item)
	if not item:IsTypeOf("base_ammo") then
		return false
	end

	return item.AmmoGroup == inventory.GridName
end

function ITEM:OnUse(ply, item)
	if SERVER then
		return
	end

	if item:IsTypeOf("base_ammo") then
		for k in pairs(self.Inventories) do
			local inventory = self:GetChildInventory(k)

			if not self:CanAccept(inventory, item) then
				continue
			end

			local contents = inventory:GetItem(1, 1)

			if contents then
				netstream.Send("UseItem", {
					ID = item.NetworkID,
					Target = contents.NetworkID
				})
			else
				netstream.Send("MoveItem", {
					ID = item.NetworkID,
					Inventory = inventory.NetworkID,
					Pos = {1, 1}
				})
			end
		end
	end
end

if SERVER then
	function ITEM:CreateInventories()
		self:ParentCall("CreateInventories")

		for k, v in pairs(self.AmmoSlots) do
			self.Inventories[k] = GAMEMODE:CreateGrid(STORE_ITEM, self.NetworkID, k, 1, 1, false, true).NetworkID
		end
	end

	function ITEM:OnSpawn(ply)
		self:GiveWeapon(ply, true)
	end

	function ITEM:OnDeath(ply)
		self.Weapon = nil
	end

	function ITEM:GiveWeapon(ply, load)
		local weapon = ply:Give(self.WeaponClass)

		if weapon.SetItemID then
			weapon:SetItemID(self.NetworkID)
		end

		self.Weapon = weapon:EntIndex()
	end

	function ITEM:TakeWeapon(ply)
		ply:StripWeapon(self.WeaponClass)

		self.Weapon = nil
	end

	function ITEM:SaveAmmo()
		local weapon = self:GetWeapon()

		if IsValid(weapon) and weapon.SaveAmmo then
			weapon:SaveAmmo()
		end
	end
end

return ITEM