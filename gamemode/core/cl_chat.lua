function GM:IsChatTarget(target)
	if LocalPlayer() == target then
		return false
	end

	if self:GetSetting("chat_targetfocus") and LocalPlayer():GetEyeTrace().Entity == target then
		return true
	elseif self:GetSetting("chat_receivefocus") and target:GetEyeTrace().Entity == LocalPlayer() then
		return true
	end

	return false
end

function GM:ParseChatString(str)
	local lang, cmd, args

	for k, v in pairs(self:GetConfig("ChatAliases")) do
		if string.find(str, k, 1, true) == 1 then
			str = v .. " " .. string.sub(str, #k + 1)

			break
		end
	end

	lang, cmd, args = string.match(str, "^[/!](%w+)%.(%w+)%s*(.-)%s*$")

	if not lang then
		lang = LocalPlayer():ActiveLanguage()
		cmd, args = string.match(str, "^[/!](%w+)%s*(.-)%s*$")

		if not cmd then
			cmd, args = "say", string.Trim(str)
		end
	else
		lang = self:LanguageFromCommand(lang)
	end

	return lang, string.lower(cmd), args
end

function GM:ParseChat(str)
	local lang, cmd, args = self:ParseChatString(str)
	local configs = GAMEMODE:GetConfig("ConsoleAliases")

	if configs[cmd] then
		RunConsoleCommand(configs[cmd], args)

		return
	end

	netstream.Send("ParseChat", {
		Lang = lang,
		Cmd = cmd,
		Args = args
	})
end

function GM:UpdateTypingIndicator(str)
	local index = CHATINDICATOR_NONE

	if str and #str > 0 then
		local _, cmd, args = self:ParseChatString(str)
		local command = GAMEMODE.ChatCommands[cmd]

		if command and #args > 1 then
			index = command.Indicator
		end
	end

	if index == LocalPlayer():Typing() then
		return
	end

	netstream.Send("SetTypingIndicator", {
		Index = index
	})
end

function GM:AddChat(str, console, tabs)
	self:GetGUI("Chat"):AddMessage(str, console, tabs)
end

function GM:ProcessChat(type, data)
	local command = GAMEMODE.MessageTypes[type]

	if not command then
		return
	end

	if isstring(data) then
		data = {Text = data}
	end

	local val, console = command:OnReceive(data, GAMEMODE:GetConfig("ChatColors"))

	if isstring(val) then
		GAMEMODE:AddChat(val, console, command.Tabs)
	end
end

function GM:SendChat(classname, data)
	if isstring(data) then
		data = {Text = data}
	end

	self:ProcessChat(classname, data)
end

netstream.Hook("SendChat", function(data)
	GAMEMODE:ProcessChat(data.__Type, data)
end)