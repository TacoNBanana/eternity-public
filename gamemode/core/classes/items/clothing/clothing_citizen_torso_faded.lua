ITEM = class.Create("base_item")

ITEM.Name 				= "Citizen uniform (faded)"
ITEM.Description 		= "Previously blue citizen jumpsuit that has faded with years of wear."

ITEM.Model 				= Model("models/tnb/items/shirt_citizen2.mdl")
ITEM.Skin 				= 1

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 800
ITEM.SellPrice 			= 300

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_citizen2.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 2
			}
		}
	end
end

return ITEM