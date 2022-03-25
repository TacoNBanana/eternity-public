ITEM = class.Create("base_item")

ITEM.Name 				= "City 8 Citizen Pants"
ITEM.Description 		= "Features a yellow vertical stripe down each side."

ITEM.Model 				= Model("models/tnb/items/pants_citizen.mdl")
ITEM.Skin 				= 3

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 1000
ITEM.SellPrice 			= 300

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			legs = {
				Model = Model(string.format("models/tnb/halflife2/%s_legs_citizen.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 3
			}
		}
	end
end

return ITEM