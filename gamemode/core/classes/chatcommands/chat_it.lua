local CLASS = class.Create("base_chatcommand")

CLASS.Name = "It"
CLASS.Description = "Describe something from a 3rd person perspective."

CLASS.Category = "Emotes"

CLASS.Commands = {"it"}
CLASS.Indicator = CHATINDICATOR_TYPING

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Speak
CLASS.MuffledRange = config.Whisper

CLASS.Logged = "EMOTE"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local color = util.ColorToChat(self:ApplyChatFocus(data.Ply, colors.Emote))

		return string.format("<col=%s>** %s **", color, data.Text), string.format("<col=%s>(%s) ** %s **", color, data.Name, data.Text)
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