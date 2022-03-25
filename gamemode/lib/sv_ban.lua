hook.Add("OnDBALConnected", "ban.OnDBALConnected", function(key)
	if key != "global" then
		return
	end

	dbal.RegisterTable("global", "bans", "bans", {
		id = {Type = "INT", PK = true, AI = true},
		SteamID = {Type = "VARCHAR(30)"},
		Realm = {Type = "VARCHAR(16)"},
		Reason = {Type = "VARCHAR(256)"},
		Admin = {Type = "VARCHAR(32)"},
		AdminSteamID = {Type = "VARCHAR(30)"},
		Timestamp = {Type = "INT UNSIGNED"},
		Length = {Type = "INT UNSIGNED"},
		Lifted = {Type = "BOOLEAN", Default = 0},
		Lifter = {Type = "VARCHAR(32)", Default = ""},
		LifterSteamID = {Type = "VARCHAR(30)", Default = ""}
	})
end)

module("ban", package.seeall)

Realm = ""

function SetRealm(realm)
	Realm = realm
end

function Add(steamid, length, by, reason, global)
	length = length or 0
	reason = (reason or #reason > 0) and reason or "No reason specified"

	local name = IsValid(by) and by:Nick() or "CONSOLE"

	dbal.Insert("global", "bans", {
		SteamID = steamid,
		Realm = global and "" or Realm,
		Timestamp = os.time(),
		Length = length,
		Reason = reason,
		Admin = name,
		AdminSteamID = IsValid(by) and by:SteamID() or "CONSOLE"
	})

	local target = player.GetBySteamID(steamid)

	if IsValid(target) then
		local str = (length == 0) and "Permanently banned" or "Banned for " .. string.NiceTime(length)

		str = string.format("%s by %s: %s", str, name, reason)

		game.KickID(steamid, str)
	end
end

function Lift(id, by)
	dbal.Update("global", "bans", {
		Lifted = 1,
		Lifter = IsValid(by) and by:Nick() or "CONSOLE",
		LifterSteamID = IsValid(by) and by:SteamID() or "CONSOLE"
	}, "id = ?", id)
end

function Get(steamid, active, global)
	local query = "SELECT * FROM $bans WHERE "
	local where = {}
	local args = {}

	if steamid then
		table.insert(where, "SteamID = ?")
		table.insert(args, steamid)
	end

	if active then
		table.insert(where, "((Timestamp + Length >= ? OR Length = 0) AND Lifted = 0)")
		table.insert(args, os.time())
	end

	if not global then
		table.insert(where, "(Realm = ?)")
		table.insert(args, Realm)
	end

	local res = dbal.Query("global", query .. table.concat(where, " AND "), unpack(args))
	local tab = {}

	for _, v in ipairs(res) do
		v.Expired = v.Length > 0 and (v.Timestamp + v.Length) < os.time() or false

		table.insert(tab, v)
	end

	return tab
end

function Check(steamid)
	local bans = Get(steamid, true)

	if #bans < 1 then
		return true
	end

	local perma = false
	local expire = 0
	local reason = ""
	local by = ""

	for _, v in pairs(bans) do
		if v.Length == 0 then
			perma = true
			reason = v.Reason
			by = v.Admin

			break
		elseif v.Timestamp + v.Length > expire then
			expire = v.Timestamp + v.Length
			reason = v.Reason
			by = v.Admin
		end
	end

	local str = perma and "Permanently banned" or string.format("Banned for %s", string.NiceTime(expire - os.time()))

	str = string.format("%s by %s: %s", str, by, reason)

	return false, str
end