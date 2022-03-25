local CLASS = class.Create("base_chatcommand")

CLASS.Name = "PM"
CLASS.Description = "Sends a private message to a specific player."

CLASS.Category = "PM"

CLASS.Commands = {"pm"}
CLASS.Tabs = TAB_PM

if CLIENT then
	function CLASS:OnReceive(data, colors)
		local format = "<col=%s>[PM %s %s] %s"
		local direction = "from"

		if data.Sent then
			direction = "to"
		end

		return string.format(format, util.ColorToChat(colors.PM), direction, data.Name, data.Text)
	end
end

function CLASS:OnCreated()
	GAMEMODE:RegisterLogType("chat_pm", LOG_CHAT, ParseChatLog)
end

if SERVER then
	function CLASS:Split(str)
		local quote = str[1] != '"'
		local args = {}

		for k in string.gmatch(str, "[^\"]+") do
			quote = not quote

			if quote then
				table.insert(args, k)
			else
				for v in string.gmatch(k, "%S+") do
					table.insert(args, v)
				end
			end
		end

		return args
	end

	function CLASS:Parse(ply, cmd, text, lang)
		local split = self:Split(text)

		if not split[1] then
			ply:SendChat("ERROR", "No targets found.")

			return true
		end

		local ok, target = GAMEMODE:FindPlayer(ply, split[1], table.MakeAssociative({CFLAG_FORCESINGLETARGET, CFLAG_NOSELFTARGET}))

		table.remove(split, 1)

		text = table.concat(split, " ")

		if not ok then
			ply:SendChat("ERROR", target)

			return true
		end

		target.ReplyTarget = ply

		ply:SendChat("PM", {Sent = true, Text = text, Name = target:RPName()})
		target:SendChat("PM", {Text = text, Name = ply:RPName()})

		GAMEMODE:WriteLog("chat_pm", {
			__Type = "PM",
			FromPly = GAMEMODE:LogPlayer(ply),
			FromChar = GAMEMODE:LogCharacter(ply),
			ToPly = GAMEMODE:LogPlayer(target),
			ToChar = GAMEMODE:LogCharacter(target),
			Text = text
		})

		return true
	end
end

return CLASS