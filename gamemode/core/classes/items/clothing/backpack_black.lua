ITEM = class.Create("base_item")

ITEM.Name 				= "Backpack"
ITEM.Description 		= "A large and spacious backpack."

ITEM.Model 				= Model("models/props_c17/suitcase_passenger_physics.mdl")

ITEM.Width 				= 3
ITEM.Height 			= 4

ITEM.EquipmentSlots 	= {EQUIPMENT_BACK}

ITEM.ItemGroup 			= "Clothing"

ITEM.Inventories 		= {
	["Main"] = {3, 4}
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			back = {
				Model = Model(string.format("models/eternity/clothing/%s_backpack_black.mdl", GAMEMODE:GetGenderString(ply:CharModel())))
			}
		}
	end
end

return ITEM