local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Yell"
CLASS.Description = "Yell."

CLASS.Category = "Speech"

CLASS.Commands = {"y"}
CLASS.Indicator = CHATINDICATOR_TYPING

CLASS.UseLanguage = true

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Yell
CLASS.MuffledRange = config.Speak

CLASS.Logged = "IC"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local lang = data.Lang != 1
		local color = lang and colors.Language or colors.Yell

		color = util.ColorToChat(self:ApplyChatFocus(data.Ply, color))

		if lang then
			local name = LANGUAGES[data.Lang].Name

			if LocalPlayer():CanHearLanguage(data.Lang) then
				return string.format("<col=%s><b>(%s) %s: [YELL] %s", color, name, data.Name, data.Text)
			else
				return string.format("<col=%s><b>%s yells something in %s!", color, data.Name, name)
			end
		else
			return string.format("<col=%s><b>%s: [YELL] %s", color, data.Name, data.Text)
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