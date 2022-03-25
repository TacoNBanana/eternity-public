ITEM = class.Create("base_clothing")

ITEM.Name 			= "Series 8 SOLA Pack"
ITEM.Description 	= "A portable jump-jet designed for use by ODST Air Assault units."

ITEM.Model 			= Model("models/valk/h3/unsc/props/dumpster/garbagecan.mdl")

ITEM.Width 			= 3
ITEM.Height 		= 4

ITEM.EquipmentSlots = {EQUIPMENT_BACK}
ITEM.ModelGroups 	= {"Marine", "ODST", "Insurrection"}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Backpacks = 4
				}
			}
		}
	end
end

return ITEM