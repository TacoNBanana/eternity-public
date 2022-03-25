local PANEL = {}
DEFINE_BASECLASS("EditablePanel")

AccessorFunc(PANEL, "_AllowEscape", "AllowEscape")
AccessorFunc(PANEL, "_ToggleKey", "ToggleKey")
AccessorFunc(PANEL, "_DrawTopbar", "DrawTopbar")
AccessorFunc(PANEL, "_Draggable", "Draggable")

function PANEL:Init()
	self:DockPadding(1, 1, 1, 1)
	self.Armed = false
end

function PANEL:SetDrawTopBar(bool)
	local padding = self:GetDockPadding()

	if bool then
		self:DockPadding(padding, padding + 24, padding, padding)

		if self._AllowEscape then
			self.ButtonClose = self:Add("eternity_button")
			self.ButtonClose:SetSize(24, 24)
			self.ButtonClose:SetFont("marlett")
			self.ButtonClose:SetText("r")
			self.ButtonClose:PerformLayout()
			self.ButtonClose.Paint = function() end
			self.ButtonClose.DoClick = function(pnl)
				pnl:GetParent():Remove()
			end
		end

		self.Title = self:Add("eternity_label")
	else
		self:DockPadding(padding, padding, padding, padding)

		if IsValid(self.ButtonClose) then
			self.ButtonClose:Remove()
		end

		if IsValid(self.Title) then
			self.Title:Remove()
		end
	end

	self._DrawTopbar = bool

	self:PerformLayout()
end

function PANEL:Think()
	if not self.Armed and not input.IsKeyDown(KEY_ESCAPE) then
		self.Armed = true
	end

	if self.Armed and self._AllowEscape and input.IsKeyDown(KEY_ESCAPE) then
		self:Remove()
		gui.HideGameUI()
	end

	if self.Dragging then
		local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
		local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

		local x = math.Clamp(mousex - self.Dragging[1], 0, ScrW() - self:GetWide())
		local y = math.Clamp(mousey - self.Dragging[2], 0, ScrH() - self:GetTall())

		self:SetPos(x, y)
	end
end

function PANEL:SetTitle(title)
	if IsValid(self.Title) then
		self.Title:SetText(title)
	end
end

function PANEL:SetSize(w, h)
	if self._DrawTopbar then
		h = h + 24
	end

	BaseClass.SetSize(self, w, h)
end

function PANEL:OnKeyCodePressed(key)
	if self._ToggleKey and input.LookupKeyBinding(key) == self._ToggleKey then
		self:Remove()
	end
end

function PANEL:OnMousePressed()
	local x, y = self:ScreenToLocal(gui.MousePos())

	if self._Draggable and math.InRange(x, 0, self:GetWide()) and math.InRange(y, 0, 24) then
		self.Dragging = {x, y}
		self:MouseCapture(true)
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self:MouseCapture(false)
end

function PANEL:PerformLayout()
	if IsValid(self.ButtonClose) then
		self.ButtonClose:SetPos(self:GetWide() - 24, 0)
	end

	if IsValid(self.Title) then
		self.Title:SetPos(6, 0)
		self.Title:SetSize(self:GetWide() - 24, 25)
	end
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")
	local alpha = GAMEMODE:GetSetting("ui_transparent") and 250 or 255

	surface.SetDrawColor(ColorAlpha(colors.FillDark, alpha))
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(colors.Border)
	surface.DrawOutlinedRect(0, 0, w, h)

	if self._DrawTopbar then
		surface.DrawRect(0, 0, w, 25)
	end
end

vgui.Register("eternity_basepanel", PANEL, "EditablePanel")