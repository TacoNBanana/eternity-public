local CLASS = class.Create("chat_radio")

CLASS.Name = "Radio whisper"
CLASS.Description = "Whisper into your radio if you have one."

CLASS.Commands = {"rw"}

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Whisper
CLASS.MuffledRange = false

CLASS.PlainType = "Whisper"
CLASS.Tabs = TAB_RADIO

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local lang = data.Lang != 1
		local color = lang and colors.Language or colors.Radio
		local freq = data.Frequency

		color = util.ColorToChat(self:ApplyChatFocus(data.Ply, color))

		if freq >= 1000 then
			for _, v in pairs(CHANNELS) do
				if freq == v.Frequency then
					freq = v.Name

					break
				end
			end
		else
			freq = string.format("%s MHz", freq)
		end

		local text

		if lang then
			local name = LANGUAGES[data.Lang].Name

			if LocalPlayer():CanHearLanguage(data.Lang) then
				text = string.format("[%s] [%s] %s: %s", freq, name, data.Name, data.Text)
			else
				text = string.format("[%s] %s whispers something in %s.", freq, data.Name, form, name)
			end
		else
			text = string.format("[%s] %s: %s", freq, data.Name, data.Text)
		end

		GAMEMODE:GetGUI("ChatRadio"):AddMessage("<i>" .. text)

		return string.format("<col=%s><i>%s", color, text)
	end
end

return CLASS