ITEM = class.Create("base_weapon")

ITEM.Name 				= "USP Match"
ITEM.Description 		= "A standard-issue combine sidearm. Chambered in .45 ACP."

ITEM.Model 				= "models/weapons/tfa_ins2/w_usp_match.mdl"

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2100
ITEM.SellPrice 			= 600

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_usp"

ITEM.AmmoSlots 			= {
	["45acp"] = true
}

return ITEM