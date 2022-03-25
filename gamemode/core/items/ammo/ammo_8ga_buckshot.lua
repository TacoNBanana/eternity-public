ITEM = class.Create("base_ammo")

ITEM.Name 				= "8 Gauge M296 Magnum"
ITEM.Description 		= "A box of loose 8 gauge magnum shells."

ITEM.Model 				= Model("models/Items/BoxBuckshot.mdl")

ITEM.License 			= LICENSE_QM

ITEM.MaxStack 			= 60 -- 10 reloads

ITEM.AmmoGroup 			= "8ga"
ITEM.Ammo 				= "8ga_buckshot"

return ITEM