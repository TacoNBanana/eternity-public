local meta = FindMetaTable("Player")

hook.Add("Initialize", "sql.Initialize", function()
	local config = GAMEMODE:GetConfig("SQL")
	local global = GAMEMODE:GetConfig("GlobalSQL")
	local prometheus = GAMEMODE:GetConfig("PrometheusSQL")

	dbal.Connect("eternity", config.Host, config.User, config.Password, config.DB, config.Port)
	dbal.Connect("global", global.Host, global.User, global.Password, global.DB, global.Port)

	if GAMEMODE:GetConfig("Prometheus").Enabled then
		dbal.Connect("prometheus", prometheus.Host, prometheus.User, prometheus.Password, prometheus.DB, prometheus.Port)
	end
end)

hook.Add("OnDBALConnected", "sql.OnDBALConnected", function(key)
	if key != "eternity" then
		return
	end

	local chardata = {
		id = {Type = "INT", PK = true, AI = true},
		SteamID = {Type = "VARCHAR(30)"},
		Deleted = {Type = "BIT(1)", Default = ""}
	}

	for k, v in pairs(GAMEMODE.CharacterAccessors) do
		chardata[k] = {Type = v.Storetype, Default = v.Default}

		if v.Storetype == "TEXT" then
			chardata[k].Default = nil
			chardata[k].AllowNull = true
		end
	end

	dbal.RegisterTable("eternity", "characters", "chars", chardata)

	local playerdata = {
		SteamID = {Type = "VARCHAR(30)", PK = true}
	}

	for k, v in pairs(GAMEMODE.PlayerAccessors) do
		playerdata[k] = {Type = v.Storetype, Default = v.Default}

		if v.Storetype == "TEXT" then
			playerdata[k].Default = nil
			playerdata[k].AllowNull = true
		end
	end

	dbal.RegisterTable("eternity", "players", "players", playerdata)

	dbal.RegisterTable("eternity", "items", "items", {
		id = {Type = "INT", PK = true, AI = true},
		Class = {Type = "VARCHAR(256)"},
		StoreType = {Type = "INT", Default = 0},
		StoreID = {Type = "INT", Default = 0},
		StoreName = {Type = "VARCHAR(256)", Default = ""},
		StorePos = {Type = "TEXT", AllowNull = true},
		CustomData = {Type = "TEXT", AllowNull = true},
		ParentID = {Type = "INT", AllowNull = true}
	})

	dbal.SetErrorSuppression("eternity", true)
	dbal.Query("eternity", "ALTER TABLE $items ADD CONSTRAINT FK_ParentID FOREIGN KEY (ParentID) REFERENCES $items(id) ON DELETE CASCADE")
	dbal.SetErrorSuppression("eternity", false)

	dbal.RegisterTable("eternity", "worldentitites", "worldents", {
		id = {Type = "INT", PK = true, AI = true},
		Class = {Type = "VARCHAR(256)"},
		MapName = {Type = "VARCHAR(256)"},
		MapPos = {Type = "TEXT", AllowNull = true},
		CustomData = {Type = "TEXT", AllowNull = true}
	})

	dbal.RegisterTable("eternity", "mapdata", "mapdata", {
		Map = {Type = "VARCHAR(256)", PK = true},
		DataType = {Type = "VARCHAR(256)", PK = true},
		Data = {Type = "TEXT", AllowNull = true}
	})

	dbal.RegisterTable("eternity", "logs", "logs", {
		id = {Type = "INT", PK = true, AI = true},
		Category = {Type = "INT"},
		Identifier = {Type = "VARCHAR(64)"},
		Data = {Type = "TEXT", AllowNull = true},
		Timestamp = {Type = "INT"}
	})

	dbal.RegisterTable("eternity", "logs_characters", "logchars", {
		logid = {Type = "INT", PK = true},
		charid = {Type = "INT", PK = true}
	})

	dbal.RegisterTable("eternity", "logs_items", "logitems", {
		logid = {Type = "INT", PK = true},
		itemid = {Type = "INT", PK = true}
	})

	dbal.RegisterTable("eternity", "logs_players", "logplayers", {
		logid = {Type = "INT", PK = true},
		steamid = {Type = "VARCHAR(30)", PK = true}
	})

	dbal.SetErrorSuppression("eternity", true)
	dbal.Query("eternity", "ALTER TABLE $logchars ADD CONSTRAINT FK_charid FOREIGN KEY (logid) REFERENCES $logs(id) ON DELETE CASCADE")
	dbal.Query("eternity", "ALTER TABLE $logitems ADD CONSTRAINT FK_charid FOREIGN KEY (logid) REFERENCES $logs(id) ON DELETE CASCADE")
	dbal.Query("eternity", "ALTER TABLE $logplayers ADD CONSTRAINT FK_charid FOREIGN KEY (logid) REFERENCES $logs(id) ON DELETE CASCADE")
	dbal.SetErrorSuppression("eternity", false)
end)

netstream.Hook("RequestCharacters", function(ply)
	local data = dbal.Query("eternity", "SELECT id, RPName, Species from $chars WHERE SteamID = ? AND Deleted = 0", ply:SteamID())
	local characters = {}

	for _, v in ipairs(data) do
		characters[v.id] = {RPName = v.RPName, Species = v.Species}
	end

	if not IsValid(ply) then
		return
	end

	ply:SetCharacters(characters)
	ply:LoadPlayer()

	playerreg.Update(ply)
	playerreg.StartTimer(ply)

	ply:OpenGUI("CharSelect")
end, {})

function meta:SaveCharacterAccessor(key, value)
	if self.SuppressCharacterChanges then
		return
	end

	if value == nil then
		value = GAMEMODE.CharacterAccessors[key].Default
	end

	dbal.Update("eternity", "$chars", {[key] = value}, "id = ?", self:CharID(), stub)
end

function meta:SavePlayerAccessor(key, value)
	if self.SuppressPlayerChanges then
		return
	end

	if value == nil then
		value = GAMEMODE.PlayerAccessors[key].Default
	end

	dbal.Update("eternity", "$players", {[key] = value}, "SteamID = ?", self:SteamID(), stub)
end

function meta:LoadPlayer()
	local data = dbal.Query("eternity", "SELECT * FROM $players WHERE SteamID = ?", self:SteamID())[1]

	self.SuppressPlayerChanges = true

	for k, v in pairs(data) do
		local accessor = GAMEMODE.PlayerAccessors[k]

		if accessor then
			if accessor.Storetype == "BOOLEAN" then
				v = tobool(v)
			end

			self["Set" .. k](self, v)
		end
	end

	self.SuppressPlayerChanges = false
	self:SetPlayerLoaded(true)

	hook.Run("PostPlayerLoad", self)
end

function GM:GetMapData(index)
	local tab = dbal.Query("eternity", "SELECT Data FROM $mapdata WHERE Map = ? AND DataType = ?", string.lower(game.GetMap()), index)[1]

	if tab then
		return pon.decode(tab.Data)
	else
		return {}
	end
end

function GM:SaveMapData(index, data)
	coroutine.WrapFunc(function()
		local map = string.lower(game.GetMap())

		data = pon.encode(data)

		-- Attempt to insert first, in-case the row doesn't exist yet
		dbal.Insert("eternity", "$mapdata", {Map = map, DataType = index}, true)
		dbal.Update("eternity", "$mapdata", {Data = data}, "Map = ? AND DataType = ?", string.lower(game.GetMap()), index)
	end)
end