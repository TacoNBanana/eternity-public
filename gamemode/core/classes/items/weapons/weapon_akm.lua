ITEM = class.Create("base_weapon")

ITEM.Name 				= "AKM"
ITEM.Description 		= "A modernized version of the classic soviet weapon. Chambered in 7.62x39mm."

ITEM.Model 				= "models/weapons/tfa_ins2/w_akz.mdl"

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 3000
ITEM.SellPrice 			= 1200

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_akm"

ITEM.AttachmentSlots 	= {
	["Sight"] = true
}

ITEM.AmmoSlots 			= {
	["762x39mm"] = true
}

return ITEM