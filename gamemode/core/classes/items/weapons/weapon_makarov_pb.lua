ITEM = class.Create("base_weapon")

ITEM.Name 				= "Makarov PB"
ITEM.Description 		= "A soviet integrally suppressed pistol. Chambered in 9x18mm Makarov."

ITEM.Model 				= "models/khrcw2/pistols/w_makarov.mdl"

ITEM.Bodygroups 		= {
	[0] = 2,
	[1] = 1,
	[2] = 2,
	[3] = 1
}

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2000
ITEM.SellPrice 			= 900

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_makarov_pb"

ITEM.AmmoSlots 			= {
	["9x18mm"] = true
}

return ITEM