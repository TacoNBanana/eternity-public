ITEM = class.Create("base_weapon")

ITEM.Name 				= "M6C PDWS"
ITEM.Description 		= "The M6C Personal Defense Weapon System is a variant of the M6 handgun and the UNSC's standard sidearm."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m6c.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_m6c"

ITEM.AmmoSlots 			= {
	["127x40mm"] = true
}

return ITEM