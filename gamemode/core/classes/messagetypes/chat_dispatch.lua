local CLASS = class.Create("base_chatcommand")

CLASS.Name = "DISPATCH"

CLASS.Tabs = TAB_RADIO

if CLIENT then
	function CLASS:OnReceive(data, colors)
		GAMEMODE:GetGUI("ChatRadio"):AddMessage("[DISPATCH] " .. data.Text)

		return string.format("<col=%s>[DISPATCH] %s", util.ColorToChat(colors.Radio), data.Text)
	end
end

return CLASS