local meta = FindMetaTable("Player")

function meta:HiddenFromScoreboard()
	if not TEAMS[self:Team()] then
		return false
	end

	return TEAMS[self:Team()].Hidden or self:Hidden()
end

function meta:CanSeeOnScoreboard()
	if self == LocalPlayer() or LocalPlayer():IsAdmin() then
		return true
	end

	return not self:HiddenFromScoreboard()
end

hook.Add("InitPostEntity", "player.InitPostEntity", function()
	netstream.Send("RequestCharacters")

	GAMEMODE:OpenGUI("Chat")
	GAMEMODE:OpenGUI("ChatRadio")
end)