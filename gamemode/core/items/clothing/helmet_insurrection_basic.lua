ITEM = class.Create("base_clothing")

ITEM.Name 			= "CH252 Basic URF Helmet"
ITEM.Description 	= "A UNSC standard issue combat helmet that has been modified by the URF. Comes packaged with a Balaclava."

ITEM.Color 			= Color(145, 145, 145)
ITEM.OutlineColor 	= Color(255, 0, 0)

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}
ITEM.ModelGroups 	= {"Insurrection"}

ITEM.HelmetGroup 	= 3
ITEM.Balaclava 		= false

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Toggle balaclava",
		Callback = function()
			self.Balaclava = not self.Balaclava

			ply:HandlePlayerModel()
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self.HelmetGroup,
					Face = self.Balaclava and 1 or 0,
				}
			}
		}
	end
end

return ITEM