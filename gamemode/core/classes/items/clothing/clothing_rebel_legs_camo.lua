ITEM = class.Create("base_item")

ITEM.Name 				= "Rebel Pants (Digital Camo)"
ITEM.Description 		= "Padded pants worn by resistance fighters."

ITEM.Model 				= Model("models/tnb/items/pants_rebel.mdl")
ITEM.Skin 				= 3

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 1600
ITEM.SellPrice 			= 300

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			legs = {
				Model = Model(string.format("models/tnb/halflife2/%s_legs_rebel1.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 3
			}
		}
	end
end

return ITEM