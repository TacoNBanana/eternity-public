ITEM = class.Create("base_item")

ITEM.Name 				= "Balaclava (Overwatch goggles)"
ITEM.Description 		= "A balaclava with some liberated Overwatch goggles."

ITEM.Model 				= Model("models/tnb/items/beaniewrap.mdl")
ITEM.Skin 				= 1

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.ItemGroup 			= "Clothing"

ITEM.Obscuring 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				HideHead = true
			},
			head = {
				Model = Model(string.format("models/tnb/halflife2/%s_head_balaclava_cota.mdl", GAMEMODE:GetGenderString(ply:CharModel())))
			}
		}
	end
end

return ITEM