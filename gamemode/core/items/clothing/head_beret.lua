ITEM = class.Create("base_clothing")

ITEM.Name 			= "Beret"
ITEM.Description 	= "A plain beret."

ITEM.Model 			= Model("models/props_junk/cardboard_box004a.mdl")

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}
ITEM.ModelGroups 	= {"Off-Duty", "Marine", "Insurrection"}

if SERVER then
	local indices = {
		["Off-Duty"] = 3,
		["Marine"] = 1,
		["Insurrection"] = 1
	}

	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = indices[self:GetModelGroup(ply)]
				}
			}
		}
	end
end

return ITEM