ITEM = class.Create("base_ammo")

ITEM.Name 				= "102mm M19"
ITEM.Description 		= "A bundle of 102mm M19 surface-to-surface missiles."

ITEM.Model 				= Model("models/vuthakral/halo/weapons/spnkr_rocket.mdl")

ITEM.Width 				= 2

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 6 -- 3 reloads

ITEM.AmmoGroup 			= "102mm"
ITEM.Ammo 				= "102mm_spnkr"

return ITEM