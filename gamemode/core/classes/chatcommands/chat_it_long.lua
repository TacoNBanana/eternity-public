local CLASS = class.Create("base_chatcommand")

CLASS.Name = "It (Long)"
CLASS.Description = "Describe something from a 3rd person perspective. (Extended range)"

CLASS.Category = "Emotes"

CLASS.Commands = {"lit"}
CLASS.Indicator = CHATINDICATOR_TYPING

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Yell
CLASS.MuffledRange = config.Speak
CLASS.CastRange = config.Speak

CLASS.Logged = "EMOTE"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local color = util.ColorToChat(self:ApplyChatFocus(data.Ply, colors.Emote))

		return string.format("<col=%s>** %s **", color, data.Text), string.format("<col=%s>[L](%s) ** %s **", color, data.Name, data.Text)
	end
end

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		return {
			Ply = ply,
			Name = ply:RPName(),
			Text = text
		}
	end
end

return CLASS