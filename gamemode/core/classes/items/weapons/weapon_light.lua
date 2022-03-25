ITEM = class.Create("base_weapon")

ITEM.Name 				= "Handheld searchlight"
ITEM.Description 		= "A portable searchlight, runs on a large rechargable battery."

ITEM.Model 				= Model("models/lamps/torch.mdl")

ITEM.Width 				= 1
ITEM.Height 			= 1

ITEM.EquipmentSlots 	= {EQUIPMENT_MISC}

ITEM.WeaponClass 		= "eternity_light"

ITEM.TriggersNPCs 		= false

ITEM.NoDurability 		= true
ITEM.NoDrop 			= true

return ITEM