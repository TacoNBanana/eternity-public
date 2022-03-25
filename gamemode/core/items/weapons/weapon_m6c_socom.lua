ITEM = class.Create("base_weapon")

ITEM.Name 				= "M6C/SOCOM"
ITEM.Description 		= "The M6C/SOCOM is a variant of the M6 handgun issued to special forces."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m6s.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_m6c_socom"

ITEM.AmmoSlots 			= {
	["127x40mm"] = true
}

return ITEM