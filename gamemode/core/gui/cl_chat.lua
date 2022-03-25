local PANEL = {}

function PANEL:Init()
	local size = GAMEMODE:GetConfig("ChatSize")

	self:SetSize(unpack(size))
	self:MakePopup()

	self.Tabs = cookie.GetNumber("eternity_chattabs", -1)

	self.Buffer = {}
	self.BufferSize = 0

	self.Scroll = self:Add("eternity_scrollpanel")

	self.Scroll.AutoScroll = true
	self.Scroll.PreferBottom = true
	self.Scroll.ScrollAmount = draw.GetFontHeight("eternity.chat")

	self.Scroll:SetPos(10, 40)
	self.Scroll:SetSize(size[1] - 20, size[2] - 80)
	self.Scroll:UpdateLayout()

	self.Scroll.Paint = function(pnl, w, h)
		if self.IsOpen then
			local color = GAMEMODE:GetSetting("chat_transparent") and Color(0, 0, 0, 70) or GAMEMODE:GetConfig("UIColors").FillDark

			surface.SetDrawColor(color)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	end

	self.Canvas = self.Scroll.Canvas

	self.Canvas.Paint = function(pnl, w, h)
		if not GAMEMODE:GetSetting("chat_enabled") and not self.IsOpen then
			return true
		end

		local diff = math.max(pnl:GetTall() - self.Scroll:GetTall(), 0)
		local cy = select(2, pnl:GetPos())
		local limit = self.Scroll:GetTall() + diff + cy - 3

		local y = h - 3

		for i = #self.Buffer, 1, -1 do
			local data = self.Buffer[i]
			local lifetime = CurTime() - data.ReceiveTime
			local alpha = 255

			if not self.IsOpen then
				if lifetime >= 15 then
					break -- All other messages are assumed to be older, no need to iterate them
				else
					alpha = (15 - lifetime) * 0.2 * 255
				end
			end

			if self:CanSeeTab(data.Tab) then
				y = y - data.Markup:GetHeight()

				data.Markup:Draw(5, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha)

				if h - y > limit then
					break
				end
			end
		end
	end

	self.Input = self:Add("eternity_chatinput")
	self.Input:SetSize(self:GetWide() - 20, 20)
	self.Input:SetPos(10, self:GetTall() - self.Input:GetTall() - 10)

	self.Buttons = {}

	local last
	local tabs = {
		{"LOOC", 	TAB_LOOC},
		{"OOC",		TAB_OOC},
		{"IC",		TAB_IC},
		{"Admin",	TAB_ADMIN},
		{"PM",		TAB_PM},
		{"Radio",	TAB_RADIO}
	}

	for _, v in pairs(tabs) do
		local button = self:Add("eternity_button")

		button:SetFont("eternity.labelsmall")
		button:SetText(v[1])
		button:SetSize(60, 20)
		button:SetPos(10, 10)

		if last then
			button:MoveRightOf(last, 5)
		end

		button.Active = self:CanSeeTab(v[2])

		button.Paint = function(pnl, w, h)
			local colors = GAMEMODE:GetConfig("UIColors")

			surface.SetDrawColor(pnl.Active and colors.FillLight or colors.FillDark)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(colors.FillMedium)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		button.DoClick = function(pnl)
			pnl.Active = not pnl.Active

			self:SaveTabConfig()
			self.Input:RequestFocus()
		end

		last = button
		button.Tab = v[2]

		table.insert(self.Buttons, button)
	end

	self.Close = self:Add("eternity_button")
	self.Close:SetFont("marlett")
	self.Close:SetText("r")
	self.Close:SetSize(20, 20)
	self.Close:SetPos(self:GetWide() - self.Close:GetWide() - 10, 10)

	self.Close.DoClick = function(pnl)
		GAMEMODE:HideChat()
	end
end

function PANEL:SaveTabConfig()
	local val = 0

	for _, v in pairs(self.Buttons) do
		if v.Active then
			val = val + v.Tab
		end
	end

	self.Tabs = val

	cookie.Set("eternity_chattabs", val)
end

function PANEL:CanSeeTab(tab)
	if not tab then
		return true
	end

	return self.Tabs == -1 or tobool(bit.band(self.Tabs, tab))
end

function PANEL:Show()
	self.IsOpen = true

	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)

	self.Scroll.NoScrollbar = false
	self.Scroll:ShowScrollbar()

	self.Input:Show()
	self.Input:RequestFocus()
	self.Input.HistoryIndex = 0

	for _, v in pairs(self.Buttons) do
		v:Show()
	end

	self.Close:Show()
end

function PANEL:Hide()
	self.IsOpen = false

	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	self.Scroll.NoScrollbar = true
	self.Scroll:HideScrollbar()
	self.Scroll:MoveToBottom()

	self.Input:Hide()
	self.Input:SetText("")

	for _, v in pairs(self.Buttons) do
		v:Hide()
	end

	self.Close:Hide()
end

function PANEL:AddMessage(message, console, tabs)
	local config = GAMEMODE:GetConfig("ChatSize")
	local data = {
		Markup = markleft.Parse("<chat>" .. message, config[1] - 45),
		ReceiveTime = CurTime(),
		Tab = tabs
	}

	local log = data.Markup

	if console then
		log = markleft.Parse(console)
	end

	log:PrintToConsole()
	log:PrintToFile(string.format("eternity/logs/%s/all.txt", os.date("%Y-%m-%d")))

	table.insert(self.Buffer, data)

	local scroll = self.Scroll:IsAtBottom()

	self.BufferSize = self.BufferSize + data.Markup:GetHeight()
	self:ResizeCanvas()

	if scroll then
		self.Scroll:MoveToBottom()
	end

	if not system.HasFocus() and self:CanSeeTab(tabs) then
		system.FlashWindow()
	end
end

function PANEL:ResizeCanvas()
	-- Something something panel size overflow
	while self.BufferSize > 2^15 - 1 do
		local line = table.remove(self.Buffer, 1)

		self.BufferSize = self.BufferSize - line.Markup:GetHeight()
	end

	self.Scroll:ResizeCanvas(self.BufferSize + 1)
end

function PANEL:Paint(w, h)
	local config = GAMEMODE:GetConfig("UIColors")

	if self.IsOpen then
		surface.SetDrawColor(ColorAlpha(config.FillDark, 200))
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(ColorAlpha(config.Border, 70))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	return true
end

function PANEL:ExportBuffer()
	return {
		self.Buffer,
		self.BufferSize,
		self.IsOpen
	}
end

function PANEL:ImportBuffer(buffer)
	self.Buffer = buffer[1]
	self.BufferSize = buffer[2]

	self:ResizeCanvas()
	self.Scroll:MoveToBottom()

	if buffer[3] then
		self:Show()
	end
end

derma.DefineControl("eternity_chat", "", PANEL, "EditablePanel")

GM:RegisterGUI("Chat", function()
	local pnl = vgui.Create("eternity_chat")

	pnl:SetPos(20, ScrH() - pnl:GetTall() - 200)
	pnl:Hide()

	return pnl
end, true)

function GM:ShowChat()
	GAMEMODE:GetGUI("Chat"):Show()
end

function GM:HideChat()
	GAMEMODE:GetGUI("Chat"):Hide()
	GAMEMODE:UpdateTypingIndicator()
end

hook.Add("PlayerBindPress", "chat.PlayerBindPress", function(ply, bind, down)
	if down and string.find(bind, "messagemode") then
		GAMEMODE:ShowChat()

		return true
	end
end)