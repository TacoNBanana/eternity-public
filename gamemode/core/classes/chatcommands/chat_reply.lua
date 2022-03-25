local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Reply"
CLASS.Description = "Replies to the last PM you received."

CLASS.Category = "PM"

CLASS.Commands = {"reply"}

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		local target = ply.ReplyTarget

		if not IsValid(target) then
			ply:SendChat("ERROR", "No targets found.")

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