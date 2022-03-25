local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Local Event"
CLASS.Description = "Describe a local event."

CLASS.Category = "Events"

CLASS.Commands = {"lev"}
CLASS.Indicator = CHATINDICATOR_TYPING

local config = GAMEMODE:GetConfig("ChatRanges")

CLASS.Range = config.Yell

CLASS.Logged = "EVENT"
CLASS.Tabs = TAB_IC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local color = util.ColorToChat(colors.LocalEvent)

		return string.format("<col=%s>[EVENT] ** %s **", color, data.Text), string.format("<col=%s>[L] (%s) ** %s **", color, data.Name, data.Text)
	end
end

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		if not ply:IsAdmin() and not ply:HasPermission(PERMISSION_EVENTS) then
			ply:SendChat("ERROR", "You need to be an admin to do this.")

			return true
		end

		return {
			Name = ply:RPName(),
			Text = text
		}
	end
end

return CLASS