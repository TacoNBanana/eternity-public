ITEM = class.Create("base_weapon")

ITEM.Name 				= "M7 SMG"
ITEM.Description 		= "Formally known as the M7/Caseless, the M7 is a UNSC issued PDW commonly used by infantry, special forces and vehicle crews."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m7.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_m7"

ITEM.AmmoSlots 			= {
	["5x23mm"] = true
}

return ITEM