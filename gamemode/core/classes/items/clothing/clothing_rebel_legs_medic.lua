ITEM = class.Create("base_item")

ITEM.Name 				= "Rebel Medic Pants (Dirty)"
ITEM.Description 		= "Stripped down pants worn by resistance scouts and medics."

ITEM.Model 				= Model("models/tnb/items/pants_rebel.mdl")
ITEM.Skin 				= 0

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}

ITEM.License 			= LICENSE_BLACK
ITEM.UnitPrice 			= 800
ITEM.SellPrice 			= 300

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			legs = {
				Model = Model(string.format("models/tnb/halflife2/%s_legs_medic.mdl", GAMEMODE:GetGenderString(ply:CharModel()))),
				Skin = 0
			}
		}
	end
end

return ITEM