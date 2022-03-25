ITEM = class.Create("base_item")

ITEM.Name 				= "Scientist Overalls"
ITEM.Description 		= "Prominently features the combine insignia and a CWU logo on the front."

ITEM.Model 				= Model("models/tnb/items/shirt_citizen2.mdl")
ITEM.Skin 				= 1

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 3000
ITEM.SellPrice 			= 200

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_scientist.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 0
			}
		}
	end
end

return ITEM