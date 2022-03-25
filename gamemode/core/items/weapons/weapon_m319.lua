ITEM = class.Create("base_weapon")

ITEM.Name 				= "M319 IGL"
ITEM.Description 		= "The M319 Individual Grenade Launcher is a single-shot, break-action grenade launcher used by the UNSC."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m139.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_m319"

ITEM.AmmoSlots 			= {
	["40mm"] = true
}

return ITEM