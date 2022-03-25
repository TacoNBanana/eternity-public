local PANEL = {}

AccessorFunc(PANEL, "_State", "State")

function PANEL:Init()
	self:SetState(false)
end

function PANEL:DoClick()
	local state = not self:GetState()

	self:SetState(state)

	if state then
		self:OnEnable()
	else
		self:OnDisable()
	end

	self:OnToggle(state)
end

function PANEL:OnEnable()
end

function PANEL:OnDisable()
end

function PANEL:OnToggle()
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")
	local fill

	if self:GetDisabled() then
		fill = colors.FillDark
	else
		fill = self:GetState() and colors.Primary or colors.FillLight
	end

	surface.SetDrawColor(fill)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self:GetState() and colors.PrimaryDark or colors.FillMedium)
	surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("eternity_togglebutton", PANEL, "eternity_button")