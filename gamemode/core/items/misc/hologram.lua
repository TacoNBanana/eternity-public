ITEM = class.Create("base_item")

ITEM.Name 				= "Hologram shader"
ITEM.Description 		= "...what?"

ITEM.OutlineColor 		= Color(0, 191, 255)

ITEM.Model 				= Model("models/gibs/shield_scanner_gib1.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_MISC}

ITEM.Team 				= TEAM_AI

function ITEM:GetContextOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Set scale",
		Client = function()
			return GAMEMODE:OpenGUI("Input", "number", "Set scale", {
				Default = self.PlayerScale or 1
			})
		end,
		Callback = function(val)
			self.PlayerScale = math.Clamp(math.Round(val, 2), 0.1, 1)

			ply:HandlePlayerModel()
		end
	})

	return tab
end

if SERVER then
	function ITEM:PostModelData(ply, data)
		data._base.Scale 	= self.PlayerScale
		data._base.Material = "models/effects/hologram"

		return data
	end
end

return ITEM