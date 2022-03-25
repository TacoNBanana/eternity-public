ITEM = class.Create("base_weapon")

ITEM.Name 				= "Crowbar"
ITEM.Description 		= "A sturdy iron crowbar painted red."

ITEM.Model 				= "models/weapons/w_crowbar.mdl"

ITEM.License 			= LICENSE_GREY
ITEM.UnitPrice 			= 500
ITEM.SellPrice 			= 100

ITEM.Width 				= 1
ITEM.Height 			= 3

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_crowbar"

ITEM.NoDurability 		= true

return ITEM