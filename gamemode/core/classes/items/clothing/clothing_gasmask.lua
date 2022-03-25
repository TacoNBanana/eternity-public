ITEM = class.Create("base_item")

ITEM.Name 				= "Gasmask"
ITEM.Description 		= "How does this thing still hold a seal after all these years?"

ITEM.Model 				= Model("models/tnb/items/gasmask.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.ItemGroup 			= "Clothing"

ITEM.Obscuring 			= true
ITEM.Filtered 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					headgear = 8
				}
			}
		}
	end
end

return ITEM