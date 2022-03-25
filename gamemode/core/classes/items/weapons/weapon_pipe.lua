ITEM = class.Create("base_weapon")

ITEM.Name 				= "Metal Pipe"
ITEM.Description 		= "A lead pipe."

ITEM.Model 				= "models/props_canal/mattpipe.mdl"

ITEM.License 			= LICENSE_GREY
ITEM.UnitPrice 			= 300
ITEM.SellPrice 			= 100

ITEM.Width 				= 1
ITEM.Height 			= 3

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_pipe"

ITEM.NoDurability 		= true

return ITEM