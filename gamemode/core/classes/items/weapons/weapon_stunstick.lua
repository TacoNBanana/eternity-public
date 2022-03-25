ITEM = class.Create("base_weapon")

ITEM.Name 				= "Stunbaton"
ITEM.Description 		= "A standard-issue combine crowd control implement. Can also serve as a nice bludgeon tool."

ITEM.OutlineColor 		= Color(33, 106, 196)

ITEM.Model 				= "models/weapons/w_stunbaton.mdl"

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_stunstick"

ITEM.NoDurability 		= true -- Melee weapons don't have durability built in so they need ITEM.NoDurability

return ITEM