local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Say"
CLASS.Description = "Speak. (Default if no command is given)"

CLASS.Category = "Speech"

CLASS.Commands = {"say"}
CLASS.Indicator = CHATINDICATOR_TYPING

CLASS.UseLanguage = true

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Speak
CLASS.MuffledRange = config.Whisper

CLASS.Logged = "IC"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local lang = data.Lang != 1
		local color = lang and colors.Language or colors.IC

		color = util.ColorToChat(self:ApplyChatFocus(data.Ply, color))

		if lang then
			local langtab = LANGUAGES[data.Lang]

			if LocalPlayer():CanHearLanguage(data.Lang) then
				return string.format("<col=%s>[%s] %s: %s", color, langtab.Name, data.Name, data.Text)
			else
				local char = string.Right(data.Text, 1)
				local form = "says"

				if char == "?" then
					form = "asks"
				elseif char == "!" then
					form = "exclaims"
				end

				return string.format("<col=%s>%s %s something in %s.", color, data.Name, form, langtab.Unknown or langtab.Name)
			end
		else
			return string.format("<col=%s>%s: %s", color, data.Name, data.Text)
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