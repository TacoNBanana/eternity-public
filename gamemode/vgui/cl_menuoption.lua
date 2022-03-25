local PANEL = {}

function PANEL:AddSubMenu()
	local pnl = EternityDermaMenu(self)

	pnl:SetVisible(false)
	pnl:SetParent(self)

	self:SetSubMenu(pnl)

	self.SubMenuArrow:SetMouseInputEnabled(false)

	return pnl
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	if not self.LaidOut then
		self.LaidOut = true

		self:SetFont("eternity.labelsmall")
		self:SetTextColor(colors.TextNormal)
	end

	if self.m_bBackground and (self.Hovered or self.Highlight) then
		local color = colors.MenuHovered

		surface.SetDrawColor(color.r, color.g, color.b, 255)
		surface.DrawRect(0, 0, w, h)
	else
		local color = self.Odd and colors.FillMedium or colors.MenuAlt

		surface.SetDrawColor(color.r, color.g, color.b, 255)
		surface.DrawRect(0, 0, w, h)
	end
end

vgui.Register("eternity_menuoption", PANEL, "DMenuOption")