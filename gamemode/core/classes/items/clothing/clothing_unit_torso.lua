ITEM = class.Create("base_item")

ITEM.Name 				= "Metropolice vest"
ITEM.Description 		= "Official issue Civil Protection shirt and kevlar vest."

ITEM.Model 				= Model("models/tnb/items/shirt_metrocop.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.ItemGroup 			= "Clothing"

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.HandsModel 		= Model("models/weapons/c_arms_combine.mdl")

ITEM.PlayerModel 		= "models/tnb/halflife2/%s_torso_metrocop.mdl"
ITEM.PlayerSkin 		= 0

if SERVER then
	function ITEM:GetModelData(ply)
		local mdl = self.PlayerModel

		if string.find(mdl, "%s", 1, true) then
			mdl = string.format(mdl, GAMEMODE:GetGenderString(ply:CharModel()))
		end

		return {
			_base = {
				Bodygroups = {
					hands = 0
				}
			},
			torso = {
				Model = mdl,
				Skin = self.PlayerSkin
			}
		}
	end
end

return ITEM