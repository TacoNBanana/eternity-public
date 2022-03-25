ITEM = class.Create("base_ammo")

ITEM.Name 				= "14.5x114mm APFSDS"
ITEM.Description 		= "An ammo tin containing loose 14.5x114mm APFSDS rounds."

ITEM.Model 				= Model("models/Items/BoxMRounds.mdl")

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 40 -- 10 magazines

ITEM.AmmoGroup 			= "145x114mm"
ITEM.Ammo 				= "145x114mm"

return ITEM