local PANEL = {}

function PANEL:Init()
	self:SetSize(800, 500)

	self:SetToggleKey("gm_showspare1")
	self:SetAllowEscape(true)

	self:AddMenu("Description")
	self:AddMenu("Inventory")
	self:AddMenu("Business")
	self:AddMenu("Settings")

	self:SetupTopbar()

	self:MakePopup()
	self:Center()

	self.MenuItems[2]:DoClick()
end

function PANEL:UpdateDescription()
	local colors = GAMEMODE:GetConfig("UIColors")
	local desc = LocalPlayer():Description()

	desc = string.Escape(desc)

	local formatted = string.format("<font=eternity.labelsmall><col=%s>%s", util.ColorToChat(colors.TextNormal), desc)

	self.MarkLeft = markleft.Parse(formatted, self.Scroll:GetWide() - 15)

	if not IsValid(self.Description) then
		self.Description = self.Scroll:Add("eternity_panel")

		self.Description.Paint = function(pnl, w, h)
			self.MarkLeft:Draw(0, 0)
		end

		self.Scroll:AddItem(self.Description)
	end

	self.Description:SetSize(self.MarkLeft:GetSize())

	self.Scroll:InvalidateParent(true)
	self.Scroll:AutoSize()
	self.Scroll:UpdateLayout()
end

hook.Add("PlayerDescriptionChanged", "playermenu.PlayerDescriptionChanged", function(ply, old, new)
	if ply != LocalPlayer() then
		return
	end

	local ui = GAMEMODE:GetGUI("PlayerMenu")

	if not IsValid(ui) or ui.Active != "Description" then
		return
	end

	ui:UpdateDescription()
end)

hook.Add("PlayerRPNameChanged", "playermenu.PlayerRPNameChanged", function(ply, old, new)
	if ply != LocalPlayer() then
		return
	end

	local ui = GAMEMODE:GetGUI("PlayerMenu")

	if not IsValid(ui) or ui.Active != "Description" then
		return
	end

	if IsValid(ui.CharacterName) then
		ui.CharacterName:SetText(new)
	end
end)

function PANEL:CreateDescription()
	self.Preview = self.Content:Add("eternity_playerview")
	self.Preview:DockMargin(0, 0, 20, 0)
	self.Preview:Dock(LEFT)
	self.Preview:SetWide(200)
	self.Preview:SetPlayer(LocalPlayer())
	self.Preview.TargetLookAt = Vector(0, 0, 54)

	self.CharacterName = self.Content:Add("eternity_label")
	self.CharacterName:DockMargin(0, 0, 0, 5)
	self.CharacterName:Dock(TOP)
	self.CharacterName:SetTall(22)
	self.CharacterName:SetFont("eternity.labelgiant")
	self.CharacterName:SetText(LocalPlayer():RPName())

	local bottom = self.Content:Add("eternity_panel")

	bottom:DockMargin(0, 5, 0, 0)
	bottom:Dock(BOTTOM)
	bottom:SetTall(22)

	self.DescEdit = bottom:Add("eternity_button")
	self.DescEdit:DockMargin(5, 0, 0, 0)
	self.DescEdit:Dock(RIGHT)
	self.DescEdit:SetWide(120)
	self.DescEdit:SetText("Edit Description")

	self.DescEdit.DoClick = function(pnl)
		coroutine.WrapFunc(function()
			local new = GAMEMODE:OpenGUI("Input", "string", "Edit Description", {
				Default = LocalPlayer():Description(),
				Multiline = true,
				Max = 2048
			})

			netstream.Send("SetDescription", {
				Description = new
			})
		end)
	end

	self.NotesEdit = bottom:Add("eternity_button")
	self.NotesEdit:DockMargin(5, 0, 0, 0)
	self.NotesEdit:Dock(RIGHT)
	self.NotesEdit:SetWide(80)
	self.NotesEdit:SetText("Edit Notes")

	self.NotesEdit.DoClick = function(pnl)
		coroutine.WrapFunc(function()
			local index = string.format("eternity_notes_%s_%s", GAMEMODE:GetConfig("BanRealm"), LocalPlayer():CharID())
			local new = GAMEMODE:OpenGUI("Input", "string", "Edit Notes", {
				Default = cookie.GetString(index, ""),
				Multiline = true,
				Max = 2048
			})

			cookie.Set(index, new)
		end)
	end

	self.NameEdit = bottom:Add("eternity_button")
	self.NameEdit:Dock(RIGHT)
	self.NameEdit:SetWide(80)
	self.NameEdit:SetText("Edit Name")

	self.NameEdit.DoClick = function(pnl)
		coroutine.WrapFunc(function()
			local new = GAMEMODE:OpenGUI("Input", "string", "Edit Name", {
				Default = LocalPlayer():RPName(),
				Max = 30
			})

			netstream.Send("SetName", {
				Name = new
			})
		end)
	end

	-- Holy shit I hate scroll panels
	self.Scroll = self.Content:Add("eternity_scrollpanel")
	self.Scroll:DockMargin(2, 0, 0, 0)
	self.Scroll:Dock(FILL)
	self.Scroll:InvalidateParent(true)

	self.Scroll:UpdateLayout()

	self:UpdateDescription()

	local languages = "Languages: "
	local tab = {}

	for _, v in pairs(LocalPlayer():GetLanguages()) do
		table.insert(tab, LANGUAGES[v].Name)
	end

	languages = languages .. (#tab > 0 and table.concat(tab, ", ") or "N/A")

	self.Languages = bottom:Add("eternity_label")
	self.Languages:Dock(FILL)
	self.Languages:SetFont("eternity.labelsmall")
	self.Languages:SetText(languages)
end

local function AddSlots(parent, slots)
	for _, v in pairs(slots) do
		local inv = parent:Add("eternity_itemgrid")

		inv:DockMargin(0, 0, 0, GAMEMODE:GetConfig("ItemIconMargin") * 2)
		inv:Dock(TOP)

		inv:Setup(LocalPlayer():GetInventory(v))
	end
end

function PANEL:CreateInventory()
	self.Inventory = self.Content:Add("eternity_itemgrid")
	self.Inventory:Setup(LocalPlayer():GetInventory("Main"))

	self.Equipment = self.Content:Add("eternity_panel")

	self.Equipment:Dock(RIGHT)
	self.Equipment:SetWide(GAMEMODE:GetConfig("ItemIconSize"))

	AddSlots(self.Equipment, LocalPlayer():GetActiveSpecies().EquipmentSlots)

	self.Armor = self.Equipment:Add("eternity_label")

	self.Armor:DockMargin(2, 0, 0, 0)
	self.Armor:Dock(TOP)
	self.Armor:SetFont("eternity.labeltiny")
	self.Armor:SetTall(24)
	self.Armor.Think = function(pnl)
		pnl:SetText("Armor\nLevel: " .. LocalPlayer():ArmorLevel())
	end

	self.Preview = self.Content:Add("eternity_liveview")
	self.Preview:Dock(RIGHT)
	self.Preview:SetWide(200)
	self.Preview:SetEntity(LocalPlayer())
	self.Preview:SetFOV(25)

	self.Weapons = self.Content:Add("eternity_panel")
	self.Weapons:Dock(RIGHT)
	self.Weapons:SetWide(GAMEMODE:GetConfig("ItemIconSize"))

	AddSlots(self.Weapons, LocalPlayer():GetActiveSpecies().WeaponSlots)
end

function PANEL:UpdateBusinessItems()
	self.List.Canvas:Clear()

	local alt = true

	for _, v in pairs(LocalPlayer():GetBuyableItems()) do
		local item = self.List:Add("eternity_businesspanel")

		item:Dock(TOP)
		item:SetTall(64)
		item:SetAlt(alt)
		item:Setup(v)

		alt = not alt

		self.List:AddItem(item)
	end

	self.List:InvalidateParent(true)
	self.List:AutoSize()
	self.List:UpdateLayout()
end

function PANEL:UpdateBusinessMoney()
	for _, v in pairs(self.List.Canvas:GetChildren()) do
		v:UpdateMoney()
	end

	for k, v in pairs(LICENSES) do
		local owned = LocalPlayer():HasLicense(k)

		if not owned and not v.Price then
			continue
		end

		if LocalPlayer():InOutlands() then
			self["License" .. k]:SetDisabled(true)
		else
			self["License" .. k]:SetDisabled(owned or not LocalPlayer():HasMoney(v.Price))
		end
	end
end

netstream.Hook("UpdateBusiness", function(data)
	local ui = GAMEMODE:GetGUI("PlayerMenu")

	if not IsValid(ui) or ui.Active != "Business" then
		return
	end

	if data.Items then
		ui:UpdateBusinessItems()
	end

	ui:UpdateBusinessMoney()
end)

function PANEL:CreateBusiness()
	local left = self.Content:Add("eternity_panel")

	left:DockMargin(0, 0, 5, 0)
	left:Dock(LEFT)
	left:SetWide(200)

	for k, v in SortedPairs(LICENSES, true) do
		local owned = LocalPlayer():HasLicense(k)

		if not owned and not v.Price then
			continue
		end

		self["License" .. k] = left:Add("eternity_button")

		self["License" .. k]:DockMargin(0, 5, 0, 0)
		self["License" .. k]:Dock(BOTTOM)
		self["License" .. k]:SetText(v.Price and string.format("%s - %s", v.Name, v.Price) or v.Name)

		self["License" .. k].DoClick = function(pnl)
			netstream.Send("BuyLicense", {
				License = k
			})
		end
	end

	local text = "If you don't own a business license you can buy one by clicking one of the buttons below to get started.\n\nBuying a new license will revoke any current ones. This will not refund any money."

	if LocalPlayer():InOutlands() then
		text = "You're currently outside of the city.\n\nMost business related features won't be available out here."
	end

	self.Label = left:Add("eternity_label")
	self.Label:Dock(FILL)
	self.Label:SetFont("eternity.labelsmall")
	self.Label:SetWrap(true)
	self.Label:SetContentAlignment(7)
	self.Label:SetText(text)

	self.List = self.Content:Add("eternity_scrollpanel")
	self.List:Dock(FILL)

	self:UpdateBusinessItems()
	self:UpdateBusinessMoney()
end

function PANEL:CreateSettings()
	local right = self.Content:Add("eternity_panel")

	right:DockMargin(5, 0, 0, 0)
	right:Dock(RIGHT)
	right:SetWide(120)

	self.Rejoin = right:Add("eternity_button")
	self.Rejoin:SetSize(120, 22)
	self.Rejoin:SetText("Rejoin")
	self.Rejoin:DockMargin(0, 5, 0, 0)
	self.Rejoin:Dock(BOTTOM)

	self.Rejoin.DoClick = function(pnl)
		RunConsoleCommand("retry")
	end

	self.Suicide = right:Add("eternity_button")
	self.Suicide:SetSize(120, 22)
	self.Suicide:SetText("Suicide")
	self.Suicide:DockMargin(0, 5, 0, 0)
	self.Suicide:Dock(BOTTOM)

	self.Suicide.DoClick = function(pnl)
		RunConsoleCommand("kill")
	end

	local bottom = self.Content:Add("eternity_panel")

	bottom:DockMargin(0, 5, 0, 0)
	bottom:Dock(BOTTOM)
	bottom:SetTall(65)

	self.SettingsPanel = self.Content:Add("eternity_scrollpanel")
	self.SettingsPanel:Dock(FILL)

	local colors = GAMEMODE:GetConfig("UIColors")
	local odd = true

	for _, v in pairs(GAMEMODE.SettingCategories) do
		local found = false

		for _, key in ipairs(v) do
			local setting = GAMEMODE.PlayerSettings[key]

			if not setting.Filter or LocalPlayer():CanSeeSetting(setting.Filter) then
				found = true

				break
			end
		end

		if not found then
			continue
		end

		local background = self.SettingsPanel.Canvas:Add("eternity_panel")

		background:Dock(TOP)
		background:SetDrawColor(colors.FillLight)
		background:SetDrawBorder(colors.FillMedium)

		local title = background:Add("eternity_label")

		title:DockMargin(5, 5, 5, 5)
		title:Dock(FILL)
		title:SetFont("eternity.labelgiant")
		title:SetContentAlignment(4)
		title:SetText(v.Category)

		background:SetTall(35)

		odd = true

		for _, key in ipairs(v) do
			local panel = self.SettingsPanel.Canvas:Add("eternity_settingpanel")

			panel:Dock(TOP)
			panel:Setup(key, odd)

			odd = not odd
		end
	end

	self.SettingsPanel:InvalidateParent(true)

	self.SettingsPanel:AutoSize()
	self.SettingsPanel:UpdateLayout()

	local left1 = bottom:Add("eternity_panel")

	left1:Dock(LEFT)
	left1:SetWide(120)
	left1:DockMargin(0, 0, 5, 0)

	self.Contentpack = left1:Add("eternity_button")
	self.Contentpack:SetSize(120, 22)
	self.Contentpack:SetText("View server content")
	self.Contentpack:Dock(BOTTOM)

	self.Contentpack.DoClick = function(pnl)
		gui.OpenURL(string.format("https://steamcommunity.com/sharedfiles/filedetails/?id=%s", GAMEMODE:GetConfig("CollectionID")))
	end

	self.Changelog = left1:Add("eternity_button")
	self.Changelog:DockMargin(0, 0, 0, 5)
	self.Changelog:Dock(BOTTOM)
	self.Changelog:SetSize(120, 22)
	self.Changelog:SetText("View changelog")

	self.Changelog.DoClick = function(pnl)
		GAMEMODE:OpenGUI("MOTD")
	end

	if not GAMEMODE.MOTD then
		self.Changelog:SetDisabled(true)
	end

	local left2 = bottom:Add("eternity_panel")

	left2:Dock(LEFT)
	left2:SetWide(120)
	left2:DockMargin(0, 0, 5, 0)

	self.Website = left2:Add("eternity_button")
	self.Website:SetSize(120, 22)
	self.Website:SetText("Visit website")
	self.Website:Dock(BOTTOM)

	self.Website.DoClick = function(pnl)
		gui.OpenURL(GAMEMODE:GetConfig("Website"))
	end
end

vgui.Register("eternity_playermenu", PANEL, "eternity_basemenu")

GM:RegisterGUI("PlayerMenu", function()
	return vgui.Create("eternity_playermenu")
end, true)