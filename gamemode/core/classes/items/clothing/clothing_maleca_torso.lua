ITEM = class.Create("base_item")

ITEM.Name 				= "Civil Administration Jacket"
ITEM.Description 		= "Finely kept Shirt"

ITEM.Model 				= Model("models/tnb/items/wintercoat.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = "models/tnb/halflife2/male_torso_admin1.mdl"
			}
		}
	end
end

return ITEM