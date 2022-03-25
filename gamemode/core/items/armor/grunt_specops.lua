ITEM = class.Create("base_armor")

ITEM.Name 				= "Specops Unggoy"
ITEM.Description 		= "Armor belonging to a special operations Unggoy."

ITEM.Species 			= SPECIES_GRUNT

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 4,
				Bodygroups = {
					Backpack = 1,
					BackPack = 1, -- Honor guard model
					Helmet = 1
				}
			}
		}
	end
end

return ITEM