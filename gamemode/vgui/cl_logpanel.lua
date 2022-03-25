local PANEL = {}

function PANEL:Init()
	local bottom3 = self:Add("eternity_panel")

	bottom3:DockMargin(0, 10, 0, 5)
	bottom3:Dock(BOTTOM)
	bottom3:SetTall(22)

	local bottom2 = self:Add("eternity_panel")

	bottom2:DockMargin(0, 10, 0, 0)
	bottom2:Dock(BOTTOM)
	bottom2:SetTall(22)

	local bottom1 = self:Add("eternity_panel")

	bottom1:DockMargin(0, 10, 0, 0)
	bottom1:Dock(BOTTOM)
	bottom1:SetTall(22)

	local dateLabel = bottom1:Add("eternity_label")

	dateLabel:DockMargin(5, 0, 5, 0)
	dateLabel:Dock(LEFT)
	dateLabel:SetWide(80)
	dateLabel:SetFont("eternity.labelmedium")
	dateLabel:SetText("Cutoff Date")

	self.DateEntry = bottom1:Add("eternity_textentry")
	self.DateEntry:DockMargin(0, 0, 5, 0)
	self.DateEntry:Dock(LEFT)
	self.DateEntry:SetWide(80)

	local timeLabel = bottom1:Add("eternity_label")

	timeLabel:DockMargin(95, 0, 5, 0)
	timeLabel:Dock(LEFT)
	timeLabel:SetWide(90)
	timeLabel:SetFont("eternity.labelmedium")
	timeLabel:SetText("Cutoff Time")

	self.TimeEntry = bottom1:Add("eternity_textentry")
	self.TimeEntry:DockMargin(0, 0, 5, 0)
	self.TimeEntry:Dock(LEFT)
	self.TimeEntry:SetWide(80)

	local categoryLabel = bottom2:Add("eternity_label")

	categoryLabel:DockMargin(5, 0, 5, 0)
	categoryLabel:Dock(LEFT)
	categoryLabel:SetWide(80)
	categoryLabel:SetFont("eternity.labelmedium")
	categoryLabel:SetText("Category")

	self.CategoryCombo = bottom2:Add("eternity_combobox")
	self.CategoryCombo:DockMargin(0, 0, 5, 0)
	self.CategoryCombo:Dock(LEFT)
	self.CategoryCombo:SetWide(160)

	local options = {
		{LOG_ADMIN, "Admin"},
		{LOG_SECURITY, "Security"},
		{LOG_SANDBOX, "Sandbox"},
		{LOG_ITEMS, "Items"},
		{LOG_CHARACTER, "Character"},
		{LOG_CHAT, "Chat"},
	}

	if LocalPlayer():IsDeveloper() then
		table.insert(options, {LOG_DEVELOPER, "Developer"})
	end

	for _, v in pairs(options) do
		self.CategoryCombo:AddChoice(v[2], v[1])
	end

	self.CategoryCombo.OnSelect = function(pnl, index, value, data)
		self:SetIdentifierChoices(data)
	end

	local identifierLabel = bottom3:Add("eternity_label")

	identifierLabel:DockMargin(5, 0, 5, 0)
	identifierLabel:Dock(LEFT)
	identifierLabel:SetWide(80)
	identifierLabel:SetFont("eternity.labelmedium")
	identifierLabel:SetText("Identifier")

	self.IdentifierCombo = bottom3:Add("eternity_combobox")
	self.IdentifierCombo:DockMargin(0, 0, 5, 0)
	self.IdentifierCombo:Dock(LEFT)
	self.IdentifierCombo:SetWide(160)

	local characterLabel = bottom2:Add("eternity_label")

	characterLabel:DockMargin(15, 0, 5, 0)
	characterLabel:Dock(LEFT)
	characterLabel:SetWide(90)
	characterLabel:SetFont("eternity.labelmedium")
	characterLabel:SetText("Character ID")

	self.CharacterEntry = bottom2:Add("eternity_textentry")
	self.CharacterEntry:DockMargin(0, 0, 5, 0)
	self.CharacterEntry:Dock(LEFT)
	self.CharacterEntry:SetWide(100)

	local itemLabel = bottom3:Add("eternity_label")

	itemLabel:DockMargin(15, 0, 5, 0)
	itemLabel:Dock(LEFT)
	itemLabel:SetWide(90)
	itemLabel:SetFont("eternity.labelmedium")
	itemLabel:SetText("Item ID")

	self.ItemEntry = bottom3:Add("eternity_textentry")
	self.ItemEntry:DockMargin(0, 0, 5, 0)
	self.ItemEntry:Dock(LEFT)
	self.ItemEntry:SetWide(100)

	local steamLabel = bottom2:Add("eternity_label")

	steamLabel:DockMargin(15, 0, 5, 0)
	steamLabel:Dock(LEFT)
	steamLabel:SetWide(70)
	steamLabel:SetFont("eternity.labelmedium")
	steamLabel:SetText("Steam ID")

	self.SteamEntry = bottom2:Add("eternity_textentry")
	self.SteamEntry:DockMargin(0, 0, 5, 0)
	self.SteamEntry:Dock(LEFT)
	self.SteamEntry:SetWide(100)

	local maxLabel = bottom3:Add("eternity_label")

	maxLabel:DockMargin(15, 0, 5, 0)
	maxLabel:Dock(LEFT)
	maxLabel:SetWide(70)
	maxLabel:SetFont("eternity.labelmedium")
	maxLabel:SetText("Max lines")

	self.MaxEntry = bottom3:Add("eternity_textentry")
	self.MaxEntry:DockMargin(0, 0, 5, 0)
	self.MaxEntry:Dock(LEFT)
	self.MaxEntry:SetWide(100)
	self.MaxEntry:SetText(GAMEMODE:GetConfig("DefaultLogs"))

	self.MaxEntry.AllowInput = function(pnl, val)
		if not string.find(val, "%d") then
			return true
		end
	end

	self.AutoFill = bottom1:Add("eternity_button")
	self.AutoFill:Dock(RIGHT)
	self.AutoFill:SetWide(100)
	self.AutoFill:SetText("Auto-fill cutoff")

	self.AutoFill.DoClick = function(pnl)
		self.DateEntry:SetValue(os.date("%Y-%m-%d"))
		self.TimeEntry:SetValue(os.date("%H:%M:%S"))
	end

	self.GetLogs = bottom2:Add("eternity_button")
	self.GetLogs:Dock(RIGHT)
	self.GetLogs:SetWide(100)
	self.GetLogs:SetText("Get Logs")
	self.GetLogs:SetDisabled(true)

	self.GetLogs.DoClick = function(pnl)
		self:SubmitRequest()
	end

	self.List = self:Add("eternity_listview")
	self.List:Dock(FILL)
	self.List:AddColumn("Timestamp"):SetFixedWidth(120)
	self.List:AddColumn("Identifier"):SetFixedWidth(120)
	self.List:AddColumn("Log")
	self.List:SetMultiSelect(false)

	local function getLine(line)
		local tab = {}

		for i = 1, 3 do
			tab[i] = line:GetValue(i)
		end

		return string.format("[%s] [%s] - %s", unpack(tab))
	end

	self.List.DoDoubleClick = function(pnl, id, line)
		print(getLine(line))
	end

	self.List.OnRowRightClick = function(pnl, id, line)
		local dmenu = EternityDermaMenu()

		dmenu:SetPos(gui.MousePos())
		dmenu.Think = function(menu)
			if not IsValid(self) then
				menu:Remove()
			end
		end

		dmenu:AddOption("Copy to clipboard", function()
			SetClipboardText(getLine(line))
		end)

		dmenu:AddOption("View raw data", function() GAMEMODE:OutputLogData(line.Data) end)
		dmenu:Open()
	end
end

function PANEL:GetCutoff()
	local year, month, day = string.match(self.DateEntry:GetValue(), "(%d+)-(%d+)-(%d+)")
	local hour, min, sec = string.match(self.TimeEntry:GetValue(), "(%d+):(%d+):(%d+)")

	-- Required for some reason
	if not year or not month or not day then
		return
	end

	return os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})
end

function PANEL:SetIdentifierChoices(category)
	self.IdentifierCombo:Clear()
	self.IdentifierCombo:AddChoice("Any", "", true)

	for k, v in pairs(GAMEMODE.LogTypes) do
		if v.Category == category then
			self.IdentifierCombo:AddChoice(k)
		end
	end

	self.GetLogs:SetDisabled(false)
end

function PANEL:SubmitRequest()
	local identifier = self.IdentifierCombo:GetSelected()
	local steamid = tostring(self.SteamEntry:GetText())

	netstream.Send("RequestLogs", {
		Category = select(2, self.CategoryCombo:GetSelected()),
		Identifier = identifier != "Any" and identifier or nil,
		CharID = tonumber(self.CharacterEntry:GetText()),
		ItemID = tonumber(self.ItemEntry:GetText()),
		SteamID = #steamid > 0 and steamid or nil,
		Limit = tonumber(self.MaxEntry:GetText()) or GAMEMODE:GetConfig("DefaultLogs"),
		Timestamp = self:GetCutoff()
	})
end

function PANEL:AddLog(identifier, timestamp, data)
	data = pon.decode(data)

	self.List:AddLine(os.date("%Y-%m-%d %H:%M:%S", timestamp), identifier, string.FirstToUpper(GAMEMODE:ParseLog(identifier, data))).Data = data
	self.List:SortByColumn(1, true)
end

vgui.Register("eternity_logpanel", PANEL, "eternity_panel")