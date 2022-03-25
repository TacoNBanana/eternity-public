local PANEL = {}

function PANEL:Init()
	self:SetWide(200)
	self:DockPadding(10, 10, 10, 10)

	self:SetAllowEscape(true)

	self:SetDrawTopBar(true)
	self:SetTitle("Combine Terminal")

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(ent)
	for _, v in pairs(ent.MenuOptions) do
		local button = self:Add("eternity_button")

		button:DockMargin(0, 0, 0, 5)
		button:Dock(TOP)
		button:SetText(v.Name)

		button.DoClick = function(pnl)
			GAMEMODE:CloseGUI("TerminalMenu")

			if v.GUI then
				GAMEMODE:OpenGUI(v.GUI)
			end
		end

		if v.Callback and not v.Callback(LocalPlayer()) then
			button:SetDisabled(true)
		end
	end

	self.Cancel = self:Add("eternity_button")
	self.Cancel:DockMargin(0, 20, 0, 0)
	self.Cancel:Dock(TOP)
	self.Cancel:SetText("Cancel")

	self.Cancel.DoClick = function(pnl)
		GAMEMODE:CloseGUI("TerminalMenu")
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

vgui.Register("eternity_terminalmenu", PANEL, "eternity_basepanel")

GM:RegisterGUI("TerminalMenu", function(ent)
	local ui = vgui.Create("eternity_terminalmenu")

	ui:Setup(ent)

	return ui
end, true)