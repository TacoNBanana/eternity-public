ITEM = class.Create("base_weapon")

ITEM.Name 				= "Makarov PMM"
ITEM.Description 		= "A more modern variant of the classic soviet sidearm. Chambered in 9x18mm Makarov."

ITEM.Model 				= "models/khrcw2/pistols/w_makarov.mdl"

ITEM.Bodygroups 		= {
	[0] = 1,
	[2] = 2,
	[3] = 1
}

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 1900
ITEM.SellPrice 			= 600

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_makarov_pmm"

ITEM.AmmoSlots 			= {
	["9x18mm"] = true
}

return ITEM