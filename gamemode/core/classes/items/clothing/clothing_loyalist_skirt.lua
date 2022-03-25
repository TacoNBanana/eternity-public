ITEM = class.Create("base_item")

ITEM.Name 				= "Loyalist Skirt"
ITEM.Description 		= "Worn by females only."

ITEM.Model 				= Model("models/tnb/items/pants_citizen.mdl")
ITEM.Skin 				= 0

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}


ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			legs = {
				Model = Model(string.format("models/tnb/halflife2/%s_legs_loyalist_skirt.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 0
			}
		}
	end
end

return ITEM