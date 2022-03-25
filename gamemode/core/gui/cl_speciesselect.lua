local PANEL = {}

function PANEL:Init()
	self:SetWide(200)
	self:DockPadding(10, 10, 10, 10)

	if LocalPlayer():HasCharacter() then
		self:SetToggleKey("gm_showteam")
		self:SetAllowEscape(true)
	end

	for _, v in pairs(LocalPlayer():GetAvailableSpecies()) do
		local button = self:Add("eternity_button")

		button:DockMargin(0, 0, 0, 5)
		button:Dock(TOP)
		button:SetText(v.Name)

		button.DoClick = function(pnl)
			GAMEMODE:CloseGUI("SpeciesSelect")
			GAMEMODE:OpenGUI("CharCreate", v)
		end
	end

	self.Cancel = self:Add("eternity_button")
	self.Cancel:DockMargin(0, 20, 0, 0)
	self.Cancel:Dock(TOP)
	self.Cancel:SetText("Cancel")

	self.Cancel.DoClick = function(pnl)
		GAMEMODE:CloseGUI("SpeciesSelect")
		GAMEMODE:OpenGUI("CharSelect")
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	self:MakePopup()
	self:Center()
end

vgui.Register("eternity_speciesselect", PANEL, "eternity_basepanel")

GM:RegisterGUI("SpeciesSelect", function()
	return vgui.Create("eternity_speciesselect")
end, true)