ITEM = class.Create("base_clothing")

ITEM.Name 			= "Radio Pack"
ITEM.Description 	= "A portable long range radio."

ITEM.Model 			= Model("models/ishi/halo_rebirth/props/human/mil_radio.mdl")

ITEM.Width 			= 2
ITEM.Height 		= 3

ITEM.EquipmentSlots = {EQUIPMENT_BACK}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Marine", "ODST", "Insurrection"}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Backpacks = 3
				}
			}
		}
	end
end

return ITEM