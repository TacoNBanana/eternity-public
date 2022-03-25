ITEM = class.Create("base_weapon")

ITEM.Name 				= "M7S SMG"
ITEM.Description 		= "A variant of the M7/Caseless, the M7S features an SS/M 49 sound suppressor and is commonly issued to UNSC special forces."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m7s.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_m7s"

ITEM.AmmoSlots 			= {
	["5x23mm"] = true
}

return ITEM