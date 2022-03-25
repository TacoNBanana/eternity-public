local PANEL = {}

function PANEL:Init()
	self:SetSize(800, 500)

	self:SetToggleKey("gm_showspare2")
	self:SetAllowEscape(true)

	self:AddMenu("Logs")

	self:SetupTopbar()

	self:MakePopup()
	self:Center()

	self.MenuItems[1]:DoClick()
end

function PANEL:CreateLogs()
	self.Logs = self.Content:Add("eternity_logpanel")
	self.Logs:Dock(FILL)
end

vgui.Register("eternity_adminmenu", PANEL, "eternity_basemenu")

GM:RegisterGUI("AdminMenu", function()
	return vgui.Create("eternity_adminmenu")
end, true)