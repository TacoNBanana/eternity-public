ITEM = class.Create("base_item")

ITEM.Name 				= "Metropolice pants"
ITEM.Description 		= "Not to be confused with your standard issue pants."

ITEM.Model 				= Model("models/tnb/items/pants_metrocop.mdl")

ITEM.Width 				= 1
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_LEGS}

ITEM.ItemGroup 			= "Clothing"

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.PlayerModel 		= "models/tnb/halflife2/%s_legs_metrocop.mdl"
ITEM.PlayerSkin 		= 0

if SERVER then
	function ITEM:GetModelData(ply)
		local mdl = self.PlayerModel

		if string.find(mdl, "%s", 1, true) then
			mdl = string.format(mdl, GAMEMODE:GetGenderString(ply:CharModel()))
		end

		return {
			legs = {
				Model = mdl,
				Skin = self.PlayerSkin
			}
		}
	end
end

return ITEM