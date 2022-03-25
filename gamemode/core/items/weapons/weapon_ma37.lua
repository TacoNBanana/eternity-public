ITEM = class.Create("base_weapon")

ITEM.Name 				= "MA37 ICWS"
ITEM.Description 		= "Also known as the MA5, the MA37 Individual Combat Weapon System is the UNSC's standard-issue service rifle. Chambered in 7.62x51mm."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_ma37.mdl")

ITEM.Width 				= 4
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.License 			= LICENSE_QM

ITEM.WeaponClass 		= "eternity_ma37"

ITEM.AmmoSlots 			= {
	["762x51mm"] = true
}

return ITEM