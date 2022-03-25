ITEM = class.Create("base_item")

ITEM.Name 				= "Gloves"
ITEM.Description 		= "A pair of gloves to keep your hands warm."

ITEM.Model 				= Model("models/tnb/items/gloves.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_GLOVES}

ITEM.ItemGroup 			= "Clothing"

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 150
ITEM.SellPrice 			= 60

ITEM.Gloves 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					hands = 2
				}
			}
		}
	end
end

return ITEM