ITEM = class.Create("base_weapon")

ITEM.Name 				= "SKS"
ITEM.Description 		= "Magazine-fed soviet self loading rifle. Chambered in 7.62x39mm."

ITEM.Model 				= "models/weapons/tfa_ins2/w_sks.mdl"

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2000
ITEM.SellPrice 			= 800

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_sks"

ITEM.AttachmentSlots 	= {
	["Sight"] = true -- Matches with ITEM.AttachmentSlot
}

ITEM.AmmoSlots 			= {
	["762x39mm"] = true -- Matches with ITEM.AmmoGroup and SWEP.AmmoGroup
}

return ITEM