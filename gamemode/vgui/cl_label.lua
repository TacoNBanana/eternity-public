local PANEL = {}

function PANEL:UpdateColours()
	local colors = GAMEMODE:GetConfig("UIColors")

	self:SetTextStyleColor(colors.TextNormal)
end

vgui.Register("eternity_label", PANEL, "DLabel")