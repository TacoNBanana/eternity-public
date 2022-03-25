ITEM = class.Create("base_item")

ITEM.Name 				= "Vortigaunt shackles"
ITEM.Description 		= "A set of binding shackles that severely limits a Vortigaunt's abilities on top of allowing the combine to track them."

ITEM.Model 				= Model("models/props_wasteland/prison_padlock001a.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.OutlineColor 		= Color(65, 204, 118)

ITEM.EquipmentSlots 	= {EQUIPMENT_VORTS}

ITEM.ItemGroup 			= "Vortigaunt"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/vortigaunt_slave.mdl")
			}
		}
	end
end

return ITEM