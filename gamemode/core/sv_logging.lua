function GM:WriteLog(identifier, data)
	local logtype = self.LogTypes[identifier]

	if not logtype then
		error(string.format("Invalid log identifier: %s", identifier))
	end

	local time = os.time()
	local func = function()
		local id = dbal.Insert("eternity", "$logs", {
			Category = logtype.Category,
			Identifier = identifier,
			Data = pon.encode(data),
			Timestamp = time
		}).LastInsert

		local charcache = {}
		local itemcache = {}
		local plycache = {}

		for _, v in pairs(data) do
			if not istable(v) or not v._meta then
				continue
			end

			if v._meta == META_CHAR and not charcache[v.CharID] then
				charcache[v.CharID] = true

				dbal.Insert("eternity", "$logchars", {logid = id, charid = v.CharID})
			elseif v._meta == META_ITEM and not itemcache[v.ItemID] then
				itemcache[v.ItemID] = true

				dbal.Insert("eternity", "$logitems", {logid = id, itemid = v.ItemID})
			elseif v._meta == META_PLY and v.SteamID and not plycache[v.SteamID] then
				plycache[v.SteamID] = true

				dbal.Insert("eternity", "$logplayers", {logid = id, steamid = v.SteamID})
			end
		end

		if GetConVar("debug_logs"):GetBool() then
			log.Default(string.format("[%s] [%s] - %s", os.date("%Y-%m-%d %H:%M:%S", time), identifier, GAMEMODE:ParseLog(identifier, data)))
		end
	end

	if not coroutine.running() then
		coroutine.WrapFunc(func)
	else
		func()
	end
end

function GM:LogCharacter(ply)
	return {
		_meta = META_CHAR,
		CharID = ply:CharID(),
		CharName = ply:RPName(),
		RPName = ply:RPName()
	}
end

function GM:LogItem(item)
	local tab = {
		_meta = META_ITEM,
		ItemClass = item:GetClassName(),
		ItemID = item.NetworkID,
		Amount = item:IsTypeOf("base_stacking") and item.Stack or nil
	}

	return tab
end

function GM:LogPlayer(ply)
	local tab = {
		_meta = META_PLY,
	}

	if ply == NULL then
		tab.Nick = "CONSOLE"
	elseif isstring(ply) then
		tab.Nick = ply
	else
		tab.Nick = ply:Nick()
		tab.SteamID = ply:SteamID()
	end

	return tab
end

function GM:LogPlayerRaw(nick, steamid)
	return {
		_meta = META_PLY,
		Nick = nick,
		SteamID = steamid
	}
end

function GM:ReadLogs(filters)
	local join = ""
	local where = ""
	local args = {}

	local filtertypes = {
		Category = {" AND $logs.Category = ?"},
		Identifier = {" AND $logs.Identifier = ?"},
		CharID = {" AND $logchars.charid = ?", "JOIN $logchars ON $logs.id = $logchars.logid"},
		ItemID = {" AND $logitems.itemid = ?", "JOIN $logitems ON $logs.id = $logitems.logid"},
		SteamID = {" AND $logplayers.steamid = ?", "JOIN $logplayers ON $logs.id = $logplayers.logid"},
		Timestamp = {" AND $logs.Timestamp < ?"}
	}

	for k, v in pairs(filters) do
		local tab = filtertypes[k]
		if tab then
			where = where .. tab[1]

			table.insert(args, v)

			if tab[2] then
				join = string.format("%s\n%s", join, tab[2])
			end
		end
	end

	local query = string.format([[
	SELECT
		$logs.Identifier,
		$logs.Timestamp,
		$logs.Data
	FROM $logs%s
	WHERE
		1=1%s
	ORDER BY $logs.id DESC
	LIMIT ?]], join, where)

	table.insert(args, filters.Limit)

	local data = dbal.Query("eternity", query, unpack(args))

	data.LastInsert = nil

	return data
end

netstream.Hook("RequestLogs", function(ply, data)
	if not ply:IsAdmin() then
		return
	end

	local tab = {
		Category = data.Category,
		Identifier = data.Identifier,
		CharID = data.CharID,
		ItemID = data.ItemID,
		SteamID = (data.SteamID and util.IsValidSteamID(data.SteamID)) and data.SteamID or nil,
		Limit = math.Clamp(data.Limit, 1, GAMEMODE:GetConfig("MaxLogs")),
		Timestamp = data.Timestamp
	}

	netstream.Send("SendLogs", GAMEMODE:ReadLogs(tab), ply)
end, {
	Category = {Type = TYPE_NUMBER},
	Identifier = {Type = TYPE_STRING, Optional = true},
	CharID = {Type = TYPE_NUMBER, Optional = true},
	ItemID = {Type = TYPE_NUMBER, Optional = true},
	SteamID = {Type = TYPE_STRING, Optional = true},
	Limit = {Type = TYPE_NUMBER},
	Timestamp = {Type = TYPE_NUMBER, Optional = true}
})