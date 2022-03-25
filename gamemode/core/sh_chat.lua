local emeta = FindMetaTable("Entity")

GM.MessageTypes = GM.MessageTypes or {}
GM.ChatCommands = GM.ChatCommands or {}

hook.Add("Initialize", "chat.Initialize", function()
	GAMEMODE:LoadChat()
end)

hook.Add("OnReloaded", "chat.OnReloaded", function()
	if CLIENT then
		local buffer = GAMEMODE:GetGUI("Chat"):ExportBuffer()

		GAMEMODE:OpenGUI("Chat"):ImportBuffer(buffer)
		GAMEMODE:OpenGUI("ChatRadio")
	end

	GAMEMODE:LoadChat()
end)

function GM:LoadChat()
	local paths = {
		"classes/chatcommands/",
		"classes/messagetypes/"
	}

	for _, path in pairs(paths) do
		local files = file.Find(includes.CurrentFolder(2) .. path .. "*", "LUA")

		for _, v in SortedPairsByValue(files) do
			local tab = includes.File(includes.CurrentFolder(2) .. path .. v)
			local classname = string.Filename(v)

			class.Register(classname, tab)

			local instance = class.Instance(classname)

			for _, command in pairs(instance.Commands) do
				self.ChatCommands[command] = instance
			end

			self.MessageTypes[instance.Name] = instance
		end
	end
end

function emeta:CanHear(pos)
	return util.TraceLine({
		start = self:IsPlayer() and self:EyePos() or self:WorldSpaceCenter(),
		endpos = pos,
		filter = self,
		mask = MASK_OPAQUE
	}).Fraction == 1
end

function GM:GetChatTargets(pos, range, muffledrange, allowentities)
	local max = math.max(range, muffledrange)
	local tab = {}

	for _, v in pairs(ents.FindInSphere(pos, max)) do
		if not v:IsPlayer() and (not allowentities or not v.OnHear) then
			continue
		end

		local dist = v:GetPos():Distance(pos)

		if v:CanHear(pos) then
			if dist <= max then
				table.insert(tab, v)
			end
		else
			if dist <= muffledrange then
				table.insert(tab, v)
			end
		end
	end

	return tab
end