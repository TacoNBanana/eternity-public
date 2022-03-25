ITEM = class.Create("base_weapon")

ITEM.Name 				= "OTs-14 Groza"
ITEM.Description 		= "A compact russian assault rifle. Chambered in 7.62x39mm."

ITEM.Model 				= "models/weapons/tfa_ins2/w_groza.mdl"

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 3000
ITEM.SellPrice 			= 700

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_groza"

ITEM.AttachmentSlots 	= {
	["Sight"] = true
}

ITEM.AmmoSlots 			= {
	["762x39mm"] = true
}

return ITEM