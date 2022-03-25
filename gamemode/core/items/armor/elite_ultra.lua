ITEM = class.Create("base_armor")

ITEM.Name 				= "Sangheili Ultra"
ITEM.Description 		= "Armor belonging to a Sangheili Ultra."

ITEM.Species 			= SPECIES_ELITE

local model = Model("models/halo_reach/players/elite_ultra.mdl")

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = model,
				Skin = 0,
				PlayerColor = Color(239, 239, 239):ToVector()
			}
		}
	end
end

return ITEM