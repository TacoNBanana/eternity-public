ITEM = class.Create("base_clothing")

ITEM.Name 				= "Marine Armor"
ITEM.Description 		= "A customizable set of UNSC combat gear."

ITEM.OutlineColor 		= Color(127, 255, 159)

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}

ITEM.License 			= LICENSE_QM

ITEM.ModelGroups 		= {"Marine"}

ITEM.Locked 			= false

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = self.Locked and "Unlock" or "Lock",
		Callback = function()
			self.Locked = not self.Locked
		end
	})

	if not self.Locked then
		table.insert(tab, {
			Name = "Set collar style",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set collar style", {
					Default = self.Collar or 0
				})
			end,
			Callback = function(val)
				self.Collar = math.Clamp(math.Round(val), 0, 2)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set shoulderpads",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set shoulderpads", {
					Default = self.Shoulderpads or 0,
				})
			end,
			Callback = function(val)
				self.Shoulderpads = math.Clamp(math.Round(val), 0, 5)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set chest packs",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set chest packs", {
					Default = self.ChestPacks or 0
				})
			end,
			Callback = function(val)
				self.ChestPacks = math.Clamp(math.Round(val), 0, 5)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set thighpads",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set thighpads", {
					Default = self.Thighpads or 0
				})
			end,
			Callback = function(val)
				self.Thighpads = math.Clamp(math.Round(val), 0, 2)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set legs",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set legs", {
					Default = self.Legs or 0
				})
			end,
			Callback = function(val)
				self.Legs = math.Clamp(math.Round(val), 0, 3)

				ply:HandlePlayerModel()
			end
		})
	end

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
					Collar = self.Collar or 0,
					Shoulderpads = self.Shoulderpads or 0,
					Chest_Packs = self.ChestPacks or 0,
					Thighpads = self.Thighpads or 0,
					Legs = self.Legs or 0
				}
			}
		}
	end
end

return ITEM