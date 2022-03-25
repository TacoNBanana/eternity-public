GM.LogTypes = GM.LogTypes or {}

function GM:RegisterLogType(identifier, category, parser)
	self.LogTypes[identifier] = {Category = category or LOG_NONE, Parser = parser}
end

function GM:ParseLog(identifier, data)
	if not self.LogTypes[identifier] then
		return string.format("** INVALID LOG TYPE: %s **", identifier)
	end

	return string.FirstToUpper(self.LogTypes[identifier].Parser(data))
end

function GM:FormatPlayer(tab)
	if not tab.SteamID then
		return tab.Nick
	end

	return string.format("%s [%s]", tab.Nick, tab.SteamID)
end

function GM:FormatCharacter(tab)
	return string.format("%s [%s]", tab.CharName, tab.CharID)
end

function GM:FormatItem(tab)
	if tab.Amount then
		return string.format("%s [%s][x%s]", tab.ItemClass, tab.ItemID, tab.Amount)
	else
		return string.format("%s [%s]", tab.ItemClass, tab.ItemID)
	end
end

function ParseChatLog(data)
	local format = ""
	local args = {}

	local function add(str, ...)
		format = format .. str

		for _, v in pairs({...}) do
			table.insert(args, v)
		end
	end

	add("[%s]", data.__Type)

	if data.Lang and data.Lang != LANG_ENG then
		add("[%s]", LANGUAGES[data.Lang].Name)
	end

	if data.Frequency then
		local freq = data.Frequency

		if freq >= 1000 then
			for _, v in pairs(CHANNELS) do
				if freq == v.Frequency then
					freq = v.Name

					break
				end
			end
		else
			freq = string.format("%s MHz", freq)
		end

		add("[%s]", freq)
	end

	if data.__Type == "PM" then
		add(" %s -> %s:", data.FromChar.RPName, data.ToChar.RPName)
	else
		add(" %s:", data.Name)
	end

	add(" %s", data.Text)

	return string.format(format, unpack(args))
end