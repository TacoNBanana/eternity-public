ITEM = class.Create("base_item")

ITEM.Name 				= "Rebel Vest (grey)"
ITEM.Description 		= "Kevlar vest worn over citizen shirt, with Lambda sprayed on for idenfitication."

ITEM.Model 				= Model("models/tnb/items/shirt_rebel1.mdl")
ITEM.Skin 				= 1

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.ArmorLevel 		= ARMOR_HEAVY

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 2200
ITEM.SellPrice 			= 300

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			torso = {
				Model = Model(string.format("models/tnb/halflife2/%s_torso_rebel1.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 1
			}
		}
	end
end

return ITEM