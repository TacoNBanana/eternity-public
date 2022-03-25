ITEM = class.Create("base_weapon")

ITEM.Name 				= "Makarov PM"
ITEM.Description 		= "An old soviet sidearm. Chambered in 9x18mm Makarov."

ITEM.Model 				= "models/khrcw2/pistols/w_makarov.mdl"

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 1500
ITEM.SellPrice 			= 400

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_makarov"

ITEM.AmmoSlots 			= {
	["9x18mm"] = true
}

return ITEM