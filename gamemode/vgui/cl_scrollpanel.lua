local PANEL = {}

function PANEL:Init()
	self.ScrollAmount = draw.GetFontHeight("eternity.chat")

	self.Canvas = self:Add("EditablePanel")
	self.Canvas:SetSize(self:GetWide() - 15, 0)

	self.Canvas.Paint = function(pnl)
		return true
	end

	self.ScrollUp = self:Add("eternity_scrollbutton")
	self.ScrollUp:SetPos(self:GetWide() - 15, 0)
	self.ScrollUp:SetDirection(1)

	self.ScrollDown = self:Add("eternity_scrollbutton")
	self.ScrollDown:SetPos(self:GetWide() - 15, 0)
	self.ScrollDown:SetDirection(-1)

	self.ScrollGrip = self:Add("eternity_scrollgrip")
	self.ScrollGrip:SetPos(self:GetWide() - 15, 0)

	self:UpdateLayout()
	self:HideScrollbar()
end

function PANEL:Paint(w, h)
	return true
end

function PANEL:UpdateLayout()
	local x = self:GetWide() - 15
	local y = self:GetTall() - 15

	self.ScrollUp:SetPos(x, 0)
	self.ScrollDown:SetPos(x, y)
	self.ScrollGrip:SetPos(x, 0)

	self:UpdateScrollbar()
end

function PANEL:AutoSize()
	local size = 0
	local children = self.Canvas:GetChildren()

	if #children > 0 then
		for _, v in pairs(children) do
			local _, top, _, bottom = v:GetDockMargin()

			size = size + v:GetTall() + top + bottom
		end

		size = size - select(4, children[#children]:GetDockMargin())
	end

	self:ResizeCanvas(size)
end

function PANEL:Think()
	if self.GripY then
		local x, y, _, h = self.ScrollGrip:GetBounds()
		local dy = gui.MouseY() - self.MouseY
		local newy = math.Clamp(self.GripY + dy, 15, self:GetTall() - h - 15)

		self.ScrollGrip:SetPos(x, newy)

		local hidden = (self:GetTall() - 30) - h
		local above = y - 15

		self.Canvas:SetPos(0, -above / hidden * (self.Canvas:GetTall() - self:GetTall()))
	end
end

function PANEL:OnGripped(gripped)
	if gripped then
		self.GripY = select(2, self.ScrollGrip:GetPos())
		self.MouseY = gui.MouseY()
	else
		self.GripY = nil
		self.MouseY = nil
	end
end

function PANEL:ResizeCanvas(height, force)
	if height == self.Canvas:GetTall() then
		return
	end

	self.Canvas:SetSize(self:GetWide() - 15, height)

	if not self:ShowScrollbar() then
		self.Canvas:SetWide(self:GetWide())
		self:HideScrollbar()
	end

	if self.AutoScroll and (self:IsAtBottom() or force) then
		self.Canvas:SetPos(0, self:GetBottom())
	else
		local _, y = self.Canvas:GetPos()

		self.Canvas:SetPos(0, math.Clamp(y, self:GetBottom(), 0))
	end

	self:UpdateScrollbar()
end

function PANEL:UpdateScrollbar()
	local canvas = self.Canvas:GetTall()
	local view = self:GetTall()

	local track = view - 30
	local percentage = math.Clamp(view / canvas, 0, 1)

	self.ScrollGrip:SetSize(15, math.Clamp(math.ceil(percentage * track), 30, track))

	local x = self.ScrollGrip:GetPos()
	local _, offset = self.Canvas:GetPos()

	local hidden = canvas - view

	self.ScrollGrip:SetPos(x, -offset / hidden * (track - self.ScrollGrip:GetTall()) + 15)
end

function PANEL:MoveCanvas(delta)
	local x, y, w, h = self.Canvas:GetBounds()

	if self:GetTall() >= h or delta == 0 then
		return
	end

	self.Canvas:SetPos(x, math.Clamp(y + delta, self:GetTall() - h, 0))
	self:UpdateScrollbar()
end

function PANEL:OnMouseWheeled(delta)
	if self:GetTall() > self.Canvas:GetTall() then
		return
	end

	self:MoveCanvas(delta * self.ScrollAmount)
end

function PANEL:GetBottom()
	if self.PreferBottom then
		return self:GetTall() - self.Canvas:GetTall()
	end

	return self.Canvas:GetTall() > self:GetTall() and self:GetTall() - self.Canvas:GetTall() or 0
end

function PANEL:MoveToBottom()
	self.Canvas:SetPos(0, self:GetBottom())
	self:UpdateScrollbar()
end

function PANEL:IsAtBottom()
	return select(2, self.Canvas:GetPos()) == self:GetBottom()
end

function PANEL:ShowScrollbar(force)
	if self.NoScrollbar then
		return false
	end

	if not force and self.Canvas:GetTall() < self:GetTall() then
		return false
	end

	self.ScrollUp:Show()
	self.ScrollDown:Show()
	self.ScrollGrip:Show()

	return true
end

function PANEL:HideScrollbar()
	self.ScrollUp:Hide()
	self.ScrollDown:Hide()
	self.ScrollGrip:Hide()
end

function PANEL:AddItem(pnl)
	pnl:SetParent(self.Canvas)
end

derma.DefineControl("eternity_scrollpanel", "", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:SetWide(15)
	self:Hide()
end

function PANEL:OnMousePressed(key)
	self:MouseCapture(true)
	self:GetParent():OnGripped(true)
end

function PANEL:OnMouseReleased(key)
	self:MouseCapture(false)
	self:GetParent():OnGripped(false)
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	surface.SetDrawColor(colors.FillLight)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(colors.FillMedium)
	surface.DrawOutlinedRect(0, 0, w, h)

	return true
end

derma.DefineControl("eternity_scrollgrip", "", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:SetFont("marlett")
	self:SetSize(15, 15)
	self:Hide()
end

function PANEL:SetDirection(dir)
	self:SetText(dir > 0 and "t" or "6")
	self.Direction = dir
end

function PANEL:OnMousePressed()
	self:MouseCapture(true)

	self.Pressed = CurTime()
	self.NextScroll = CurTime() + 0.5

	self:GetParent():OnMouseWheeled(self.Direction)
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self.Pressed = nil
end

function PANEL:Think()
	if self.Pressed and CurTime() > self.NextScroll then
		self:GetParent():OnMouseWheeled(self.Direction * math.ceil((CurTime() - self.Pressed) * 0.5))
		self.NextScroll = CurTime() + 0.05
	end
end

derma.DefineControl("eternity_scrollbutton", "", PANEL, "eternity_button")