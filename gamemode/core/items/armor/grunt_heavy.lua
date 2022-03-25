ITEM = class.Create("base_armor")

ITEM.Name 				= "Unggoy Heavy"
ITEM.Description 		= "Armor belonging to a heavy support Unggoy."

ITEM.Species 			= SPECIES_GRUNT

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 3,
				Bodygroups = {
					Backpack = 2,
					BackPack = 2, -- Honor guard model
					Helmet = 1
				}
			}
		}
	end
end

return ITEM