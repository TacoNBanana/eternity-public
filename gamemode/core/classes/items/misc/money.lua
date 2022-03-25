ITEM = class.Create("base_stacking")

ITEM.SingularName 		= "%s Credit"
ITEM.PluralName 		= "%s Credits"

ITEM.Description 		= "A form of paper currency introduced by the combine."

ITEM.Model 				= Model("models/props/cs_assault/money.mdl")

ITEM.ItemGroup 			= "Currency"

ITEM.MaxStack 			= 1000

return ITEM