ITEM = class.Create("base_item")

ITEM.Name 				= "Overwatch uniform"
ITEM.Description 		= "Ribbed for her pleasure."

ITEM.Model 				= Model("models/props_c17/suitcase_passenger_physics.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 4

ITEM.OutlineColor 		= Color(222, 92, 0)

ITEM.EquipmentSlots 	= {EQUIPMENT_OVERWATCH}

ITEM.ItemGroup 			= "Clothing"

ITEM.ArmorLevel 		= ARMOR_COTA
ITEM.Filtered 			= true

ITEM.HandsModel 		= Model("models/weapons/c_arms_combine.mdl")

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/Combine_Soldier.mdl")
			}
		}
	end
end

return ITEM