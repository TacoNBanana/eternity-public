local PANEL = {}

local height = draw.GetFontHeight("eternity.chatradio")
local maxheight = height * 10

function PANEL:Init()
	self:SetWide(600)
	self:SetHeight(maxheight)

	self.BufferSize = 0
	self.Buffer = {}
end

function PANEL:AddMessage(str)
	local data = {
		Markup = markleft.Parse("<font=eternity.chatradio><ol=1>" .. str, 600),
		ReceiveTime = CurTime()
	}

	table.insert(self.Buffer, data)
	self.BufferSize = self.BufferSize + data.Markup:GetHeight()

	while self.BufferSize > maxheight do
		local line = table.remove(self.Buffer, 1)

		self.BufferSize = self.BufferSize - line.Markup:GetHeight()
	end
end

function PANEL:Paint(w, h)
	if not GAMEMODE:GetSetting("chatradio_enabled") then
		return true
	end

	local y = h - 3

	for i = #self.Buffer, 1, -1 do
		local data = self.Buffer[i]
		local lifetime = CurTime() - data.ReceiveTime
		local alpha = 255

		if lifetime >= 15 then
			break -- All other messages are assumed to be older, no need to iterate them
		else
			alpha = (15 - lifetime) * 0.2 * 255
		end

		y = y - data.Markup:GetHeight()

		data.Markup:Draw(5, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha)

		if h - y > maxheight then
			break
		end
	end

	return true
end

derma.DefineControl("eternity_chatradio", "", PANEL, "EditablePanel")

GM:RegisterGUI("ChatRadio", function()
	local pnl = vgui.Create("eternity_chatradio")

	pnl:CopyPos(GAMEMODE:GetGUI("Chat"))
	pnl:MoveAbove(GAMEMODE:GetGUI("Chat"), 10)

	return pnl
end, true)