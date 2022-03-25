ITEM = class.Create("base_armor")

ITEM.Name 				= "T'vaoan Champion"
ITEM.Description 		= "Armor belonging to a T'vaoan Champion."

ITEM.Species 			= SPECIES_SKIRMISHER

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Body Options"] = 4
				},
				PlayerColor = Color(225, 139, 0):ToVector()
			}
		}
	end
end

return ITEM