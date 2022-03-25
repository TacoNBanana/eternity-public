local PANEL = {}

function PANEL:UpdateColours()
	local colors = GAMEMODE:GetConfig("UIColors")

	if self:GetDisabled() then
		self:SetTextStyleColor(colors.TextDisabled)
	elseif self:IsDown() then
		self:SetTextStyleColor(colors.TextPrimary)
	elseif self:IsHovered() then
		self:SetTextStyleColor(colors.TextHover)
	else
		self:SetTextStyleColor(colors.TextNormal)
	end
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	surface.SetDrawColor(self:GetDisabled() and colors.FillDark or colors.FillLight)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(colors.FillMedium)
	surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("eternity_button", PANEL, "DButton")