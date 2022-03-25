local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Whisper"
CLASS.Description = "Whisper."

CLASS.Category = "Speech"

CLASS.Commands = {"w"}
CLASS.Indicator = CHATINDICATOR_TYPING

CLASS.UseLanguage = true

CLASS.Range = GAMEMODE:GetConfig("ChatRanges").Whisper

CLASS.Logged = "IC"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local lang = data.Lang != 1
		local color = lang and colors.Language or colors.IC

		color = util.ColorToChat(self:ApplyChatFocus(data.Ply, color))

		if lang then
			local name = LANGUAGES[data.Lang].Name

			if LocalPlayer():CanHearLanguage(data.Lang) then
				return string.format("<col=%s><i>(%s) %s: [WHISPER] %s", color, name, data.Name, data.Text)
			else
				return string.format("<col=%s><i>%s whispers something in %s.", color, data.Name, name)
			end
		else
			return string.format("<col=%s><i>%s: [WHISPER] %s", color, data.Name, data.Text)
		end
	end
end

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		return {
			Ply = ply,
			Name = ply:RPName(),
			Text = text,
			Lang = lang
		}
	end
end

return CLASS