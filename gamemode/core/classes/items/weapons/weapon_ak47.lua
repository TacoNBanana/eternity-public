ITEM = class.Create("base_weapon")

ITEM.Name 				= "AK-47"
ITEM.Description 		= "The classic soviet-era assault rifle. Chambered in 7.62x39mm."

ITEM.Model 				= "models/weapons/tfa_cod/mwr/w_ak47.mdl"

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 3000
ITEM.SellPrice 			= 1200

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_ak47"

ITEM.AttachmentSlots 	= {
	["Sight"] = true
}

ITEM.AmmoSlots 			= {
	["762x39mm"] = true
}

return ITEM