ITEM = class.Create("base_clothing")

ITEM.Name 			= "ECH252 Basic Helmet"
ITEM.Description 	= "A variation of the standard CH252 combat helmet that can be fully enclosed and enviromentally sealed. Comes packaged with a balaclava."

ITEM.OutlineColor 	= Color(127, 255, 159)

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}
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
			self.Filtered = self.Visor

			ply:HandlePlayerModel()
			ply:HandleMisc()
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
					Helmet_Visor = self.Visor and 5 or 3
				}
			}
		}
	end
end

return ITEM