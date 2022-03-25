hook.Add("OnDBALConnected", "playerreg.OnDBALConnected", function(key)
	if key != "global" then
		return
	end

	dbal.RegisterTable("global", "playerreg", "reg", {
		SteamID = {Type = "VARCHAR(30)", PK = true},
		LastNick = {Type = "VARCHAR(32)"},
		LastIP = {Type = "INT UNSIGNED"},
		FirstOn = {Type = "INT"},
		LastOn = {Type = "INT"},
		PlayTime = {Type = "INT", Default = 0}
	})

	dbal.RegisterTable("global", "playerreg_ips", "reg_ips", {
		SteamID = {Type = "VARCHAR(30)", PK = true},
		IP = {Type = "INT UNSIGNED", PK = true},
		Timestamp = {Type = "INT"}
	})

	dbal.RegisterTable("global", "playerreg_nicks", "reg_nicks", {
		SteamID = {Type = "VARCHAR(30)", PK = true},
		Nick = {Type = "VARCHAR(32)", PK = true},
		Timestamp = {Type = "INT"}
	})

	dbal.RegisterTable("global", "playerreg_gameids", "reg_gameids", {
		SteamID = {Type = "VARCHAR(30)", PK = true},
		GameID = {Type = "INT", PK = true},
		Timestamp = {Type = "INT"}
	})

	dbal.RegisterTable("global", "playerreg_lenders", "reg_lenders", {
		SteamID = {Type = "VARCHAR(30)", PK = true},
		Lender = {Type = "VARCHAR(32)", PK = true},
		Timestamp = {Type = "INT"}
	})

	dbal.SetErrorSuppression("global", true)
	dbal.Query("global", "CREATE INDEX SteamID ON $reg_ips (SteamID)")
	dbal.Query("global", "CREATE INDEX SteamID ON $reg_nicks (SteamID)")
	dbal.Query("global", "CREATE INDEX SteamID ON $reg_gameids (SteamID)")
	dbal.Query("global", "CREATE INDEX SteamID ON $reg_lenders (SteamID)")
	dbal.SetErrorSuppression("global", false)
end)

local function ip2num(ip)
	if ip == "loopback" then
		ip = "127.0.0.1"
	end

	local a, b, c, d = string.match(ip, "^(%d+)%.(%d+)%.(%d+)%.(%d+):?%d-$")

	return (a * 256 ^ 3) + (b * 256 ^ 2) + (c * 256) + d
end

local function num2ip(num)
	local a = bit.rshift(num, 24)
	local b = bit.band(bit.rshift(num, 16), 0xFF)
	local c = bit.band(bit.rshift(num, 8), 0xFF)
	local d = bit.band(num, 0xFF)

	return string.format("%i.%i.%i.%i", a, b, c, d)
end

local function send(ply, format, ...)
	local str = ""

	if format then
		str = string.format(format, ...)
	end

	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, str)
	else
		log.Default(str)
	end
end

local function timesince(old)
	if old == 0 then
		return "LEGACY"
	end

	return string.NiceTime(os.time() - old) .. " ago"
end

local function filter(key, tab)
	local steamids = {}
	local new = {}
	local matches = {}

	for _, v in ipairs(tab) do
		if steamids[v.SteamID] then
			matches[v.SteamID][v[key]] = true

			continue
		end

		matches[v.SteamID] = {}
		matches[v.SteamID][v[key]] = true

		table.insert(new, v)

		steamids[v.SteamID] = true
	end

	for k, v in pairs(matches) do
		matches[k] = table.GetKeys(v)
	end

	return new, matches
end

local min = 1103760000 -- 23 December 2004 12:00 AM UTC
local client = [[
	local id = math.Max(file.Time("bin/holly.dll", "MOD"), file.Time("bin/libholly.dylib", "MOD"))

	netstream.Send("GameID", {
		GameID = id
	})
]]

module("playerreg", package.seeall)

function Update(ply)
	local steamid = ply:SteamID()
	local ip = ip2num(ply:IPAddress())
	local nick = string.Clean(ply:Nick())
	local timestamp = os.time()

	dbal.Insert("global", "$reg", {SteamID = steamid, LastNick = nick, LastIP = ip, FirstOn = timestamp, LastOn = timestamp}, true)

	dbal.Query("global", "INSERT INTO $reg_ips (SteamID, IP, Timestamp) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE Timestamp = ?", steamid, ip, timestamp, timestamp)
	dbal.Query("global", "INSERT INTO $reg_nicks (SteamID, Nick, Timestamp) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE Timestamp = ?", steamid, nick, timestamp, timestamp)

	dbal.Update("global", "$reg", {LastNick = nick, LastIP = ip, LastOn = timestamp}, "SteamID = ?", steamid)

	ply:SendLua(client)

	local key = GAMEMODE:GetConfig("APIKey")

	if #key > 0 then
		local url = string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", key, ply:SteamID64())
		local ok, body = chttp.Get(url)

		if not ok then
			return
		end

		local json = util.JSONToTable(body)
		local lender = json.response.lender_steamid

		if lender == "0" then
			return
		end

		dbal.Query("global", "INSERT INTO $reg_lenders (SteamID, Lender, Timestamp) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE Timestamp = ?", ply:SteamID(), util.SteamIDFrom64(lender), timestamp, timestamp)
	end
end

Timers = Timers or {}

function StartTimer(ply)
	local userid = ply:UserID()

	Timers[userid] = {
		SteamID = ply:SteamID(),
		PlayTimer = os.time()
	}

	timer.Create("PlayerReg-" .. userid, 60, 0, function()
		if not IsValid(ply) then
			StopTimer(userid)

			return
		end

		UpdateTimer(userid)
	end)
end

function StopTimer(userid)
	timer.Remove("PlayerReg-" .. userid)

	UpdateTimer(userid)
end

function UpdateTimer(userid)
	local tab = Timers[userid]

	if not tab then
		return
	end

	local time = os.time() - tab.PlayTimer

	tab.PlayTimer = os.time()

	dbal.Query("global", "UPDATE $reg SET PlayTime = PlayTime + ? WHERE SteamID = ?", time, tab.SteamID, stub)
end

function Exists(steamid)
	return tobool(dbal.Query("global", "SELECT * FROM $reg WHERE SteamID = ?", steamid)[1])
end

function GetData(ply, steamid)
	local data = dbal.Query("global", "SELECT * FROM $reg WHERE SteamID = ?", steamid)[1]

	send(ply, "----------------------------------------------------")
	send(ply, "Registry data for %s:", data.SteamID)
	send(ply, "----------------------------------------------------")
	send(ply, "  Nickname: %s", data.LastNick)
	send(ply, "  Steam profile: https://steamcommunity.com/profiles/%s", util.SteamIDTo64(data.SteamID))
	send(ply, "  IP: %s", num2ip(data.LastIP))
	send(ply, "  First connection: %s", timesince(data.FirstOn))
	send(ply, "  Last connection: %s", timesince(data.LastOn))
	send(ply, "  Play time: %s", string.NiceTime(data.PlayTime))

	local good, reason = ban.Check(data.SteamID)
	if not good then
		send(ply, "  %s", reason)
	end

	send(ply, "  ----------------")
	send(ply, "  IP Addresses:")
	send(ply, "  ----------------")

	for _, v in ipairs(dbal.Query("global", "SELECT IP, Timestamp FROM $reg_ips WHERE SteamID = ?", steamid)) do
		send(ply, "    %s - %s", num2ip(v.IP), timesince(v.Timestamp))
	end

	send(ply, "  ----------------")
	send(ply, "  Nicknames:")
	send(ply, "  ----------------")

	for _, v in ipairs(dbal.Query("global", "SELECT Nick, Timestamp FROM $reg_nicks WHERE SteamID = ?", steamid)) do
		send(ply, "    %s - %s", v.Nick, timesince(v.Timestamp))
	end

	send(ply, "  ----------------")
	send(ply, "  Characters (HL2):")
	send(ply, "  ----------------")

	for _, v in ipairs(dbal.Query("eternity", "SELECT RPName FROM $chars WHERE SteamID = ? AND Deleted = 0", steamid)) do
		send(ply, "    %s", v.RPName)
	end


	send(ply, "  ----------------")
	send(ply, "  Game ID's:")
	send(ply, "  ----------------")

	for _, v in ipairs(dbal.Query("global", "SELECT GameID, Timestamp FROM $reg_gameids WHERE SteamID = ?", steamid)) do
		send(ply, "    %s - %s", v.GameID, timesince(v.Timestamp))
	end

	local lenders = dbal.Query("global", "SELECT Lender, Timestamp FROM $reg_lenders WHERE SteamID = ?", steamid)

	if #lenders > 0 then
		send(ply, "  ----------------")
		send(ply, "  Lenders:")
		send(ply, "  ----------------")

		for _, v in ipairs(lenders) do
			send(ply, "    %s - %s", v.Lender, timesince(v.Timestamp))
		end
	end
end

function GetByIP(ply, steamid)
	local query = "SELECT i.IP, r.SteamID, r.LastIP, r.LastNick, r.FirstOn, r.LastOn, r.PlayTime FROM $reg r LEFT JOIN $reg_ips i ON i.SteamID = r.SteamID WHERE i.SteamID <> ? AND i.IP IN (SELECT IP FROM $reg_ips WHERE SteamID = ?)"
	local data, matches = filter("IP", dbal.Query("global", query, steamid, steamid))

	for _, v in pairs(matches) do
		for k, ip in pairs(v) do
			v[k] = num2ip(ip)
		end
	end

	send(ply, "----------------------------------------------------")
	send(ply, "Players matching IP's with %s:", steamid)
	send(ply, "----------------------------------------------------")

	for k, v in pairs(data) do
		if k != 1 then
			send(ply, "  --------------------------------")
		end

		send(ply, "  Matches: %s", table.concat(matches[v.SteamID], ", "))
		send(ply, "    SteamID: %s", v.SteamID)
		send(ply, "    IP: %s", num2ip(v.LastIP))
		send(ply, "    Nickname: %s", v.LastNick)
		send(ply, "    Steam profile: https://steamcommunity.com/profiles/%s", util.SteamIDTo64(v.SteamID))
		send(ply, "    First connection: %s", timesince(v.FirstOn))
		send(ply, "    Last connection: %s", timesince(v.LastOn))
		send(ply, "    Play time: %s", string.NiceTime(v.PlayTime))

		local good, reason = ban.Check(v.SteamID)
		if not good then
			send(ply, "    %s", reason)
		end
	end
end

function GetByGameID(ply, steamid)
	local query = "SELECT g.GameID, r.SteamID, r.LastIP, r.LastNick, r.FirstOn, r.LastOn, r.PlayTime FROM $reg r LEFT JOIN $reg_gameids g ON g.SteamID = r.SteamID WHERE g.SteamID <> ? AND g.GameID IN (SELECT GameID FROM $reg_gameids WHERE SteamID = ?)"
	local data, matches = filter("GameID", dbal.Query("global", query, steamid, steamid))

	send(ply, "----------------------------------------------------")
	send(ply, "Players matching GameID's with %s:", steamid)
	send(ply, "----------------------------------------------------")

	for k, v in pairs(data) do
		if k != 1 then
			send(ply, "  --------------------------------")
		end

		send(ply, "  Matches: %s", table.concat(matches[v.SteamID], ", "))
		send(ply, "    SteamID: %s", v.SteamID)
		send(ply, "    IP: %s", num2ip(v.LastIP))
		send(ply, "    Nickname: %s", v.LastNick)
		send(ply, "    Steam profile: https://steamcommunity.com/profiles/%s", util.SteamIDTo64(v.SteamID))
		send(ply, "    First connection: %s", timesince(v.FirstOn))
		send(ply, "    Last connection: %s", timesince(v.LastOn))
		send(ply, "    Play time: %s", string.NiceTime(v.PlayTime))

		local good, reason = ban.Check(v.SteamID)
		if not good then
			send(ply, "    %s", reason)
		end
	end
end

netstream.Hook("GameID", function(ply, data)
	local steamid = ply:SteamID()
	local timestamp = os.time()

	if data.GameID < min then
		-- Log

		game.KickID("Invalid game ID provided")

		return
	end

	dbal.Query("global", "INSERT INTO $reg_gameids (SteamID, GameID, Timestamp) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE Timestamp = ?", steamid, data.GameID, timestamp, timestamp)
end)

hook.Add("PlayerDisconnected", "playerreg.PlayerDisconnected", function(ply)
	StopTimer(ply:UserID())
end)
