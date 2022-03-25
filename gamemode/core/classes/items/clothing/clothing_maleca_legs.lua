ITEM = class.Create("base_item")

ITEM.Name 				= "Civil Administration Slacks"
ITEM.Description 		= "Fresh and crisp"

ITEM.Model 				= Model("models/tnb/items/pants_citizen.mdl")

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			legs = {
				Model = "models/tnb/halflife2/male_legs_admin1.mdl"
			}
		}
	end
end

return ITEM