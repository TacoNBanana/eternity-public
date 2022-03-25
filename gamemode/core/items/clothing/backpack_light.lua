ITEM = class.Create("base_clothing")

ITEM.Name 			= "Backpack (Light)"
ITEM.Description 	= "A light assault pack for carrying combat gear."

ITEM.Model 			= Model("models/valk/h4/unsc/props/sandbags/sandbags_single.mdl")

ITEM.Width 			= 2
ITEM.Height 		= 3

ITEM.EquipmentSlots = {EQUIPMENT_BACK}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Off-Duty", "Marine", "ODST", "Insurrection"}

ITEM.Inventories 		= {
	["Main"] = {2, 3}
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Backpacks = 1
				}
			}
		}
	end
end

return ITEM