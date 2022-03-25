local PANEL = {}
DEFINE_BASECLASS("eternity_panel")

AccessorFunc(PANEL, "_Player", "Player")
AccessorFunc(PANEL, "_Alt", "Alt")

function PANEL:Init()
	self.Icon = self:Add("eternity_playerview")
	self.Icon:SetSize(55, 55)

	self.BadgeButton = self:Add("eternity_button")
	self.BadgeButton:Dock(RIGHT)
	self.BadgeButton:SetWide(100)
	self.BadgeButton:SetText("")

	self.BadgeButton.DoClick = function()
		if #self._Player:GetBadges() <= 0 then
			return
		end

		GAMEMODE:OpenGUI("Badges", self._Player)
	end

	self.BadgeButton.Paint = stub

	self.ExamineButton = self:Add("eternity_button")
	self.ExamineButton:Dock(FILL)
	self.ExamineButton:SetText("")

	self.ExamineButton.Paint = stub

	self.ExamineButton.DoClick = function(pnl)
		GAMEMODE:OpenGUI("Examine", self._Player)
	end

	self.ExamineButton.DoRightClick = function(pnl)
		LocalPlayer():CreateScoreboardContext(self._Player)
	end
end

function PANEL:SetPlayer(ply)
	self._Player = ply
	self.Icon:SetPlayer(ply)
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")
	local ply = self._Player

	if not IsValid(ply) or not ply:CanSeeOnScoreboard() then
		self:Remove()

		return
	end

	if self._Alt then
		surface.SetDrawColor(ColorAlpha(colors.Border, 130))
		surface.DrawRect(0, 0, w, h)
	end

	if ply:HiddenFromScoreboard() then
		surface.SetDrawColor(ColorAlpha(colors.Primary, 10))
		surface.DrawRect(0, 0, w, h)
	end

	local configs = GAMEMODE:GetConfig("PlayerLabel")
	local desc = string.match(ply:Description(), "^[^\r\n]*")

	if #desc > 0 and #desc > configs.Desc then
		desc = string.sub(desc, 1, configs.Desc) .. "..."
	end

	local nameY, descY, titleY = 10, 28, 28

	if #desc > 0 and false then
		nameY = 5
		descY = 22
		titleY = 40
	end

	draw.DrawText(ply:RPName(), "eternity.labelsmall", 66, nameY, colors.TextNormal)
	draw.DrawText(desc, "eternity.labelsmall", 66, descY, colors.TextDisabled)
	--draw.DrawText("Insert scoreboard title here", "eternity.labeltiny", 66, titleY, colors.TextPrimary)

	local pingY, badgeY, nickY = nameY, descY, titleY
	local badges = ply:GetBadges()

	if badgeY == nickY and #badges > 0 then
		pingY = 5
		badgeY = 22
		nickY = 40
	end

	draw.DrawText(ply:Ping(), "eternity.labelsmall", w - 30, pingY, colors.TextNormal, TEXT_ALIGN_RIGHT)

	if LocalPlayer():IsAdmin() then
		draw.DrawText(ply:Nick(), "eternity.labeltiny", w - 30, nickY, colors.TextNormal, TEXT_ALIGN_RIGHT)
	end

	local badgeX = w - 24

	surface.SetDrawColor(Color(255, 255, 255))

	for k, v in pairs(badges) do
		surface.SetMaterial(v.Material)
		surface.DrawTexturedRect(badgeX - (k * 18), badgeY, 16, 16)
	end
end

vgui.Register("eternity_scoreboardentry", PANEL, "eternity_panel")