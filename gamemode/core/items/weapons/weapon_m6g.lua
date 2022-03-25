ITEM = class.Create("base_weapon")

ITEM.Name 				= "M6G PDWS"
ITEM.Description 		= "The M6G Personal Defense Weapon System is a variant of the M6 handgun issued exclusively to SPARTAN-III's and features a built-in 2x optical smart-linked scope."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m6g.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_m6g"

ITEM.AmmoSlots 			= {
	["127x40mm"] = true
}

return ITEM