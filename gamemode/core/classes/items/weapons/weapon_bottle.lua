ITEM = class.Create("base_weapon")

ITEM.Name 				= "Glass Bottle"
ITEM.Description 		= "Useful in bar fights. (Not thrown)"

ITEM.Model 				= "models/tnb/weapons/w_bottle.mdl"

ITEM.License 			= LICENSE_GREY
ITEM.UnitPrice 			= 300
ITEM.SellPrice 			= 100

ITEM.Width 				= 1
ITEM.Height 			= 1

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_bottle"

ITEM.NoDurability 		= true

return ITEM