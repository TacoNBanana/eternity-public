local CLASS = class.Create("base_chatcommand")

CLASS.Name = "ERROR"

if CLIENT then
	function CLASS:OnReceive(data, colors)
		return string.format("<col=%s>Error: %s", util.ColorToChat(colors.Error), data.Text)
	end
end

return CLASS