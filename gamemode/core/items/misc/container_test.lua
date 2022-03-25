ITEM = class.Create("base_item")

ITEM.Name 				= "Box"
ITEM.Description 		= "A box. It holds stuff. Revolutionary I know."

ITEM.Model 				= Model("models/props_junk/cardboard_box001a.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.Inventories 		= {
	["Main"] = {2, 2}
}

return ITEM