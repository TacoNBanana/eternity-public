ITEM = class.Create("base_armor")

ITEM.Name 				= "Jiralhanae Captain"
ITEM.Description 		= "Armor belonging to a Jiralhanae Captain."

ITEM.Species 			= SPECIES_BRUTE

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Skin = 2,
				Bodygroups = {
					Helmet = 2,
					Torso = 2,
					Shoulder_Right = 2,
					Shoulder_Left = 2,
					Forearms = 1,
					Thighs = 1,
					Calves = 1,
					Undersuit = 1
				}
			}
		}
	end
end

return ITEM