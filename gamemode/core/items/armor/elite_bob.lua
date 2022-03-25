ITEM = class.Create("base_armor")

ITEM.Name 				= "BOB"
ITEM.Description 		= "Armor belonging to a Sangheili Ranger. Wipe them out..."

ITEM.Species 			= SPECIES_ELITE

local model = Model("models/halo_reach/players/elite_ranger.mdl")

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = model,
				Skin = 0,
				PlayerColor = Color(245, 146, 0):ToVector()
			}
		}
	end
end

return ITEM