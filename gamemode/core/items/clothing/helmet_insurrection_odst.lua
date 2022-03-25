ITEM = class.Create("base_clothing")

ITEM.Name 			= "URF ODST Helmet"
ITEM.Description 	= "An ODST helmet that's been modified by the URF. Comes packaged with a balaclava."

ITEM.Color 			= Color(145, 145, 145)
ITEM.OutlineColor 	= Color(255, 0, 0)

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}
ITEM.ModelGroups 	= {"Insurrection"}

ITEM.HelmetGroup 	= 4

ITEM.Filtered 		= true

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
		local tab = {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self.HelmetGroup,
					Face = self.Balaclava and 1 or 0
				}
			}
		}

		if self.Visor then
			tab._base.Materials = {
				["models/ishis_garage/halo_rebirth/marines/innie/odst_helmets_visor"] = "models/props_combine/citadel_cable_b"
			}
		end

		return tab
	end
end

return ITEM