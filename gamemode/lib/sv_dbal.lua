require("mysqloo")

module("dbal", package.seeall)

Connections = Connections or {}

function Connect(key, host, user, password, db, port)
	Disconnect(key)

	local conn = mysqloo.connect(host, user, password, db, port)
	local err

	function conn.onConnectionFailed(_, e)
		err = e
	end

	log.Default(string.format("[%s] Connecting to %s on %s@%s:%i", key, db, user, host, port))
	conn:connect()
	conn:wait()

	if err then
		error(err)
	else
		log.Default(string.format("[%s] Connected to %s on %s@%s:%i", key, db, user, host, port))

		Connections[key] = {
			Conn = conn,
			Aliases = {}
		}

		hook.Run("OnDBALConnected", key)
	end
end

function Disconnect(key)
	if Connections[key] then
		Connections[key].Conn:disconnect(true)
		Connections[key] = nil
	end
end

function SetErrorSuppression(key, val)
	if Connections[key] then
		Connections[key].NoError = val
	end
end

function GetConnection(key)
	return Connections[key].Conn
end

function GetAliases(key)
	return Connections[key].Aliases
end

function Escape(key, val)
	if isbool(val) then
		return val and 1 or 0
	elseif isnumber(val) then
		return val
	elseif val == nil or val == NULL then
		return "NULL"
	elseif isfunction(val) then
		local info = debug.getinfo(val)

		error(string.format("Attempt to escape function value (%s:%i)", info.source, info.linedefined))
	end

	return string.format("'%s'", GetConnection(key):escape(tostring(val)))
end

function FormatAlias(key, str)
	return string.gsub(str, "$([a-z]+)", GetAliases(key))
end

function FormatQuery(key, query, ...)
	query = FormatAlias(key, query)

	local args = {...}
	local i = 0

	local function repl()
		i = i + 1

		return Escape(key, args[i])
	end

	return string.gsub(query, "%?", repl)
end

function Query(key, str, ...)
	local query, index = FormatQuery(key, str, ...)

	index = index + 1

	local args = {...}
	local cb = args[index]

	if cb and not isfunction(cb) then
		error(string.format("Callback is not a function, got %s (%s) instead", type(cb), cb))
	end

	return RawQuery(key, query, unpack(args, index))
end

function Insert(key, name, data, ignore, cb, ...)
	name = FormatAlias(key, name)

	local cols = {}

	for k, v in SortedPairs(data) do
		table.insert(cols, k)
	end

	local vals = {}

	for _, v in ipairs(cols) do
		table.insert(vals, Escape(key, data[v]))
	end

	local rows = string.format("(%s)", table.concat(vals, ", "))
	local query = string.format("INSERT%s INTO %s (%s) VALUES %s", ignore and " IGNORE" or "", name, table.concat(cols, ", "), rows)

	return RawQuery(key, query, cb, ...)
end

function Update(key, name, data, where, ...)
	name = FormatAlias(key, name)

	local cols = {}
	local args = {...}

	for k, v in pairs(data) do
		table.insert(cols, string.format("`%s` = %s", k, Escape(key, v)))
	end

	cols = table.concat(cols, ", ")

	if where then
		where, index = FormatQuery(key, where, ...)
		where = string.format(" WHERE %s", where)

		index = index + 1
	end

	local query = string.format("UPDATE %s SET %s%s", name, cols, where or "")

	return RawQuery(key, query, unpack(args, index))
end

local function HandleError(key, err)
	if Connections[key].NoError then
		return false, err
	else
		error(err)
	end
end

function RawQuery(key, str, cb, ...)
	local conn = GetConnection(key)
	local query = conn:query(str)
	local args = {...}

	if GetConVar("debug_sql"):GetBool() then
		log.Default(string.format("[%s] %s", key, str))
	end

	if not query then
		if cb then
			cb(HandleError(key, string.format("Failed to create query object (%s)", str)))
		else
			return HandleError(key, string.format("Failed to create query object (%s)", str))
		end
	end

	function query:onError(err)
		if cb then
			cb(HandleError(key, string.format("Query failed: %s (%s)", str, err)))
		else
			return HandleError(key, string.format("Query failed: %s (%s)", str, err))
		end
	end

	function query:onAborted()
		if cb then
			cb(HandleError(key, string.format("Query aborted: %s", str)))
		else
			return HandleError(key, string.format("Query aborted: %s", str))
		end
	end

	if cb then
		function query:onSuccess()
			cb(self:getData(), unpack(args))
		end

		query:start()
	else
		local cr = coroutine.running()

		if not cr then
			query:start()
			query:wait()

			local err = query:error()

			if #err > 0 then
				return HandleError(key, string.format("Query failed: %s (%s)", str, err))
			else
				return query:getData()
			end
		end

		function query:onSuccess()
			local data = self:getData()

			data.LastInsert = self:lastInsert()

			local ok, res = coroutine.resume(cr, data)

			if not ok then
				print(debug.traceback(cr, res))

				return
			end
		end

		query:start()

		return coroutine.yield()
	end
end

local function FormatColumn(name, data)
	if data.PK then
		local auto = data.AI and " auto_increment" or ""

		return string.format("%s %s NOT NULL%s", name, data.Type, auto)
	else
		local default = data.Default and string.format(" DEFAULT '%s'", data.Default) or ""
		local null = data.AllowNull and "" or "NOT NULL"

		return string.format("ADD COLUMN %s %s %s%s", name, data.Type, null, default)
	end
end

function RegisterTable(key, name, alias, data)
	local column_names = {}
	local column_data = {}

	local pk_names = {}
	local pk_data = {}

	for column, v in pairs(data) do
		if v.PK then
			table.insert(pk_names, column)
			table.insert(pk_data, FormatColumn(column, v))
		else
			table.insert(column_names, column)
			table.insert(column_data, FormatColumn(column, v))
		end
	end

	RawQuery(key, string.format("CREATE TABLE IF NOT EXISTS %s (%s, PRIMARY KEY (%s))", name, table.concat(pk_data, ", "), table.concat(pk_names, ", ")))

	local exists = {}

	for _, column in ipairs(RawQuery(key, "SHOW COLUMNS FROM " .. name)) do
		exists[column.Field] = true
	end

	for k, column in pairs(column_names) do
		if exists[column] then
			continue
		end

		local query = string.format("ALTER TABLE %s %s", name, column_data[k])

		RawQuery(key, query)
	end

	GetAliases(key)[alias] = name
end