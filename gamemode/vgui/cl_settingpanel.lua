local PANEL = {}

function PANEL:Init()
	self.Left = self:Add("eternity_panel")
	self.Left:DockMargin(5, 0, 0, 0)
	self.Left:Dock(LEFT)
	self.Left:SetWide(250)

	self.Right = self:Add("eternity_panel")
	self.Right:Dock(FILL)

	self.Title = self.Left:Add("eternity_label")
	self.Title:Dock(FILL)
	self.Title:SetContentAlignment(4)
end

function PANEL:Setup(key, odd)
	local colors = GAMEMODE:GetConfig("UIColors")

	self:SetDrawColor(odd and colors.FillMedium or colors.FillDark)

	local setting = GAMEMODE.PlayerSettings[key]

	self.Title:SetText(setting.Name)

	if setting.Type == TYPE_BOOL then
		local checkbox = self.Right:Add("DCheckBox")

		checkbox:SetValue(GAMEMODE:GetSetting(key))
		checkbox:SetPos(0, (self.Right:GetTall() * 0.5) - (checkbox:GetTall() * 0.5))

		checkbox.OnChange = function(pnl, bool)
			netstream.Send("SetSetting", {
				Key = key,
				Value = bool
			})
		end
	elseif setting.Type == TYPE_TABLE then
		local combobox = self.Right:Add("eternity_combobox")

		combobox:SetWide(200)
		combobox:SetPos(0, 1)
		combobox:SetValue(setting.Data[GAMEMODE:GetSetting(key)])
		combobox:SetSortItems(false)

		for k, v in ipairs(setting.Data) do
			combobox:AddChoice(v, k)
		end

		combobox.OnSelect = function(pnl, index, str, data)
			netstream.Send("SetSetting", {
				Key = key,
				Value = data
			})
		end
	elseif setting.Type == TYPE_COLOR then
		self.Color = GAMEMODE:GetSetting(key)

		local text = self.Right:Add("eternity_textentry")

		text:SetUpdateOnType(true)
		text:SetPaintBackground(false)
		text:DockMargin(20, 0, 0, 0)
		text:Dock(FILL)
		text:SetValue(string.format("%s %s %s", self.Color.r, self.Color.g, self.Color.b))

		text.OnValueChange = function(pnl, val)
			local tab = string.Explode(" ", val)

			for i = 1, 3 do
				tab[i] = tonumber(tab[i]) or 255
			end

			self.Color = Color(tab[1], tab[2], tab[3])
		end

		local button = self.Right:Add("eternity_button")

		button:SetSize(16, 16)
		button:SetPos(0, (self.Right:GetTall() * 0.5) - (button:GetTall() * 0.5))
		button:SetText("")

		button.Paint = function(pnl, w, h)
			surface.SetDrawColor(self.Color.r, self.Color.g, self.Color.b, 255)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		button.DoClick = function()
			local combo = vgui.Create("DColorCombo", self)

			combo:SetupCloseButton(function()
				CloseDermaMenus()
			end)

			combo.OnValueChanged = function(pnl, val)
				text:SetValue(string.format("%s %s %s", val.r, val.g, val.b))

				self.Color = Color(val.r, val.g, val.b)
			end

			combo:SetColor(self.Color)

			local popup = EternityDermaMenu()
			popup:AddPanel(combo)
			popup:SetPaintBackground(false)
			popup:Open(gui.MouseX() + 8, gui.MouseY() + 10)
		end

		local save = self.Right:Add("eternity_button")

		save:DockMargin(0, 1, 0, 0)
		save:Dock(RIGHT)
		save:SetText("Save")

		save.DoClick = function(pnl)
			netstream.Send("SetSetting", {
				Key = key,
				Value = self.Color
			})
		end

		local reset = self.Right:Add("eternity_button")

		reset:DockMargin(0, 1, 1, 0)
		reset:Dock(RIGHT)
		reset:SetText("Reset")

		reset.DoClick = function(pnl)
			local default = setting.Default

			text:SetValue(string.format("%s %s %s", default.r, default.g, default.b))

			self.Color = Color(default.r, default.g, default.b)
		end

	end
end

derma.DefineControl("eternity_settingpanel", "", PANEL, "eternity_panel")