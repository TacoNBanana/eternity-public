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

ITEM.Durability 		= 100 -- Durability is handled in SWEP:HandleDurability()
ITEM.NoDurability 		= false

function ITEM:GetName()
	local name = self:ParentCall("GetName")

	if self:IsBroken() then
		name = string.format("%s (Broken)", name)
	end

	return name
end

function ITEM:GetDescription()
	local description = self:ParentCall("GetDescription")

	if self:IsBroken() then
		description = string.format("%s\n\n<col=255,0,0>Broken</col>", description)
	end

	return description
end

function ITEM:GetOutlineColor()
	if self.NoDurability then
		return self:ParentCall("GetOutlineColor")
	end

	local durability = self.Durability
	local weapon = self:GetWeapon()

	if IsValid(weapon) and weapon.GetDurability then -- Only use the item's stored durability when it's not equipped, otherwise use what the weapon's got stored since it's more up to date
		durability = weapon:GetDurability()
	end

	return LerpVector(durability / 100, Vector(1, 0, 0), Vector(0, 1, 0)):ToColor()
end

function ITEM:OnEquip(ply, slot, loading)
	if SERVER and not loading then
		self:GiveWeapon(ply)

		ply:HandleNPCRelationships()
	end
end

function ITEM:OnUnequip(ply, slot, unloading)
	if SERVER then
		self:HandleDurability()

		if not unloading then
			self:TakeWeapon(ply)

			ply:HandleNPCRelationships()
		end
	end
end

function ITEM:OnUse(ply, item)
	if item:IsTypeOf("repairkit") and SERVER then
		self:HandleDurability()

		if self.Durability >= 85 then
			ply:SendChat("NOTICE", string.format("You try to repair your %s but realize there's nothing to repair", self:GetName()))

			return
		end

		if not ply:WaitFor(10, "Repairing...", {self}) then
			return
		end

		ply:VisibleMessage(string.format("%s repairs their %s", ply:RPName(), self:GetName()))

		GAMEMODE:DeleteItem(item)

		self:SetDurability(math.Min(self.Durability + item.RepairAmount, 100), ply)
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

function ITEM:IsBroken()
	if self.NoDurability then
		return false
	end

	return self.Durability <= 0
end

function ITEM:CanAccept(inventory, item)
	if not item:IsTypeOf("base_ammo") then
		return false
	end

	return item.AmmoGroup == inventory.GridName
end

if SERVER then
	function ITEM:ProcessArguments(args)
		if not self.NoDurability and tonumber(args) then
			self:SetDurability(math.Clamp(args, 0, 100))
		end
	end

	function ITEM:CreateInventories()
		self:ParentCall("CreateInventories")

		for k, v in pairs(self.AmmoSlots) do
			self.Inventories[k] = GAMEMODE:CreateGrid(STORE_ITEM, self.NetworkID, k, 1, 1).NetworkID
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

		if weapon.SetBroken then
			weapon:SetBroken(self:IsBroken())
		end

		self.Weapon = weapon:EntIndex()
	end

	function ITEM:TakeWeapon(ply)
		ply:StripWeapon(self.WeaponClass)

		self.Weapon = nil
	end

	function ITEM:SetDurability(new, ply)
		if self.NoDurability then
			return
		end

		self.Durability = new

		if new <= 0 and IsValid(ply) then
			ply:SendChat("ERROR", "Your weapon breaks!")
		end

		local weapon = self:GetWeapon()

		if IsValid(weapon) and weapon.SetBroken then
			weapon:SetBroken(self:IsBroken())
		end
	end

	function ITEM:HandleDurability()
		local weapon = self:GetWeapon()

		if IsValid(weapon) and weapon.HandleDurability then
			weapon:HandleDurability(true)
		end
	end
end

return ITEM