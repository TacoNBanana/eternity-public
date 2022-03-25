ITEM = class.Create("base_throwable")

ITEM.Name 				= "M-83 Smoke Grenade"
ITEM.Description 		= "A smoke grenade. Burns anywhere between 50 and 90 seconds."

ITEM.Model 				= Model("models/weapons/w_grenade.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_MISC}

ITEM.MaxStack 			= 3

ITEM.WeaponClass 		= "eternity_grenade_smoke"
ITEM.SmokeColor 		= Vector(135, 135, 135)

return ITEM