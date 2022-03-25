local PANEL = {}

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	if self:GetPaintBackground() then
		surface.SetDrawColor(colors.TextEntry)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(colors.FillDark)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	self:DrawTextEntryText(colors.TextNormal, colors.TextHighlight, colors.TextNormal)
end

function PANEL:SetCaret()
	self:SetCaretPos(#self:GetValue())
end

vgui.Register("eternity_textentry", PANEL, "DTextEntry")