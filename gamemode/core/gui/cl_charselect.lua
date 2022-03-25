local PANEL = {}

function PANEL:Init()
	self:SetWide(200)
	self:DockPadding(10, 10, 10, 10)

	if LocalPlayer():HasCharacter() then
		self:SetToggleKey("gm_showteam")
		self:SetAllowEscape(true)
	end

	self:SetDrawTopBar(true)
	self:SetTitle("Character Selection")

	self:Populate()

	self.DeleteMode = false

	self:MakePopup()
	self:Center()
end

function PANEL:Populate()
	self.Buttons = {}

	for k, v in SortedPairs(LocalPlayer():Characters()) do
		local button = self:Add("eternity_button")

		button:DockMargin(0, 0, 0, 5)
		button:Dock(TOP)
		button:SetText(v.RPName)

		button.DoClick = function(pnl)
			if self.DeleteMode then
				netstream.Send("DeleteCharacter", {
					ID = k
				})
			else
				netstream.Send("LoadCharacter", {
					ID = k
				})

				GAMEMODE:CloseGUI("CharSelect")
			end
		end

		button:SetDisabled(self:ShouldDisable(k, v))
		button.ID = k
		button.Data = v

		table.insert(self.Buttons, button)
	end

	local num = #self.Buttons
	local max = GAMEMODE:GetConfig("MaxCharacters")

	if num < max then
		local button = self:Add("eternity_button")

		button:DockMargin(0, 0, 0, 5)
		button:Dock(TOP)
		button:SetText("Empty slot")
		button:SetDisabled(true)
	end

	self.CreateNew = self:Add("eternity_button")
	self.CreateNew:DockMargin(0, 20, 0, 0)
	self.CreateNew:Dock(TOP)
	self.CreateNew:SetText("Create character")

	if #LocalPlayer():GetAvailableSpecies() < 1 or num >= max then
		self.CreateNew:SetDisabled(true)
	end

	self.CreateNew.DoClick = function(pnl)
		GAMEMODE:CloseGUI("CharSelect")
		GAMEMODE:OpenGUI("SpeciesSelect")
	end

	self.Delete = self:Add("eternity_button")
	self.Delete:DockMargin(0, 5, 0, 0)
	self.Delete:Dock(TOP)
	self.Delete:SetText("Delete")

	self.Delete.DoClick = function(pnl)
		local colors = GAMEMODE:GetConfig("UIColors")

		self.DeleteMode = not self.DeleteMode

		pnl:SetTextColor(self.DeleteMode and colors.TextPrimary or nil)

		for _, v in pairs(self.Buttons) do
			v:SetDisabled(self:ShouldDisable(v.ID, v.Data))
		end
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

function PANEL:ShouldDisable(id, data)
	if not self.DeleteMode and LocalPlayer():CharID() == id then
		return true
	end

	if not self.DeleteMode and not LocalPlayer():HasSpeciesWhitelist(data.Species) then
		return true
	end

	return false
end

vgui.Register("eternity_charselect", PANEL, "eternity_basepanel")

GM:RegisterGUI("CharSelect", function()
	return vgui.Create("eternity_charselect")
end, true)

hook.Add("PlayerCharactersChanged", "charselect.PlayerCharactersChanged", function(ply, old, new)
	-- Effectively acts as a refresh
	if GAMEMODE:GetGUI("CharSelect") then
		GAMEMODE:OpenGUI("CharSelect")
	end
end)