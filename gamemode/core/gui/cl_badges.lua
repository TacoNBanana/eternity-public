local PANEL = {}

function PANEL:Init()
	self:SetSize(200, 200)
	self:DockPadding(10, 10, 10, 10)

	self:SetAllowEscape(true)
	self:SetDrawTopBar(true)
	self:SetTitle("Badges")

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(ply)
	for _, v in pairs(ply:GetBadges()) do
		local row = self:Add("eternity_panel")

		row:DockMargin(0, 0, 0, 6)
		row:Dock(TOP)
		row:SetTall(16)

		local image = row:Add("DImage")

		image:Dock(LEFT)
		image:SetWide(16)
		image:SetMaterial(v.Material)

		local text = row:Add("eternity_label")

		text:DockMargin(6, 0, 0, 0)
		text:Dock(FILL)
		text:SetFont("eternity.labelsmall")
		text:SetText(v.Name)
	end
end

vgui.Register("eternity_badges", PANEL, "eternity_basepanel")

GM:RegisterGUI("Badges", function(ply)
	local panel = vgui.Create("eternity_badges")

	panel:Setup(ply)

	return panel
end, true)