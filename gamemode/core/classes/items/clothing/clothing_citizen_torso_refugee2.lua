ITEM = class.Create("base_item")

ITEM.Name 				= "Refugee Shirt (alternate)"
ITEM.Description 		= "Camo for females, Green for males."

ITEM.Model 				= Model("models/tnb/items/shirt_citizen2.mdl")
ITEM.Skin 				= 1

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 600
ITEM.SellPrice 			= 200

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_citizen2.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 1
			}
		}
	end
end

return ITEM