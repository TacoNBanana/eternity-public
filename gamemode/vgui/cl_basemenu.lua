local PANEL = {}
DEFINE_BASECLASS("eternity_basepanel")

function PANEL:Init()
	local colors = GAMEMODE:GetConfig("UIColors")

	self.Topbar = self:Add("eternity_panel")
	self.Topbar:DockPadding(5, 10, 5, 10)
	self.Topbar:Dock(TOP)
	self.Topbar:SetTall(50)
	self.Topbar:SetDrawColor(colors.Border)

	self.MenuItems = {}

	self.Content = self:Add("eternity_panel")
	self.Content:DockMargin(5, 5, 5, 5)
	self.Content:Dock(FILL)

	self.Active = ""
end

function PANEL:Think()
	BaseClass.Think(self)

	self:MoveToBack()
end

function PANEL:AddMenu(name, cb)
	local button = self.Topbar:Add("eternity_button")

	button:DockMargin(5, 0, 5, 0)
	button:Dock(LEFT)
	button:SetText(name)

	button.DoClick = function(pnl)
		if self["Create" .. name] then
			for _, v in pairs(self.Content:GetChildren()) do
				v:Dock(NODOCK)
			end

			self.Content:Clear()

			self["Create" .. name](self)

			for _, v in pairs(self.MenuItems) do
				if v != pnl then
					v:SetDisabled(false)
				end
			end

			pnl:SetDisabled(true)

			self.Active = name
		end
	end

	table.insert(self.MenuItems, button)
end

function PANEL:SetupTopbar()
	self.Topbar:InvalidateParent(true)

	local w = self.Topbar:GetSize() - 10

	w = w - (#self.MenuItems * 10)

	local width = w / #self.MenuItems

	for _, v in pairs(self.MenuItems) do
		v:SetWide(width)
	end
end

vgui.Register("eternity_basemenu", PANEL, "eternity_basepanel")