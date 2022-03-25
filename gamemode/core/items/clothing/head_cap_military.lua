ITEM = class.Create("base_clothing")

ITEM.Name 			= "Patrol Cap"
ITEM.Description 	= "A standard UNSC Patrol cap."

ITEM.Model 			= Model("models/props_junk/cardboard_box004a.mdl")

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Off-Duty", "Marine", "ODST", "Insurrection"}

if SERVER then
	local indices = {
		["Off-Duty"] = 4,
		["Marine"] = 2,
		["ODST"] = 1,
		["Insurrection"] = 2
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