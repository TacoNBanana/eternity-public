ITEM = class.Create("base_armor")

ITEM.Name 				= "Unggoy Major"
ITEM.Description 		= "Armor belonging to an Unggoy Major."

ITEM.Species 			= SPECIES_GRUNT

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 2,
				Bodygroups = {
					Backpack = 1,
					BackPack = 1 -- Honor guard model
				}
			}
		}
	end
end

return ITEM