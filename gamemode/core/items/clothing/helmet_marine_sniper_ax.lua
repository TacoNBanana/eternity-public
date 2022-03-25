ITEM = class.Create("helmet_marine_basic_ax")

ITEM.Name 			= "ECH252 Sharpshooter Helmet"
ITEM.Description 	= [[A variation of the standard CH252 combat helmet that can be fully enclosed and enviromentally sealed. Comes packaged with a balaclava.

Sharpshooter version: Equipped with an O/I optics device.]]

ITEM.OutlineColor 	= Color(255, 223, 127)

ITEM.HelmetGroup 	= 3

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self.HelmetGroup,
					Face = self.Balaclava and 1 or 0,
					Helmet_Visor = self.Visor and 5 or 3,
					Helmet_Attatchment = 1 -- Don't fix the spelling error
				}
			}
		}
	end
end

return ITEM