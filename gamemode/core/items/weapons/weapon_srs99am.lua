ITEM = class.Create("base_weapon")

ITEM.Name 				= "SRS99-AM"
ITEM.Description 		= "Formally known as the Special Applications Rifle, Caliber 14.5mm, the SRS99-AM is a long-range anti-material rifle used by the UNSC."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_srs99am.mdl")

ITEM.Width 				= 5
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_srs99am"

ITEM.AmmoSlots 			= {
	["145x114mm"] = true
}

return ITEM