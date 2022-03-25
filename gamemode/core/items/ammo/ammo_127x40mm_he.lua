ITEM = class.Create("base_ammo")

ITEM.Name 				= "12.7x40mm M225"
ITEM.Description 		= "An ammo tin containing packs of 12.7x40mm M225 SAP-HE rounds."

ITEM.Model 				= Model("models/Items/BoxSRounds.mdl")

ITEM.MaxStack 			= 120 -- 15/10 magazines

ITEM.AmmoGroup 			= "127x40mm"
ITEM.Ammo 				= "127x40mm_he"

return ITEM