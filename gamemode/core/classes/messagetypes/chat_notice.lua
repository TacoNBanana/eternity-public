local CLASS = class.Create("base_chatcommand")

CLASS.Name = "NOTICE"

if CLIENT then
	function CLASS:OnReceive(data, colors)
		return string.format("<col=%s>%s", util.ColorToChat(colors.Notice), data.Text)
	end
end

return CLASS