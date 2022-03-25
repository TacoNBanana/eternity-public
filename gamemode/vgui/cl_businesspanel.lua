local PANEL = {}
DEFINE_BASECLASS("eternity_panel")

AccessorFunc(PANEL, "_Alt", "Alt")

function PANEL:Init()
	self.Icon = self:Add("DModelPanel")
	self.Icon:DockMargin(0, 0, 5, 0)
	self.Icon:Dock(LEFT)
	self.Icon:SetWide(64)

	self.Icon.LayoutEntity = function(pnl, ent)
		local tab = PositionSpawnIcon(ent, ent:GetPos())

		pnl:SetCamPos(tab.origin)
		pnl:SetLookAng(tab.angles)
		pnl:SetFOV(tab.fov)
	end

	local right = self:Add("eternity_panel")

	right:DockMargin(5, 0, 5, 0)
	right:Dock(RIGHT)
	right:SetWide(105)

	local bottom = right:Add("eternity_panel")

	bottom:DockMargin(0, 0, 0, 5)
	bottom:Dock(BOTTOM)
	bottom:SetTall(24)

	self.Amount = bottom:Add("eternity_textentry")
	self.Amount:DockMargin(0, 0, 5, 0)
	self.Amount:Dock(LEFT)
	self.Amount:SetWide(50)
	self.Amount:SetValue(1)
	self.Amount:SetCaretPos()
	self.Amount:SetUpdateOnType(true)

	self.Amount.OnValueChange = function(pnl, val)
		self:UpdateMoney()
	end

	self.Amount.AllowInput = function(pnl, val)
		if not string.find(val, "%d") then
			return true
		end
	end

	self.Buy = bottom:Add("eternity_button")
	self.Buy:Dock(FILL)
	self.Buy:SetText("Buy")

	self.Buy.DoClick = function(pnl)
		self:BuyItem()
	end

	self.Price = right:Add("eternity_label")
	self.Price:DockMargin(2, 0, 0, 0)
	self.Price:Dock(FILL)
	self.Price:SetContentAlignment(4)
	self.Price:SetFont("eternity.labeltiny")
	self.Price:SetText("Price")

	self.Name = self:Add("eternity_label")
	self.Name:DockMargin(0, 5, 0, 5)
	self.Name:Dock(TOP)
	self.Name:SetTall(14)
	self.Name:SetFont("eternity.labelsmall")
	self.Name:SetText("Name")

	self.Description = self:Add("eternity_label")
	self.Description:Dock(FILL)
	self.Description:SetFont("eternity.labeltiny")
	self.Description:SetWrap(true)
	self.Description:SetContentAlignment(7)
end

function PANEL:Setup(classname)
	local item = class.Get(classname)

	self.Stacking = item:IsTypeOf("base_stacking")
	self.ItemClass = classname
	self.ItemPrice = item.UnitPrice

	self.Icon:SetModel(item.Model)
	self.Icon:SetSkin(item.Skin)

	self.Name:SetText(item.Name)
	self.Description:SetText(string.match(item.Description, "^[^\r\n]*"))

	if not self.Stacking then
		self.Amount:Remove()
	end
end

function PANEL:BuyItem()
	local tab = {
		Class = self.ItemClass
	}

	if self.Stacking then
		tab.Amount = tonumber(self.Amount:GetValue()) or 1
	end

	netstream.Send("BuyItem", tab)
end

function PANEL:UpdateMoney()
	if self.ItemPrice > 0 then
		local amount = tonumber(self.Amount:GetValue()) or 1

		self.Price:SetText(string.format("%s Credits", amount * self.ItemPrice))
	else
		self.Price:SetText("")
	end

	self.Buy:SetDisabled(not LocalPlayer():CanBuyItem(self.ItemClass, amount))
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	if self._Alt then
		surface.SetDrawColor(ColorAlpha(colors.Border, 130))
		surface.DrawRect(0, 0, w, h)
	end
end

vgui.Register("eternity_businesspanel", PANEL, "eternity_panel")