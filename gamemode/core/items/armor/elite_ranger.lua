ITEM = class.Create("base_armor")

ITEM.Name 				= "Sangheili Ranger"
ITEM.Description 		= "Armor belonging to a Sangheili Ranger."

ITEM.Species 			= SPECIES_ELITE

local model = Model("models/halo_reach/players/elite_ranger.mdl")

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = model,
				Skin = 0,
				PlayerColor = Color(189, 227, 213):ToVector()
			}
		}
	end
end

return ITEM