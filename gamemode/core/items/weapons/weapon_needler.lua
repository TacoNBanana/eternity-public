ITEM = class.Create("base_weapon")

ITEM.Name 				= "Type-33 Needler"
ITEM.Description 		= "The Type-25 Needler is a covenant infantry weapon that's feared for it's effectiveness against unshielded targets."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_needler.mdl")

ITEM.OutlineColor 		= Color(110, 76, 170)

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY}

ITEM.WeaponClass 		= "eternity_needler"

ITEM.AmmoSlots 			= {
	["needler"] = true
}

return ITEM