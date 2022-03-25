ITEM = class.Create("base_weapon")

ITEM.Name 				= "Handheld floodlight"
ITEM.Description 		= "A portable floodlight, very bright."

ITEM.Model 				= Model("models/lamps/torch.mdl")
ITEM.Color 				= Color(255, 210, 40)

ITEM.Width 				= 1
ITEM.Height 			= 1

ITEM.EquipmentSlots 	= {EQUIPMENT_MISC}

ITEM.WeaponClass 		= "eternity_light_flood"

ITEM.TriggersNPCs 		= false
ITEM.NoDrop 			= true

return ITEM