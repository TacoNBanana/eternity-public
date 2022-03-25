ITEM = class.Create("base_weapon")

ITEM.Name 				= "M45 Tactical Shotgun"
ITEM.Description 		= "The M45 Tactical Shotgun is a weapon designed for close quarters combat and boarding scenarios by the UNSC."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_m45.mdl")

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_m45"

ITEM.AmmoSlots 			= {
	["8ga"] = true
}

return ITEM