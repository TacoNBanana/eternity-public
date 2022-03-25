function GM:OutputLogData(data)
	for k, v in pairs(data) do
		local val

		if istable(v) then
			if not v._meta then
				continue
			end

			if v._meta == META_CHAR then
				val = GAMEMODE:FormatCharacter(v)
			elseif v._meta == META_ITEM then
				val = GAMEMODE:FormatItem(v)
			elseif v._meta == META_PLY then
				val = GAMEMODE:FormatPlayer(v)
			end
		else
			val = v
		end

		print(k .. "\t=\t" .. string.FirstToUpper(tostring(val)))
	end
end

netstream.Hook("SendLogs", function(data)
	local ui = GAMEMODE:GetGUI("AdminMenu")

	if not IsValid(ui) or ui.Active != "Logs" then
		return
	end

	ui.Logs.List:Clear()

	for _, v in pairs(data) do
		ui.Logs:AddLog(v.Identifier, v.Timestamp, v.Data)
	end
end)