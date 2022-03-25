ITEM = class.Create("base_item")

ITEM.Name 				= "Facewrap"
ITEM.Description 		= "It's just a piece of cloth really."

ITEM.Model 				= Model("models/tnb/items/facewrap.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_HEAD}

ITEM.ItemGroup 			= "Clothing"

ITEM.License 			= LICENSE_CLOTHING
ITEM.UnitPrice 			= 120
ITEM.SellPrice 			= 60

ITEM.Obscuring 			= true

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					headgear = 6
				}
			}
		}
	end
end

return ITEM