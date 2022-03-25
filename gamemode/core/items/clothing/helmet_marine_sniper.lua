ITEM = class.Create("helmet_marine_basic")

ITEM.Name 			= "CH252 Sharpshooter Helmet"
ITEM.Description 	= [[A UNSC standard issue combat helmet. Comes packaged with a balaclava and a set of ballistic goggles.

Sharpshooter version: Equipped with an O/I optics device.]]

ITEM.OutlineColor 	= Color(255, 223, 127)

ITEM.License 		= LICENSE_QM

ITEM.HelmetGroup 	= 3

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self.HelmetGroup,
					Face = self.Balaclava and 1 or 0,
					Helmet_Visor = self.Visor and 1 or 0,
					Helmet_Attatchment = 1 -- Don't fix the spelling error
				}
			}
		}
	end
end

return ITEM