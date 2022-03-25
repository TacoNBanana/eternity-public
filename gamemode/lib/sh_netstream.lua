module("netstream", package.seeall)

Hooks = Hooks or {}
Cache = Cache or {}

MessageLimit 	= 60000 -- 60 KB
TickLimit 		= 200000 -- 0.2 MB/s

local function Split(data)
	local encoded = Encode(data)

	if #encoded <= MessageLimit then
		return {{Data = encoded, Len = #encoded}}
	end

	local result = {}
	local amount = math.ceil(#encoded / MessageLimit)

	for i = 1, amount do
		local buffer = string.sub(encoded, MessageLimit * (i - 1) + 1, MessageLimit * i)

		result[i] = {Data = buffer, Len = #buffer}
	end

	return result
end

function Encode(data)
	return pon.encode(data or {})
end

function Decode(encoded)
	return pon.decode(encoded)
end

function Hook(name, cb, validation)
	Hooks[name] = {Callback = cb, Validation = validation}
	Cache[name] = {}
end

function Validate(data, validation)
	if not validation then
		return data
	end

	local tab = {}

	for k, v in pairs(validation) do
		local val = data[k]
		local typeid = TypeID(val)

		if typeid == TYPE_NIL and v.Optional then
			continue
		end

		if v.Type != true then
			if istable(v.Type) then
				local bad = true

				for _, check in pairs(v.Type) do
					if typeid == check then
						bad = false

						break
					end
				end

				if bad then
					return false, k
				end
			elseif typeid != v.Type then
				return false, k
			end
		end

		tab[k] = data[k]
	end

	return tab
end

if CLIENT then
	function Send(name, data)
		local payloads = Split(data)

		for k, v in pairs(payloads) do
			net.Start("netstream")
				net.WriteString(name)
				net.WriteBool(k == #payloads)
				net.WriteUInt(v.Len, 16)
				net.WriteData(v.Data, v.Len)
			net.SendToServer()
		end
	end

	net.Receive("netstream", function(len)
		local name = net.ReadString()

		if not Hooks[name] then
			return
		end

		local final = net.ReadBool()
		local length = net.ReadUInt(16)
		local payload = net.ReadData(length)

		local cache = Cache[name]

		table.insert(cache, payload)

		if final then
			local hooks = Hooks[name]
			local data = Decode(table.concat(cache))

			table.Empty(cache)

			local validated = Validate(data, hooks.Validation)

			if not validated then
				return
			end

			coroutine.wrap(hooks.Callback)(validated)
		end
	end)
end

if SERVER then
	util.AddNetworkString("netstream")

	Queue = Queue or {}
	Rate = Rate or {}

	local function GetTargets(targets)
		local result = targets

		if not targets then
			result = player.GetAll()
		elseif TypeID(targets) == TYPE_RECIPIENTFILTER then
			result = targets:GetPlayers()
		elseif not istable(targets) then
			result = {targets}
		end

		return result
	end

	local function AddToQueue(name, final, payload, targets)
		local tab = {
			Name = name,
			Final = final,
			Length = payload.Len,
			Data = payload.Data
		}

		for _, v in pairs(targets) do
			if not Queue[v] then
				Queue[v] = queue.New()
			end

			Queue[v]:Push(tab)
		end
	end

	function Send(name, data, targets)
		targets = GetTargets(targets)

		if #targets < 1 then
			return
		end

		local payloads = Split(data)

		for k, v in pairs(payloads) do
			AddToQueue(name, k == #payloads, v, targets)
		end
	end

	net.Receive("netstream", function(len, ply)
		local name = net.ReadString()

		if not Hooks[name] then
			return
		end

		local final = net.ReadBool()
		local length = net.ReadUInt(16)
		local payload = net.ReadData(length)

		local cache = Cache[name]

		if not cache[ply] then
			cache[ply] = {}
		end

		table.insert(cache[ply], payload)

		if final then
			local hooks = Hooks[name]
			local data = Decode(table.concat(cache[ply]))

			table.Empty(cache[ply])

			local validated, field = Validate(data, hooks.Validation)

			if not validated then
				if GetConVar("debug_netstream"):GetBool() then
					log.Default(string.format("[Netstream] REJECTED %s FROM %s ON %s", name, ply, field))
				end

				return
			end

			coroutine.wrap(hooks.Callback)(ply, validated)
		end
	end)

	hook.Add("Think", "netstream", function()
		for k, v in pairs(Queue) do
			if not IsValid(k) then
				Queue[k] = nil
				Rate[k] = nil

				continue
			end

			if Queue[k]:Count() < 1 then
				continue
			end

			Rate[k] = Rate[k] or TickLimit
			Rate[k] = math.Min(Rate[k] + (TickLimit * FrameTime()), TickLimit)

			while Rate[k] - MessageLimit > 0 do
				local payload = v:Pop()

				if not payload then
					break
				end

				net.Start("netstream")
					net.WriteString(payload.Name)
					net.WriteBool(payload.Final)
					net.WriteUInt(payload.Length, 16)
					net.WriteData(payload.Data, payload.Length)

					Rate[k] = Rate[k] - net.BytesWritten()
				net.Send(k)
			end
		end
	end)
end