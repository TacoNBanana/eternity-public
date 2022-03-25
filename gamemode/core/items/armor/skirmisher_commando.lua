ITEM = class.Create("base_armor")

ITEM.Name 				= "T'vaoan Commando"
ITEM.Description 		= "Armor belonging to a T'vaoan Commando."

ITEM.Species 			= SPECIES_SKIRMISHER

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Body Options"] = 3
				},
				PlayerColor = Color(49, 97, 3):ToVector()
			}
		}
	end
end

return ITEM