local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1

	self.btnUp:Remove()
	self.btnUp = self:Add("eternity_button")
	self.btnUp:SetFont("marlett")
	self.btnUp:SetText("t")
	self.btnUp.DoClick = function()
		self:AddScroll(-1)
	end

	self.btnDown:Remove()
	self.btnDown = self:Add("eternity_button")
	self.btnDown:SetFont("marlett")
	self.btnDown:SetText("u")
	self.btnDown.DoClick = function()
		self:AddScroll(1)
	end

	self.btnGrip:Remove()
	self.btnGrip = self:Add("eternity_scrollbargrip")

	self:SetSize(15, 15)
	self:SetHideButtons(false)
end

function PANEL:Paint(w, h)
	return true
end

derma.DefineControl("eternity_vscrollbar", "", PANEL, "DVScrollBar")

PANEL = {}

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	surface.SetDrawColor(colors.FillLight)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(colors.FillMedium)
	surface.DrawOutlinedRect(0, 0, w, h)

	return true
end

derma.DefineControl("eternity_scrollbargrip", "", PANEL, "DScrollBarGrip")