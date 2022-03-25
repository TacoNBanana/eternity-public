local CLASS = class.Create("base_chatcommand")

CLASS.Name = "OOC"
CLASS.Description = "Global out-of-character."

CLASS.Category = "OOC"

CLASS.Commands = {"ooc"}
CLASS.Indicator = CHATINDICATOR_TYPING

CLASS.Logged = "OOC"
CLASS.Tabs = TAB_OOC

if CLIENT then
	function CLASS:OnReceive(data, colors)
		return string.format("<col=%s>[OOC]</col> <tc=%s>%s</tc>: %s", util.ColorToChat(colors.OOC), data.UserID, data.Name, data.Text)
	end
end

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		if ply:OOCMuted() then
			ply:SendChat("ERROR", "You are muted from OOC.")

			return true
		end

		local delay = GAMEMODE:OOCDelay()

		if not ply:IsAdmin() and delay > 0 then
			local time = (ply.LastOOC or 0) + delay

			if time > CurTime() then
				ply:SendChat("ERROR", string.format("You need to wait %s to talk in OOC.", string.NiceTime(time - CurTime())))

				return true
			end
		end

		ply.LastOOC = CurTime()

		return {
			UserID = ply:UserID(),
			Name = ply:RPName(),
			Text = text
		}
	end
end

return CLASS