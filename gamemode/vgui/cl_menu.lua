local PANEL = {}

function PANEL:AddOption(text, func)
	local pnl = self:Add("eternity_menuoption")

	pnl:SetMenu(self)
	pnl:SetText(text)
	pnl.Odd = self.Odd

	self.Odd = not self.Odd

	if func then
		pnl.DoClick = func
	end

	self:AddPanel(pnl)

	return pnl
end

function PANEL:AddSubMenu(text, func)
	local pnl = self:Add("eternity_menuoption")
	local sub = pnl:AddSubMenu()

	pnl:SetText(text)
	pnl.Odd = self.Odd

	self.Odd = not self.Odd

	if func then
		pnl.DoClick = func
	end

	self:AddPanel(pnl)

	return sub, pnl
end

function PANEL:AddSpacer()
	local pnl = self:Add("eternity_panel")

	pnl:SetDrawColor(GAMEMODE:GetConfig("UIColors").FillDark)
	pnl:SetTall(1)

	return pnl
end

function PANEL:OpenSubMenu(item, sub)
	local openmenu = self:GetOpenSubMenu()

	if IsValid(openmenu) and openmenu:IsVisible() then
		if sub and openmenu == sub then
			return
		end

		self:CloseSubMenu(openmenu)
	end

	if not IsValid(sub) then
		return
	end

	self:InvalidateLayout(true)

	local x, y = item:LocalToScreen(self:GetWide(), 0)

	sub:Open(x - 3, y, false, item)

	self:SetOpenSubMenu(sub)
end

function PANEL:Paint(w, h)
end

vgui.Register("eternity_menu", PANEL, "DMenu")

function EternityDermaMenu(parentmenu, parent)
	if not parentmenu then
		CloseDermaMenus()
	end

	local dmenu = vgui.Create("eternity_menu", parent)

	return dmenu
end