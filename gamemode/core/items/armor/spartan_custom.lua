ITEM = class.Create("base_armor")

ITEM.Name 				= "Mjolnir Mark V[B]"
ITEM.Description 		= "A set of heavily customizable MJOLNIR Powered Assault Armor."

ITEM.Model 				= Model("models/ishi/halo_rebirth/props/human/oni_crate_small.mdl")

ITEM.OutlineColor 		= Color(33, 106, 196)

ITEM.Species 			= SPECIES_SPARTAN

ITEM.Locked 			= false
ITEM.Belt 				= false
ITEM.Arm 				= false

local fields = {
	"ArmorColor",
	"Visor",
	"HelmetAttachment",
	"Chestplate",
	"Belt",
	"ShoulderLeft",
	"ShoulderRight",
	"Wrist",
	"Utility",
	"Knees",
	"Arm"
}

local colors = {
	{"Steel", "74 74 74"},
	{"Silver", "136 136 136"},
	{"White", "207 207 207"},

	{"Brown", "90 63 45"},
	{"Tan", "138 101 79"},
	{"Khaki", "192 150 127"},

	{"Sage", "91 100 63"},
	{"Olive", "130 146 85"},
	{"Drab", "166 188 118"},

	{"Forest", "31 96 43"},
	{"Green", "62 153 87"},
	{"Sea Foam", "113 192 122"},

	{"Teal", "24 112 109"},
	{"Aqua", "48 159 157"},
	{"Cyan", "102 211 207"},

	{"Blue", "36 68 105"},
	{"Cobalt", "74 103 145"},
	{"Ice", "119 157 208"},

	{"Violet", "67 66 117"},
	{"Orchid", "100 97 165"},
	{"Lavender", "146 143 213"},

	{"Maroon", "138 39 38"},
	{"Brick", "198 43 43"},
	{"Rose", "225 124 124"},

	{"Rust", "152 56 19"},
	{"Coral", "217 94 37"},
	{"Peach", "215 145 106"},

	{"Gold", "141 95 19"},
	{"Yellow", "190 161 45"},
	{"Pale", "209 203 87"}
}

function ITEM:GetOptions(ply)
	local tab = {}

	if ply:IsAdmin() then
		table.insert(tab, {
			Name = self.Locked and "Unlock" or "Lock",
			Callback = function()
				self.Locked = not self.Locked
			end
		})

		table.insert(tab, {
			Name = "Duplicate",
			Callback = function()
				local item = GAMEMODE:CreateItem("spartan_custom")

				for _, v in pairs(fields) do
					item[v] = self[v]
				end

				item.Locked = true

				if not item:OnWorldUse(ply) then
					item:SetWorldItem(ply:GetItemDropLocation(), Angle())
				end
			end
		})
	end

	if not self.Locked then
		table.insert(tab, {
			Name = "Randomize",
			Callback = function()
				self.ArmorColor = Vector(table.Random(colors)[2]) / 255
				self.Visor = math.random(0, 4)
				self.HelmetAttachment = math.random(0, 2)
				self.Belt = math.random(0, 1) == 1
				self.Chestplate = math.random(0, 14)
				self.ShoulderLeft = math.random(0, 15)
				self.ShoulderRight = math.random(0, 15)
				self.Wrist = math.random(0, 5)
				self.Utility = math.random(0, 5)
				self.Knees = math.random(0, 3)
				self.Arm = math.random(0, 1) == 1

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set armor color",
			Client = function()
				local col = self.ArmorColor and self.ArmorColor:ToColor() or Color(72, 72, 72)
				local str = string.format("%s %s %s", math.Round(col.r, 2), math.Round(col.g, 2), math.Round(col.b, 2))

				return GAMEMODE:OpenGUI("Input", "string", "Set armor color", {
					Default = str
				})
			end,
			Callback = function(val)
				self.ArmorColor = Vector(val) / 255

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set preset color",
			Client = function(pnl)
				timer.Simple(0, function()
					local dmenu = EternityDermaMenu()

					for k, v in pairs(colors) do
						dmenu:AddOption(v[1], function()
							netstream.Send("RunItemFunction", {
								ID = self.NetworkID,
								Name = "Set armor color",
								Value = v[2]
							})
						end)

						if k != #colors and k % 3 == 0 then
							dmenu:AddSpacer()
						end
					end

					dmenu:Open()
				end)
			end
		})

		table.insert(tab, {
			Name = "Set visor color",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set visor color", {
					Default = self.Visor or 0
				})
			end,
			Callback = function(val)
				self.Visor = math.Clamp(math.Round(val), 0, 4)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set helmet variant",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set helmet variant", {
					Default = self.HelmetAttachment or 0,
				})
			end,
			Callback = function(val)
				self.HelmetAttachment = math.Clamp(math.Round(val), 0, 2)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set chestplate",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set chestplate", {
					Default = self.Chestplate or 0
				})
			end,
			Callback = function(val)
				self.Chestplate = math.Clamp(math.Round(val), 0, 14)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Toggle belt (Not available on every model)",
			Callback = function()
				self.Belt = not self.Belt

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set left shoulder",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set left shoulder", {
					Default = self.ShoulderLeft or 0
				})
			end,
			Callback = function(val)
				self.ShoulderLeft = math.Clamp(math.Round(val), 0, 15)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set right shoulder",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set right shoulder", {
					Default = self.ShoulderRight or 0
				})
			end,
			Callback = function(val)
				self.ShoulderRight = math.Clamp(math.Round(val), 0, 15)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set wrist accessory",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set wrist accessory", {
					Default = self.Wrist or 0
				})
			end,
			Callback = function(val)
				self.Wrist = math.Clamp(math.Round(val), 0, 5)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set utility",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set utility", {
					Default = self.Utility or 0
				})
			end,
			Callback = function(val)
				self.Utility = math.Clamp(math.Round(val), 0, 5)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Set knees",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Set knees", {
					Default = self.Knees or 0
				})
			end,
			Callback = function(val)
				self.Knees = math.Clamp(math.Round(val), 0, 3)

				ply:HandlePlayerModel()
			end
		})

		table.insert(tab, {
			Name = "Toggle robot arm",
			Callback = function()
				self.Arm = not self.Arm

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
				Skin = self.Visor,
				PlayerColor = self.ArmorColor,
				Bodygroups = {
					Helmet_Attachment = self.HelmetAttachment,
					Chestplate = self.Chestplate,
					Belt = self.Belt and 1 or 0,
					Shoulder_Left = self.ShoulderLeft,
					Shoulder_Right = self.ShoulderRight,
					Wrist = self.Wrist,
					Utility = self.Utility,
					Knees = self.Knees,
					Arm = self.Arm and 1 or 0
				}
			}
		}
	end
end

return ITEM