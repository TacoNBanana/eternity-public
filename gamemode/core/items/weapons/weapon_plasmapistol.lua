ITEM = class.Create("base_weapon")

ITEM.Name 				= "Type-25 Plasma Pistol"
ITEM.Description 		= "The Type-25 Directed Energy Pistol is a covenant infantry weapon that's commonly carried by smaller covenant species."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/w_plasmapistol.mdl")

ITEM.OutlineColor 		= Color(110, 76, 170)

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY}

ITEM.WeaponClass 		= "eternity_plasmapistol"

return ITEM