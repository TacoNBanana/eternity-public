ITEM = class.Create("base_item")

ITEM.Name 				= "Fingerless Gloves"
ITEM.Description 		= "While not as warm as a full set of gloves, they do look stylish."

ITEM.Model 				= Model("models/tnb/items/gloves.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_GLOVES}

ITEM.ItemGroup 			= "Clothing"

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 120
ITEM.SellPrice 			= 60

ITEM.Gloves 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					hands = 3
				}
			}
		}
	end
end

return ITEM