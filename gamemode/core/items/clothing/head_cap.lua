ITEM = class.Create("base_clothing")

ITEM.Name 			= "Baseball Cap"
ITEM.Description 	= "A UNSC branded baseball cap."

ITEM.Model 			= Model("models/props_junk/cardboard_box004a.mdl")

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Off-Duty"}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = 1
				}
			}
		}
	end
end

return ITEM