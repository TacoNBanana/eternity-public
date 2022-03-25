ITEM = class.Create("base_item")

ITEM.Name 				= "Beanie"
ITEM.Description 		= "A generic beanie, nothing to it really."

ITEM.Model 				= Model("models/tnb/items/beanie.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 120
ITEM.SellPrice 			= 60

ITEM.ItemGroup 			= "Clothing"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					headgear = 7
				}
			}
		}
	end
end

return ITEM