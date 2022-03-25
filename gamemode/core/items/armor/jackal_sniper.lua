ITEM = class.Create("base_armor")

ITEM.Name 				= "Kig-Yar Sniper"
ITEM.Description 		= "Armor belonging to a Kig-Yar Sniper."

ITEM.Species 			= SPECIES_JACKAL

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Helmet = 1
				}
			}
		}
	end
end

return ITEM