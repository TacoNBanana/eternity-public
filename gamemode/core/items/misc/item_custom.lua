ITEM = class.Create("base_item")

ITEM.Name 				= "Custom item"
ITEM.Description 		= "Infinite possibilities in the palm of your hand."

ITEM.OutlineColor 		= Color(127, 0, 255)

ITEM.Model 				= Model("models/maxofs2d/hover_rings.mdl")

ITEM.ItemGroup 			= "Custom"

ITEM.Locked 			= false

local saveFields = {
	Name = true,
	Description = true,
	Model = true,
	Skin = true,
	Bodygroups = true,
	Width = true,
	Height = true,
	OutlineColor = true,
	Scale = true,
	Color = true,
	Material = true
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
				local item = GAMEMODE:CreateItem("item_custom")

				for k in pairs(saveFields) do
					item[k] = self[k]
				end

				item.Locked = true

				if not item:OnWorldUse(ply) then
					item:SetWorldItem(ply:GetItemDropLocation(), Angle())
				end
			end
		})

		if not self.Locked then
			table.insert(tab, {
				Name = "Import",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Import string", {})
				end,
				Callback = function(val)
					local ok, decoded = pcall(base64.Decode, val)

					if not ok then
						ply:SendChat("ERROR", "Decode failed!")

						return
					end

					local checksum, payload = string.match(decoded, "^(%d+)(.*)")

					if util.CRC(payload) != checksum then
						ply:SendChat("ERROR", "Invalid checksum!")

						return
					end

					local data = pon.decode(payload)
					local w, h = 1, 1

					for k in pairs(saveFields) do
						local v = data[k]

						if not v then
							continue
						end

						if k == "Width" then
							w = v
						elseif k == "Height" then
							h = v
						else
							self[k] = v
						end
					end

					self:SetSize(w, h)
				end
			})

			table.insert(tab, {
				Name = "Export",
				Client = function()
					local data = {}

					for k in pairs(saveFields) do
						data[k] = self[k]
					end

					local payload = pon.encode(data)
					local checksum = util.CRC(payload)

					SetClipboardText(base64.Encode(checksum .. payload))

					GAMEMODE:SendChat("NOTICE", "Data copied to clipboard.")
				end
			})

			table.insert(tab, {
				Name = "Set item color",
				Client = function()
					local col = self.OutlineColor
					local str = string.format("%s %s %s", math.Round(col.r, 2), math.Round(col.g, 2), math.Round(col.b, 2))

					return GAMEMODE:OpenGUI("Input", "string", "Set item color", {
						Default = str
					})
				end,
				Callback = function(val)
					val = (Vector(val) / 255):ToColor()

					self.OutlineColor = val
				end
			})

			table.insert(tab, {
				Name = "Set name",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Set name", {
						Default = self.Name,
						Max = 32
					})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("string", {
						Max = 32
					}, val) then
						return
					end

					self.Name = val
				end
			})

			table.insert(tab, {
				Name = "Set description",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Set description", {
						Default = self.Description,
						Max = 512,
						Multiline = true
					})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("string", {
						Max = 512
					}, val) then
						return
					end

					self.Description = val
				end
			})

			table.insert(tab, {
				Name = "Set model",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Set model", {
						Default = self.Model
					})
				end,
				Callback = function(val)
					if not util.IsValidModel(Model(val)) then
						ply:SendChat("ERROR", "This isn't a valid model!")

						return
					end

					self.Model = val
					self.Skin = 0
				end
			})

			table.insert(tab, {
				Name = "Set skin",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "number", "Set skin", {
						Default = self.Skin
					})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("number", {}, val) then
						return
					end

					val = math.max(0, val)

					self.Skin = val
				end
			})

			table.insert(tab, {
				Name = "Set entity scale",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "number", "Set entity scale", {
						Default = self.Scale
					})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("number", {}, val) then
						return
					end

					val = math.Clamp(val, 0.1, 10)

					self.Scale = val
				end
			})

			table.insert(tab, {
				Name = "Set entity color",
				Client = function()
					local col = self.Color
					local str = string.format("%s %s %s", math.Round(col.r, 2), math.Round(col.g, 2), math.Round(col.b, 2))

					return GAMEMODE:OpenGUI("Input", "string", "Set entity color", {
						Default = str
					})
				end,
				Callback = function(val)
					val = (Vector(val) / 255):ToColor()

					self.Color = val
				end
			})

			table.insert(tab, {
				Name = "Set material",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Set material", {
						Default = self.Material
					})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("string", {}, val) then
						return
					end

					if Material(val):IsError() then
						return
					end

					self.Material = val
				end
			})

			table.insert(tab, {
				Name = "Set bodygroups",
				Client = function()
					return GAMEMODE:OpenGUI("Input", "number", "Set Bodygroups", {})
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("number", {}, val) then
						return
					end

					for k, v in pairs(string.Explode("", val)) do
						if not tonumber(v) then
							continue
						end

						self.Bodygroups[k] = v
					end

					self.Bodygroups = self.Bodygroups
				end
			})

			table.insert(tab, {
				Name = "Set item size",
				Client = function()
					local w = GAMEMODE:OpenGUI("Input", "number", "Set width", {})
					local h = GAMEMODE:OpenGUI("Input", "number", "Set height", {})

					return {w, h}
				end,
				Callback = function(val)
					if not GAMEMODE:CheckInput("number", {}, val[1]) then
						return
					end

					if not GAMEMODE:CheckInput("number", {}, val[2]) then
						return
					end

					local w = math.Clamp(val[1], 1, 4)
					local h = math.Clamp(val[2], 1, 4)

					self:SetSize(w, h)
				end
			})
		end
	end

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

if SERVER then
	function ITEM:SetSize(w, h)
		if w == self.Width and h == self.Height then
			return
		end

		local inv = self:GetInventory()

		if not inv then
			self.Width = w
			self.Height = h

			return
		end

		inv:RemoveItem(self)

		self.Width = w
		self.Height = h

		local ok, flipped, x, y = inv:FindItemFit(self)

		if not ok then
			self:SetWorldItem(ply:GetItemDropLocation(), Angle())
		else
			if flipped then
				self.Flipped = not self.Flipped
			end

			inv:AddItem(self, x, y)
		end
	end
end

return ITEM