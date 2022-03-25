local PANEL = {}

function PANEL:Init()
	self:SetSize(800, 500)
	self:DockPadding(10, 10, 10, 10)

	self:SetAllowEscape(true)

	self:SetDrawTopBar(true)

	self.Preview = self:Add("eternity_playerview")
	self.Preview:DockMargin(0, 0, 20, 0)
	self.Preview:Dock(LEFT)
	self.Preview:SetWide(200)
	self.Preview.TargetLookAt = Vector(0, 0, 54)

	self.CharacterName = self:Add("eternity_label")
	self.CharacterName:DockMargin(0, 0, 0, 5)
	self.CharacterName:Dock(TOP)
	self.CharacterName:SetTall(22)
	self.CharacterName:SetFont("eternity.labelgiant")

	self.Scroll = self:Add("eternity_scrollpanel")
	self.Scroll:DockMargin(2, 0, 0, 0)
	self.Scroll:Dock(FILL)
	self.Scroll:InvalidateParent(true)

	self.Scroll:UpdateLayout()

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(ply)
	local name = ply:RPName()

	if LocalPlayer():IsAdmin() then
		name = string.format("%s (%s)", name, ply:SteamID())
	end

	self:SetTitle(name)

	self.Preview:SetPlayer(ply)
	self.CharacterName:SetText(ply:RPName())

	local desc = ply:Description()
	local colors = GAMEMODE:GetConfig("UIColors")

	desc = string.Escape(desc)

	local formatted = string.format("<font=eternity.labelsmall><col=%s>%s", util.ColorToChat(colors.TextNormal), desc)

	self.MarkLeft = markleft.Parse(formatted, self.Scroll:GetWide() - 15)

	self.Description = self.Scroll:Add("eternity_panel")
	self.Description:SetSize(self.MarkLeft:GetSize())

	self.Description.Paint = function(pnl, w, h)
		self.MarkLeft:Draw(0, 0)
	end

	self.Scroll:AddItem(self.Description)
	self.Scroll:InvalidateParent(true)
	self.Scroll:AutoSize()
	self.Scroll:UpdateLayout()
end

vgui.Register("eternity_examine", PANEL, "eternity_basepanel")

GM:RegisterGUI("Examine", function(ply)
	local panel = vgui.Create("eternity_examine")

	panel:Setup(ply)

	return panel
end, true)