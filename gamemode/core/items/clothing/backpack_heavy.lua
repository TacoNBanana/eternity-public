ITEM = class.Create("base_clothing")

ITEM.Name 			= "Backpack (Heavy)"
ITEM.Description 	= "A sizeable backpack with room for several days worth of supplies."

ITEM.Model 			= Model("models/valk/h4/unsc/props/sandbags/sandbags_single.mdl")

ITEM.Width 			= 3
ITEM.Height 		= 4

ITEM.EquipmentSlots = {EQUIPMENT_BACK}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Off-Duty", "Marine", "ODST", "Insurrection"}

ITEM.Inventories 		= {
	["Main"] = {3, 4}
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Backpacks = 2
				}
			}
		}
	end
end

return ITEM