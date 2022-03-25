local PANEL = {}

function PANEL:Init()
	self.btnLeft:Remove()
	self.btnRight:Remove()
end

function PANEL:Think()
	local framerate = VGUIFrameTime() - self.FrameTime

	self.FrameTime = VGUIFrameTime()

	if dragndrop.IsDragging() then
		local x = self:LocalCursorPos()

		if x < 30 then
			self.OffsetX = self.OffsetX - (350 * framerate)
		elseif ( x > self:GetWide() - 30 ) then
			self.OffsetX = self.OffsetX + (350 * framerate)
		end

		self:InvalidateLayout(true)
	end
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()

	self.pnlCanvas:SetTall(h)

	local x = 0

	for k, v in pairs(self.Panels) do
		if not IsValid(v) then
			continue
		end

		v:SetPos(x, 0)
		v:SetTall(h)
		v:ApplySchemeSettings()

		x = x + v:GetWide() - self.m_iOverlap
	end

	self.pnlCanvas:SetWide(x + self.m_iOverlap)

	if w < self.pnlCanvas:GetWide() then
		self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
	else
		self.OffsetX = 0
	end

	self.pnlCanvas.x = self.OffsetX * -1
end

vgui.Register("eternity_horizontalscroll", PANEL, "DHorizontalScroller")