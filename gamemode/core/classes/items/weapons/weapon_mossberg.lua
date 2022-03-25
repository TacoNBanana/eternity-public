ITEM = class.Create("base_weapon")

ITEM.Name 				= "Mossberg"
ITEM.Description 		= "A bog-standard pump-action shotgun. Chambered in 12-gauge."

ITEM.Model 				= "models/weapons/tfa_ins2/w_m590_olli.mdl"

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2500
ITEM.SellPrice 			= 300

ITEM.WeaponClass 		= "eternity_mossberg"

ITEM.AttachmentSlots 	= {
	["Sight"] = true
}

ITEM.AmmoSlots 			= {
	["12ga"] = true
}

return ITEM