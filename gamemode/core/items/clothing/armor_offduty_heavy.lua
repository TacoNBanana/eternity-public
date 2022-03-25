ITEM = class.Create("base_clothing")

ITEM.Name 			= "Armor Vest (Heavy)"
ITEM.Description 	= "A set of armor and other protective gear to be worn over plain clothes."

ITEM.OutlineColor 	= Color(255, 223, 127)

ITEM.Width 			= 2
ITEM.Height 		= 2

ITEM.ArmorLevel 	= ARMOR_LIGHT

ITEM.EquipmentSlots = {EQUIPMENT_TORSO}
ITEM.ModelGroups 	= {"Off-Duty"}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					Combat_Vest = 1,
					Shoulder_Pads = 3,
					Legs = 2
				}
			}
		}
	end
end

return ITEM