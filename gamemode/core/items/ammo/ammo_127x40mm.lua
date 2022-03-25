ITEM = class.Create("base_ammo")

ITEM.Name 				= "12.7x40mm M228"
ITEM.Description 		= "An ammo tin containing packs of 12.7x40mm M228 SAP-HP rounds."

ITEM.Model 				= Model("models/Items/BoxSRounds.mdl")

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 120 -- 15/10 magazines

ITEM.AmmoGroup 			= "127x40mm"
ITEM.Ammo 				= "127x40mm"

return ITEM