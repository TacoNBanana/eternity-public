ITEM = class.Create("base_clothing")

ITEM.Name 				= "ODST Armor"
ITEM.Description 		= "A customizable set of ODST combat gear."

ITEM.Color 				= Color(145, 145, 145)
ITEM.OutlineColor 		= Color(109, 109, 109)

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.EquipmentSlots 	= {EQUIPMENT_TORSO}
ITEM.ModelGroups 		= {"ODST"}

ITEM.Locked 			= false
ITEM.Cuffs 				= false

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
			Name = "Toggle cuffs",
			Callback = function()
				self.Cuffs = not self.Cuffs

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
				self.ChestPacks = math.Clamp(math.Round(val), 0, 4)

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
				self.Legs = math.Clamp(math.Round(val), 0, 2)

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
					Cuffs = self.Cuffs and 1 or 0,
					Collar = 2,
					Chestplate = 1,
					Shoulderpads = 5,
					Chest_Packs = self.ChestPacks or 0,
					Thighpads = self.Thighpads or 0,
					Legs = self.Legs or 0
				}
			}
		}
	end
end

return ITEM