local help = {
	Credits = [[<b>Eternity</b>
Created and adapted for Halo RP by TankNut

<b>Special thanks to:</b>
	Bennet
	Drewerth
	Gangleider
	Hoplite

<b>Patreon supporters:</b>
	Alan Bernard
	Anri
	Artemis
	Beets
	Bekah
	Best of Boxes
	Biscuits
	Brealaran
	Bungo
	Cato
	Chad
	DiBen
	Drewerth
	Feelsgoodman
	FlatPancake
	Ghost
	Goldcrate
	Gunnerstrip
	Hawkins
	Koumakan
	Levinx
	Menofcrest
	Midas
	Nec
	Nerdbird
	Newticus
	PenguinXD
	Pew
	Sareth
	Shinzokk
	Sinclair
	SkitZ
	Sleeves
	Somedude
	Thecatwhomines
	Ventrum
	Waptnt

Based loosely on CombineControl by Disseminate]],
	["Console commands"] = function(ply)
		local str = ""
		local categories = {}

		for k, v in pairs(console.Commands) do
			if console.HasAccess(ply, v.Access) then
				if not categories[v.Category] then
					categories[v.Category] = {}
				end

				categories[v.Category][k] = v
			end
		end

		for category, tab in SortedPairs(categories) do
			str = string.format("%s<b>%s:</b>\n", str, category)

			for k, v in SortedPairs(tab) do
				local types = {}

				for _, argtype in pairs(v.TypeList) do
					table.insert(types, string.lower(console.Parsers[argtype].Name))
				end

				local desc = ""

				if #types > 0 then
					desc = string.format("&lt;%s&gt;", table.concat(types, "&gt; &lt;"))
				end

				if v.Description then
					desc = string.format("%s\n\t\t<dark>&gt; %s</dark>", desc, v.Description)
				end

				str = string.format("%s\t%s%s\n", str, k, desc)
			end

			str = string.format("%s\n", str)
		end

		return str
	end,
	["Enums"] = function(ply)
		local str = ""

		local function add(name, first)
			if not first then
				str = str .. "\n"
			end

			str = string.format("%s<b>%s:</b>\n", str, name)
		end

		add("Species", true)

		for _, v in pairs(GAMEMODE.Species) do
			str = string.format("%s\t%s\n\t\t<dark>&gt; %s</dark>\n", str, v.Name, v.Enum)
		end

		add("Languages")

		for _, v in pairs(LANGUAGES) do
			str = string.format("%s\t%s\n\t\t<dark>&gt; %s</dark>\n", str, v.Name, v.Command)
		end

		add("Badges")

		for _, v in pairs(BADGES) do
			str = string.format("%s\t%s\n\t\t<dark>&gt; %s</dark>\n", str, v.Name, v.Badge)
		end

		add("Requisition types")

		for _, v in pairs(LICENSES) do
			str = string.format("%s\t%s\n\t\t<dark>&gt; %s</dark>\n", str, v.Name, v.License)
		end

		add("Tooltrust")

		str = string.format("%s\tBanned\n\tBasic\n\tAdvanced\n", str)

		add("Usergroups")

		for _, v in pairs(USERGROUPS) do
			str = string.format("%s\t%s\n", str, v)
		end

		add("Permissions")

		for _, v in pairs(PERMISSIONS) do
			str = string.format("%s\t%s\n\t\t<dark>&gt; %s</dark>\n", str, v.Name, v.Perm)
		end

		return str
	end,
	["Chat commands"] = function(ply, colors)
		local str = ""
		local categories = {}

		str = string.format("%s<b>Chat Aliases:</b>\n", str)

		for k, v in SortedPairsByValue(GAMEMODE:GetConfig("ChatAliases")) do
			str = string.format("%s\t%s -&gt; %s\n", str, k, v)
		end

		local commands = {}

		for k, v in SortedPairsByValue(GAMEMODE:GetConfig("ConsoleAliases")) do
			if not console.HasAccess(ply, console.Commands[v].Access) then
				continue
			end

			commands[k] = v
		end

		if table.Count(commands) > 0 then
			str = string.format("%s\n<b>Console Aliases:</b>\n", str)

			for k, v in SortedPairsByValue(commands) do
				str = string.format("%s\t/%s -&gt; %s\n", str, k, v)
			end
		end

		str = string.format("%s\n", str)

		for k, v in pairs(GAMEMODE.ChatCommands) do
			if not categories[v.Category] then
				categories[v.Category] = {}
			end

			categories[v.Category][k] = v
		end

		for category, tab in SortedPairs(categories) do
			str = string.format("%s<b>%s:</b>\n", str, category)

			for k, v in SortedPairs(tab) do
				local desc = ""

				if #v.Description > 0 then
					desc = string.format("\n\t\t<dark>&gt; %s</dark>", v.Description)
				end

				str = string.format("%s\t/%s%s\n", str, k, desc)
			end

			str = string.format("%s\n", str)
		end

		return str
	end,
	["Chat"] = [[<b>Using languages:</b>
On top of using language commands to speak directly or set your default language, you can preface spoken commands with the language you want to use.

For example: Using /rus.y will cause you to yell in russian, but won't change your current language.
]],
	["Items/Inventories"] = [[One of the most notable features of Eternity is its item and accompanying inventory system.

Items are moved around through dragging and dropping the icons onto the various inventory slots available. Dropping an item will automatically flip it if doing so would allow it to fit where it otherwise wouldn't.

<b>Interactions:</b>
Interactions are performed through a dropdown menu available by rightclicking an item. Some items can also be used on each other, most notably stacking items and weapons. This is done by dragging one item onto another.

Using a stacking item on another stacking item of the same type will (try to) merge the two items together. Similarly, dragging ammo onto a weapon will try to load that ammo.

<b>Storage:</b>
There are various ways of storing items outside of your main inventory such as stashes, containers and even other items.

Stashes allow you to access a private storage box where you can store items. These items can not be touched by other players. Picking where to place your stash is as easy as walking up to a stash entity and using the context menu option to designate it as your stash position. At this point, your stash can only be moved by switching to a stash on a different map, or by emptying out your stash's contents before picking a new location.

Containers act as a more public storage system, being either completely open or locked with a password. Containers are locked to a map and their contents won't transfer if the map is changed.

Backpacks, boxes and other items can contain their own inventories, giving you additional room to carry and store items. Opening an item's inventory is as simple as picking the option from the item's interactions or double clicking the item's icon.
]],
	["Tips"] = [[<b>Item tags</b>
Most items include one or more tags at the bottom of their tooltip which indicate the type of item, what equipment slots it can be put into and some other possibly useful information.

<b>Inventory management</b>
Backpacks take up the same amount of space they give, making them useless unless you wear them or stuff them somewhere else where the size doesn't have an impact.

<b>Settings</b>
Don't like something about your HUD? Chances are there's a setting to either change or disable it alltogether.
]]
}

local PANEL = {}

function PANEL:Init()
	self:SetSize(800, 600)
	self:DockPadding(5, 5, 5, 5)

	self:SetToggleKey("gm_showhelp")
	self:SetAllowEscape(true)

	self:SetDrawTopBar(true)
	self:SetTitle("Help")

	self.Scroll = self:Add("eternity_scrollpanel")
	self.Scroll:DockMargin(7, 2, 0, 0)
	self.Scroll:Dock(RIGHT)
	self.Scroll:SetWide(650)

	self.Panel = self.Scroll:Add("eternity_panel")

	self.Panel.Paint = function(pnl, w, h)
		if self.MarkLeft then
			self.MarkLeft:Draw(0, 0)
		end
	end

	self.Scroll:AddItem(self.Panel)

	self:AddSection("Credits")
	self:AddSection("Console commands")

	if LocalPlayer():IsAdmin() then
		self:AddSection("Enums")
	end

	self:AddSection("Chat commands")
	self:AddSection("Chat")
	self:AddSection("Items/Inventories")
	self:AddSection("Tips")

	self:MakePopup()
	self:Center()
end

function PANEL:AddSection(name)
	local button = self:Add("eternity_button")

	button:DockMargin(0, 0, 0, 5)
	button:Dock(TOP)
	button:SetTall(22)
	button:SetText(name)

	button.DoClick = function(pnl)
		local text = help[name]
		local colors = GAMEMODE:GetConfig("UIColors")

		if isfunction(text) then
			text = text(LocalPlayer())
		end

		text = string.format("<font=eternity.labelmedium><col=%s>%s", util.ColorToChat(colors.TextNormal), text)

		self.MarkLeft = markleft.Parse(text, self.Scroll:GetWide() - 15)

		self.Panel:SetSize(self.MarkLeft:GetSize())

		self.Scroll:InvalidateParent(true)
		self.Scroll:AutoSize()
		self.Scroll:UpdateLayout()
	end
end

vgui.Register("eternity_helpmenu", PANEL, "eternity_basepanel")

GM:RegisterGUI("HelpMenu", function()
	return vgui.Create("eternity_helpmenu")
end, true)