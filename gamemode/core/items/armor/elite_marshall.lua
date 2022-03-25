ITEM = class.Create("base_armor")

ITEM.Name 				= "Sangheili Field Marshall"
ITEM.Description 		= "Armor belonging to a Sangheili Field Marshall."

ITEM.Species 			= SPECIES_ELITE

local model = Model("models/halo_reach/players/elite_field_marshall.mdl")

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = model,
				Skin = 0,
				PlayerColor = Color(100, 50, 50):ToVector()
			}
		}
	end
end

return ITEM