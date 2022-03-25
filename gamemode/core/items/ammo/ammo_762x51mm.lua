ITEM = class.Create("base_ammo")

ITEM.Name 				= "7.62x51mm M118"
ITEM.Description 		= "An ammo tin containing packs of M118 FMJ-AP rounds."

ITEM.Model 				= Model("models/Items/BoxMRounds.mdl")

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 320 -- 10 magazines

ITEM.AmmoGroup 			= "762x51mm"
ITEM.Ammo 				= "762x51mm"

return ITEM