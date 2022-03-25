local meta = FindMetaTable("Player")

function meta:SendChat(classname, data)
	GAMEMODE:SendChat(classname, data, self)
end

function GM:SendChat(classname, data, targets)
	if isstring(data) then
		data = {Text = data}
	end

	data.__Type = classname

	netstream.Send("SendChat", data, targets)
end

function meta:VisibleMessage(message, force)
	if self:IsInNoClip() and not force then
		return
	end

	local range = GAMEMODE:GetConfig("ChatRanges").Speak
	local targets = GAMEMODE:GetChatTargets(self:EyePos(), range, 0)

	GAMEMODE:SendChat("NOTICE", message, targets)
end

GM.JammedCommon = false
GM.JammedFrequencies = {}

function GM:IsRadioJammed(freq)
	if self.JammedCommon and freq < 1000 then
		return true
	end

	return self.JammedFrequencies[freq] or false
end

function GM:GetRadioTargets(origin, frequency, key, range, muffled, hearable)
	local targets = {}
	local plaintargets = {}
	local badtargets = {}

	local jammed = self:IsRadioJammed(frequency)
	local jammedtarget = jammed and badtargets or targets

	if IsValid(origin) then
		table.insert(jammedtarget, origin)

		local pos = origin:WorldSpaceCenter()

		if origin:IsPlayer() then
			pos = origin:EyePos()
		end

		plaintargets = table.Add(plaintargets, self:GetChatTargets(pos, range or 0, muffled or 0, hearable))
	end

	for _, v in pairs(player.GetAll()) do
		if v:GetSetting("admin_radio") then
			table.insert(jammedtarget, v)

			continue
		end

		local item = v:GetEquipment(EQUIPMENT_RADIO)

		if not item then
			continue
		end

		local hear, clear, speaker = item:CanHearFrequency(v, frequency, key)

		if not hear then
			continue
		end

		local nearby

		if speaker then
			nearby = self:GetChatTargets(v:EyePos(), range or 0, muffled or 0, hearable)
		end

		if clear and not jammed then
			table.insert(targets, v)

			if speaker then
				targets = table.Add(targets, nearby)
			end
		else
			table.insert(badtargets, v)

			if speaker then
				badtargets = table.Add(badtargets, nearby)
			end
		end
	end

	if IsValid(origin) then
		table.Filter(plaintargets, function(_, val) return val != origin end)
	end

	targets = table.Unique(targets)
	plaintargets = table.MakeAssociative(plaintargets)
	badtargets = table.MakeAssociative(badtargets)

	for v in pairs(plaintargets) do
		if badtargets[v] then
			badtargets[v] = nil
		end
	end

	for _, v in pairs(targets) do
		if badtargets[v] then
			badtargets[v] = nil
		end

		if plaintargets[v] then
			plaintargets[v] = nil
		end
	end

	plaintargets = table.GetKeys(plaintargets)
	badtargets = table.GetKeys(badtargets)

	return targets, plaintargets, badtargets
end

function GM:SendDispatchMessage(message, frequency)
	local config = self:GetConfig("ChatRanges")
	local targets, _, badtargets = self:GetRadioTargets(nil, frequency or 1000, nil, config.Speak, config.Whisper, false)

	if #targets > 0 then
		local tab = {
			__Type = "DISPATCH",
			Text = message
		}

		netstream.Send("SendChat", tab, targets)
	end

	if #badtargets > 0 then
		local tab = {
			__Type = "DISPATCH",
			Text = string.Gibberish(message, 50)
		}

		netstream.Send("SendChat", tab, badtargets)
	end
end

hook.Add("PlayerSay", "chat.PlayerSay", function(ply, text, t)
	return ""
end)

netstream.Hook("ParseChat", function(ply, data)
	local cmd = data.Cmd
	local command = GAMEMODE.ChatCommands[cmd]

	if not command then
		GAMEMODE:SendChat("ERROR", string.format("Unknown command '%s'!", cmd), ply)

		return
	end

	command:Handle(ply, data.Lang, cmd, data.Args)
end, {
	Cmd = {Type = TYPE_STRING},
	Lang = {Type = TYPE_NUMBER},
	Args = {Type = TYPE_STRING}
})

netstream.Hook("SetTypingIndicator", function(ply, data)
	local index = math.Clamp(data.Index, 0, #CHATINDICATORS)

	ply:SetTyping(index)
end, {
	Index = {Type = TYPE_NUMBER}
})