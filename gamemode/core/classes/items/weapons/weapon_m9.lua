ITEM = class.Create("base_weapon")

ITEM.Name 				= "Beretta M9"
ITEM.Description 		= "An italian-made sidearm. Chambered in 9x19mm."

ITEM.Model 				= "models/weapons/tfa_ins2/w_m9.mdl"

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2000
ITEM.SellPrice 			= 800

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_m9"

ITEM.AmmoSlots 			= {
	["9x19mm"] = true
}

return ITEM