ITEM = class.Create("base_ammo")

ITEM.Name 				= "5x23mm M443"
ITEM.Description 		= "An ammo tin containing packs of 5x23mm M443 Caseless ammunition."

ITEM.Model 				= Model("models/Items/BoxMRounds.mdl")

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 480 -- 8 magazines

ITEM.AmmoGroup 			= "5x23mm"
ITEM.Ammo 				= "5x23mm"

return ITEM