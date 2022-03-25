local modes = {
	{Default = true, Func = playerreg.GetData},
	{Name = "ip", Func = playerreg.GetByIP},
	{Name = "gameid", Func = playerreg.GetByGameID}
}

console.AddCommand("reg", function(ply, steamid, mode)
	if not playerreg.Exists(steamid) then
		Feedback(ply, "This SteamID isn't registered!", "ERROR")

		return
	end

	if mode == "all" then
		for _, v in pairs(modes) do
			v.Func(ply, steamid)
		end

		return
	end

	local found = false

	for _, v in pairs(modes) do
		if (mode == "" and v.Default) or v.Name == mode then
			found = true

			v.Func(ply, steamid)

			break
		end
	end

	if not found then
		Feedback(ply, "Invalid mode.", "ERROR")
	end
end, COMMAND_DEV, {CTYPE_STEAMID, CTYPE_STRING})