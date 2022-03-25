local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Admin"
CLASS.Description = "Sends a message to every admin online."

CLASS.Category = "OOC"

CLASS.Commands = {"a"}

CLASS.Logged = "Admin"
CLASS.Tabs = TAB_ADMIN

if CLIENT then
	function CLASS:OnReceive(data, colors)
		if LocalPlayer():IsAdmin() then
			if not data.Ply:IsAdmin() then
				data.Text = string.format("! %s", data.Text)
			end

			return string.format("<col=%s>%s:</col> <col=%s>[ADMIN] %s", util.ColorToChat(colors.AdminName), data.Name, util.ColorToChat(colors.AdminText), data.Text)
		else
			return string.format("<col=%s>%s:</col> <col=%s>[TO ADMINS] %s", util.ColorToChat(colors.AdminName), data.Name, util.ColorToChat(colors.AdminText), data.Text)
		end
	end
end

if SERVER then
	function CLASS:GetTargets(ply, data)
		local targets = {ply}

		targets = table.Add(targets, player.GetUsergroup(USERGROUP_ADMIN))

		return table.Unique(targets)
	end

	function CLASS:Parse(ply, cmd, text, lang)
		return {
			Ply = ply,
			Name = string.format("%s (%s)", ply:RPName(), ply:Nick()),
			Text = text
		}
	end
end

return CLASS