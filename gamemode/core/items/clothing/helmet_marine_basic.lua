ITEM = class.Create("base_clothing")

ITEM.Name 			= "CH252 Basic Helmet"
ITEM.Description 	= "A UNSC standard issue combat helmet. Comes packaged with a balaclava and a set of ballistic goggles."

ITEM.OutlineColor 	= Color(127, 255, 159)

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}

ITEM.License 		= LICENSE_QM

ITEM.ModelGroups 	= {"Marine"}

ITEM.HelmetGroup 	= 3
ITEM.Balaclava 		= false
ITEM.Visor 			= false

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Toggle visor",
		Callback = function()
			self.Visor = not self.Visor

			ply:HandlePlayerModel()
		end
	})

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
					Helmet_Visor = self.Visor and 1 or 0
				}
			}
		}
	end
end

return ITEM