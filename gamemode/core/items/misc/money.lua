ITEM = class.Create("base_stacking")

ITEM.SingularName 		= "%s Credit"
ITEM.PluralName 		= "%s Credits"

ITEM.Description 		= "A credit chip containing a certain amount of cR, the standard UEG currency."

ITEM.Model 				= Model("models/gibs/metal_gib4.mdl")

ITEM.ItemGroup 			= "Currency"

ITEM.MaxStack 			= 1000

return ITEM