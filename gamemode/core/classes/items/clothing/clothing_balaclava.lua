ITEM = class.Create("base_item")

ITEM.Name 				= "Balaclava (Ski goggles)"
ITEM.Description 		= "A balaclava with accompanying ski goggles."

ITEM.Model 				= Model("models/tnb/items/beaniewrap.mdl")
ITEM.Skin 				= 1

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.ItemGroup 			= "Clothing"

ITEM.License 			= LICENSE_GREY
ITEM.UnitPrice 			= 600
ITEM.SellPrice 			= 200

ITEM.Obscuring 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				HideHead = true
			},
			head = {
				Model = Model(string.format("models/tnb/halflife2/%s_head_balaclava.mdl", GAMEMODE:GetGenderString(ply:CharModel())))
			}
		}
	end
end

return ITEM