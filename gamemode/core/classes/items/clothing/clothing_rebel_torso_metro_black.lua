ITEM = class.Create("base_item")

ITEM.Name 				= "Black Shirt with Spraypainted Metrovest"
ITEM.Description 		= "Kevlar vest worn over citizen shirt, with Lambda sprayed on for idenfitication."

ITEM.Model 				= Model("models/tnb/items/shirt_rebelmetrocop.mdl")
ITEM.Skin 				= 3

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.License 			= LICENSE_GREY
ITEM.UnitPrice 			= 700
ITEM.SellPrice 			= 300

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_rebel_metro1.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 3
			}
		}
	end
end

return ITEM