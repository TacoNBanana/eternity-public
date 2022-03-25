local CLASS = class.Create("base_chatcommand")

CLASS.Name = "ADMINYELL"

function CLASS:OnCreated()
	GAMEMODE:RegisterLogType("chat_ayell", LOG_CHAT, ParseChatLog)
end

if CLIENT then
	function CLASS:OnReceive(data, colors)
		return string.format("<font=eternity.labelmassive>%s: <col=%s>%s", data.Name, util.ColorToChat(colors.Angry), data.Text), string.format("<font=eternity.labelmassive>%s: [ANGRY] <col=%s>%s", data.Name, util.ColorToChat(colors.Angry), data.Text)
	end
end

return CLASS