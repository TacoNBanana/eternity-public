ITEM = class.Create("base_armor")

ITEM.Name 				= "Unggoy Ultra"
ITEM.Description 		= "Armor belonging to an Unggoy Ultra."

ITEM.Species 			= SPECIES_GRUNT

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 0,
				Bodygroups = {
					Backpack = 2,
					BackPack = 2, -- Honor guard model
					Helmet = 2
				},
				PlayerColor = Vector(1, 1, 1)
			}
		}
	end
end

return ITEM