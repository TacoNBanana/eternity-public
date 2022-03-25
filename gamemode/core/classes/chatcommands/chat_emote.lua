local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Emote"
CLASS.Description = "Perform an action."

CLASS.Category = "Emotes"

CLASS.Commands = {"me"}
CLASS.Indicator = CHATINDICATOR_TYPING

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Speak
CLASS.MuffledRange = config.Whisper

CLASS.Logged = "EMOTE"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local color = util.ColorToChat(self:ApplyChatFocus(data.Ply, colors.Emote))
		local text = data.Text

		if not string.match(text, "^[,.']") then
			text = " " .. text
		end

		return string.format("<col=%s>** %s%s", color, data.Name, text)
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