ITEM = class.Create("base_weapon")

ITEM.Name 				= "SPAS-12"
ITEM.Description 		= "A standard-issue overwatch weapon. Chambered in 12-gauge."

ITEM.Model 				= "models/weapons/w_shotgun.mdl"

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_shotgun"

ITEM.AttachmentSlots 	= {
	["Sight"] = true
}

ITEM.AmmoSlots 			= {
	["12ga"] = true
}

return ITEM