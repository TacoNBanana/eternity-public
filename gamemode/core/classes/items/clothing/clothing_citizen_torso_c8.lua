ITEM = class.Create("base_item")

ITEM.Name 				= "City 8 Citizen Jacket"
ITEM.Description 		= "Black shirt with matching workers jacket."

ITEM.Model 				= Model("models/tnb/items/shirt_citizen2.mdl")
ITEM.Skin 				= 1

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 1500
ITEM.SellPrice 			= 400

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_citizen2.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 3
			}
		}
	end
end

return ITEM