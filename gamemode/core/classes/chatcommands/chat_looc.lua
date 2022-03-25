local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Local OOC"
CLASS.Description = "Local out-of-character."

CLASS.Category = "OOC"

CLASS.Commands = {"looc"}
CLASS.Indicator = CHATINDICATOR_TYPING

CLASS.Range = GAMEMODE:GetConfig("ChatRanges").Speak

CLASS.Logged = "OOC"
CLASS.Tabs = TAB_LOOC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local color = util.ColorToChat(self:ApplyChatFocus(data.Ply, colors.LOOC))

		return string.format("<col=%s>%s: [LOCAL-OOC] %s", color, data.Name, data.Text)
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