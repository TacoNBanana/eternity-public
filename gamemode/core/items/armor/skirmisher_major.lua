ITEM = class.Create("base_armor")

ITEM.Name 				= "T'vaoan Major"
ITEM.Description 		= "Armor belonging to a T'vaoan Major."

ITEM.Species 			= SPECIES_SKIRMISHER

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Body Options"] = 1
				},
				PlayerColor = Color(105, 13, 13):ToVector()
			}
		}
	end
end

return ITEM