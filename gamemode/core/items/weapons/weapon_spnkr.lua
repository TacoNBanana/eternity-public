ITEM = class.Create("base_weapon")

ITEM.Name 				= "M41 SPNKR"
ITEM.Description 		= "The M41 SSR MAV/AW, also known as the Jackhammer or the SPNKR is a heavy ordinance weapon used by the UNSC."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_spnkr.mdl")

ITEM.Width 				= 6
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_spnkr"

ITEM.AmmoSlots 			= {
	["102mm"] = true
}

return ITEM