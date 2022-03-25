ITEM = class.Create("base_armor")

ITEM.Name 				= "Jiralhanae Chieftain"
ITEM.Description 		= "Armor belonging to a Jiralhanae Chieftain."

ITEM.Species 			= SPECIES_BRUTE

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 1,
				Bodygroups = {
					Helmet = 4,
					Torso = 3,
					Shoulder_Right = 3,
					Shoulder_Left = 3,
					Forearms = 2,
					Thighs = 3,
					Calves = 1,
					Undersuit = 2,
					Beard = 1
				}
			}
		}
	end
end

return ITEM