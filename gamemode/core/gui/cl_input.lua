local PANEL = {}

function PANEL:Init()
	self:DockPadding(10, 10, 10, 10)
	self:SetAllowEscape(true)
	self:SetDrawTopBar(true)

	self.Bottom = self:Add("eternity_panel")
	self.Bottom:DockMargin(0, 10, 0, 0)
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetTall(30)

	self.Submit = self.Bottom:Add("eternity_button")
	self.Submit:Dock(RIGHT)
	self.Submit:SetText("Submit")
	self.Submit.DoClick = function()
		self:DoSubmit()
	end
end

function PANEL:Setup(subtype, title, data)
	self.Subtype = subtype
	self.Data = data

	self:SetTitle(title)

	if subtype == "string" or subtype == "number" then
		local width = data.Multiline and 500 or 300
		local height = data.Multiline and 280 or 90

		self:SetSize(width, height)

		self.TextInput = self:Add("eternity_textentry")
		self.TextInput:Dock(BOTTOM)
		self.TextInput:SetTall(data.Multiline and 220 or 30)
		self.TextInput:SetFont(data.Multiline and "eternity.labelsmall" or "eternity.labelbig")
		self.TextInput:SetText(data.Default or "")
		self.TextInput:SetMultiline(data.Multiline or false)

		if subtype == "number" then
			self.TextInput.AllowInput = function(pnl, val)
				if not string.find(val, "%d") and val != "." then
					return true
				end
			end
		end

		if data.Max then
			local len = 0

			if data.Default then
				len = #data.Default
			end

			self.MaxLabel = self.Bottom:Add("eternity_label")
			self.MaxLabel:DockMargin(2, 0, 0, 0)
			self.MaxLabel:Dock(FILL)
			self.MaxLabel:SetFont("eternity.labelbig")
			self.MaxLabel:SetText(len .. "/" .. data.Max)
		end

		self.TextInput.OnChange = function()
			if data.Max then
				local val = self:GetOutput()
				local colors = GAMEMODE:GetConfig("UIColors")

				self.MaxLabel:SetTextColor(#val > data.Max and colors.TextBad or colors.TextNormal)
				self.MaxLabel:SetText(#val .. "/" .. data.Max)

				self.Submit:SetDisabled(not self:CanSubmit())
			end
		end

		self.TextInput.OnEnter = function()
			self:DoSubmit()
		end

		self.TextInput:SetCaret()
		self.TextInput:RequestFocus()
	end

	self.Coroutine = coroutine.running()
end

function PANEL:GetOutput()
	if self.Subtype == "string" or self.Subtype == "number" then
		return string.Trim(self.TextInput:GetValue())
	end
end

function PANEL:CanSubmit()
	return GAMEMODE:CheckInput(self.Subtype, self.Data, self:GetOutput())
end

function PANEL:DoSubmit()
	if not self:CanSubmit() then
		return
	end

	local val = self:GetOutput()

	self:Remove()

	local ok, res = coroutine.resume(self.Coroutine, val)

	if not ok then
		error(res)
		return
	end
end

vgui.Register("eternity_input", PANEL, "eternity_basepanel")

GM:RegisterGUI("Input", function(subtype, title, data)
	local pnl = vgui.Create("eternity_input")

	pnl:Setup(subtype, title, data)

	pnl:MakePopup()
	pnl:Center()

	return coroutine.yield()
end)