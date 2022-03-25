local PANEL = {}
DEFINE_BASECLASS("eternity_basepanel")

function PANEL:Init()
	self:SetSize(400, 600)
	self:DockPadding(5, 5, 5, 5)

	self:SetAllowEscape(true)

	self:SetDrawTopBar(true)
	self:SetTitle("MOTD")

	self.Scroll = self:Add("eternity_scrollpanel")
	self.Scroll:DockMargin(2, 0, 0, 0)
	self.Scroll:Dock(FILL)

	self.Panel = self.Scroll:Add("eternity_panel")

	self.Panel.Paint = function(pnl, w, h)
		if self.MarkLeft then
			self.MarkLeft:Draw(0, 0)
		end
	end

	self.Scroll:AddItem(self.Panel)
	self.Scroll:InvalidateParent(true)

	local colors = GAMEMODE:GetConfig("UIColors")
	local text = string.format("<font=eternity.labelsmall><col=%s>%s", util.ColorToChat(colors.TextNormal), GAMEMODE.MOTD)

	self.MarkLeft = markleft.Parse(text, self.Scroll:GetWide() - 15)

	self.Panel:SetSize(self.MarkLeft:GetSize())

	self.Scroll:InvalidateParent(true)
	self.Scroll:AutoSize()
	self.Scroll:UpdateLayout()

	self:MakePopup()
	self:Center()
end

vgui.Register("eternity_motd", PANEL, "eternity_basepanel")

GM:RegisterGUI("MOTD", function(title, inventories)
	return vgui.Create("eternity_motd")
end)