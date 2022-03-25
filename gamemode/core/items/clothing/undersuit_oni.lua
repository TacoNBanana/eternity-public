ITEM = class.Create("base_undersuit")

ITEM.Name 				= "Off-Duty Uniform (ONI)"
ITEM.Description 		= "An off-duty uniform belonging to the Office of Naval Intelligence."

ITEM.Color 				= Color(145, 145, 145)
ITEM.OutlineColor 		= Color(72, 72, 72)

ITEM.ModelPattern 		= "models/ishi/halo_rebirth/player/offduty/%s/offduty_%s.mdl"
ITEM.ModelGroup 		= "Off-Duty"

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = self:GetModel(ply),
				Skin = self.ModelSkin,
				Bodygroups = {
					Torso = 1,
					Legs = 1
				}
			}
		}
	end
end

return ITEM