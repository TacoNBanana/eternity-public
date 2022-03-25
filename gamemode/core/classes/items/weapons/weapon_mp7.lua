ITEM = class.Create("base_weapon")

ITEM.Name 				= "MP7A1"
ITEM.Description 		= "A standard-issue combine weapon. Chambered in 4.6x30mm."

ITEM.Model 				= "models/tnb/weapons/w_mp7.mdl"

ITEM.Width 				= 3
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 3000
ITEM.SellPrice 			= 700

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_mp7"

ITEM.AttachmentSlots 	= {
	["Sight"] = true,
	["SMGMag"] = true
}

ITEM.AmmoSlots 			= {
	["46x30mm"] = true
}

return ITEM