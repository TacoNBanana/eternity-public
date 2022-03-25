ban.SetRealm(GM:GetConfig("BanRealm"))

function GM:GetOfflineUsergroup(steamid)
	local usergroup = dbal.Query("eternity", "SELECT AdminLevel FROM $players WHERE SteamID = ?", steamid)

	return usergroup[1] and usergroup[1].AdminLevel or USERGROUP_PLAYER
end

function GM:CheckPassword(steam64, ip, sv, cl, nick)
	local steamid = util.SteamIDFrom64(steam64)

	if self.MapOverride then
		RunConsoleCommand("changelevel", self.MapOverride)

		self.MapOverride = false
	end

	if #sv > 0 and sv != cl then
		self:WriteLog("security_password", {
			Ply = self:LogPlayerRaw(nick, steamid)
		})

		return false
	end

	coroutine.WrapFunc(function()
		dbal.Insert("eternity", "$players", {SteamID = steamid}, true)

		local config = self:GetConfig("PrivateMode")
		local usergroup = self:GetOfflineUsergroup(steamid)

		if usergroup < config then
			self:WriteLog("security_private", {
				Ply = self:LogPlayerRaw(nick, steamid),
				Given = usergroup,
				Required = config
			})

			game.KickID(steamid, "This server is currently locked to whitelisted users, sorry!")

			return
		end

		local good, reason = ban.Check(steamid)

		if not good then
			self:WriteLog("security_banned", {
				Ply = self:LogPlayerRaw(nick, steamid)
			})

			game.KickID(steamid, reason)
		end
	end)

	return true
end