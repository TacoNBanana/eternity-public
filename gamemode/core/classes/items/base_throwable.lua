ITEM = class.Create("base_stacking")

ITEM.Model 				= Model("models/weapons/w_grenade.mdl")

ITEM.ItemGroup 			= "Throwable"

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

ITEM.TriggersNPCs 		= true

function ITEM:OnEquip(ply, slot, loading)
	if SERVER and not loading then
		self:GiveWeapon(ply)

		ply:HandleNPCRelationships()
	end
end

function ITEM:OnUnequip(ply, slot, unloading)
	if SERVER and not unloading then
		self:TakeWeapon(ply)

		ply:HandleNPCRelationships()
	end
end

function ITEM:GetWeapon()
	if not self.Weapon then
		return
	end

	return Entity(self.Weapon)
end

if SERVER then
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
	end
end

return ITEM