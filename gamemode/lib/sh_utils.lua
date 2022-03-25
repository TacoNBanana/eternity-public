stub = function() end

function string.Filename(path)
	return string.StripExtension(string.GetFileFromFilename(path))
end

function string.FirstToUpper(str)
	return string.gsub(str, "^%l", string.upper)
end

function math.ApproachSpeed(start, dest, speed)
	return math.Approach(start, dest, math.abs(start - dest) / speed)
end

function math.ApproachVectorSpeed(start, dest, speed)
	return Vector(
		math.ApproachSpeed(start.x, dest.x, speed),
		math.ApproachSpeed(start.y, dest.y, speed),
		math.ApproachSpeed(start.z, dest.z, speed)
	)
end

function math.ApproachAngleSpeed(start, dest, speed)
	return Angle(
		math.ApproachSpeed(start.p, dest.p, speed),
		math.ApproachSpeed(start.y, dest.y, speed),
		math.ApproachSpeed(start.r, dest.r, speed)
	)
end

function coroutine.WrapFunc(func)
	coroutine.wrap(func)()
end

function math.InRange(val, min, max)
	return val >= min and val <= max
end

function math.ClampAngle(val, min, max)
	return Angle(
		math.Clamp(val.p, min.p, max.p),
		math.Clamp(val.y, min.y, max.y),
		math.Clamp(val.r, min.r, max.r)
	)
end

function math.ClampedRemap(val, frommin, frommax, tomin, tomax)
	return math.Clamp(math.Remap(val, frommin, frommax, tomin, tomax), math.min(tomin, tomax), math.max(tomin, tomax))
end

function table.MakeAssociative(tab)
	local ret = {}

	for _, v in pairs(tab) do
		ret[v] = true
	end

	return ret
end

function table.Unique(tab)
	return table.GetKeys(table.MakeAssociative(tab))
end

function util.IsValidSteamID(steamid) -- Thanks Ulib
	return string.match(steamid, "^STEAM_%d:%d:%d+$") != nil
end

function game.GetPort()
	return string.Explode(":", game.GetIPAddress())[2]
end

function util.ColorToChat(color)
	return string.format("%s,%s,%s", color.r, color.g, color.b)
end

function table.FullCopy(tab)
	local res = {}

	for k, v in pairs(tab) do
		if type(v) == "table" then
			res[k] = table.FullCopy(v)
		elseif type(v) == "Vector" then
			res[k] = Vector(v.x, v.y, v.z)
		elseif type(v) == "Angle" then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end

	return res
end

function table.Filter(tab, callback)
	local pointer = 1

	for i = 1, #tab do
		if callback(i, tab[i]) then
			if i != pointer then
				tab[pointer] = tab[i]
				tab[i] = nil
			end

			pointer = pointer + 1
		else
			tab[i] = nil
		end
	end

	return tab
end

function player.GetUsergroup(usergroup)
	local tab = player.GetAll()

	return table.Filter(tab, function(key, val)
		return val:AdminLevel() >= usergroup
	end)
end

function game.GetMaps()
	local maps = file.Find("maps/*.bsp", "GAME", "namedesc")
	local tab = {}

	for _, v in pairs(maps) do
		local mapname, _ = string.gsub(v, ".bsp", "")

		table.insert(tab, mapname)
	end

	return tab
end

-- Shouldn't be used for stuff that needs to persist between restarts or needs to be networked
function util.UID()
	g_UID = g_UID or 0
	g_UID = g_UID + 1

	return g_UID
end

function string.Clean(str)
	return string.gsub(str, "[^\32-\127]", "")
end

function file.GetSafePath(path)
	path = string.match(path, "(.*)%.txt$")

	return string.gsub(string.gsub(path, "[^\32-\126]", ""), "[^%w-_/]", "_") .. ".txt"
end

function file.AppendSafe(path, str)
	path = file.GetSafePath(path)

	local dir = string.GetPathFromFilename(path)

	if not file.Exists(dir, "DATA") then
		file.CreateDir(dir)
	end

	local handle = file.Open(path, "a", "DATA")

	if not handle then
		return
	end

	handle:Write(str .. "\n")
	handle:Close()
end

function string.Escape(str)
	str = string.gsub(str, ">", "&gt;")
	str = string.gsub(str, "<", "&lt;")
	str = string.Trim(str)

	return str
end

function string.Unescape(str)
	str = string.gsub(str, "&gt;", ">")
	str = string.gsub(str, "&lt;", "<")

	return str
end

function string.Gibberish(str, prob)
	local ret = ""

	for _, v in pairs(string.Explode("", str)) do
		if math.random(1, 100) < prob then
			v = ""

			for i = 1, math.random(0, 2) do
				ret = ret .. table.Random({"#", "@", "&", "%", "$", "/", "<", ">", ";", "*", "*", "*", "*", "*", "*", "*", "*"})
			end
		end

		ret = ret .. v
	end

	return ret
end

function ColorToHex(color)
	local tab = {color.r, color.g, color.b}
	local hexadecimal = "0X"

	for key, value in pairs(tab) do
		local hex = ""

		while value > 0 do
			local index = math.fmod(value, 16) + 1

			value = math.floor(value / 16)
			hex = string.sub("0123456789ABCDEF", index, index) .. hex
		end

		if string.len(hex) == 0 then
			hex = "00"
		elseif string.len(hex) == 1 then
			hex = "0" .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end