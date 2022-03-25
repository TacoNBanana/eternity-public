local PANEL = {}

function PANEL:Init()
	self:SetSize(700, 400)
	self:DockPadding(10, 10, 10, 10)

	if LocalPlayer():HasCharacter() then
		self:SetToggleKey("gm_showteam")
		self:SetAllowEscape(true)
	end

	self:SetDrawTopBar(true)
	self:SetTitle("Character Creation")

	self.Left = self:Add("eternity_panel")
	self.Left:DockMargin(0, 0, 10, 0)
	self.Left:Dock(LEFT)
	self.Left:SetWide(480)

	self.Right = self:Add("eternity_panel")
	self.Right:Dock(FILL)

	self.Cancel = self.Right:Add("eternity_button")
	self.Cancel:DockMargin(0, 5, 0, 0)
	self.Cancel:Dock(BOTTOM)
	self.Cancel:SetText("Cancel")

	self.Cancel.DoClick = function(pnl)
		GAMEMODE:CloseGUI("CharCreate")
		GAMEMODE:OpenGUI("CharSelect")
	end

	self.Confirm = self.Right:Add("eternity_button")
	self.Confirm:DockMargin(0, 10, 0, 0)
	self.Confirm:Dock(BOTTOM)
	self.Confirm:SetText("Confirm")

	self.Confirm.DoClick = function(pnl)
		self:Submit()
	end

	self.ModelPanel = self.Right:Add("eternity_modelpanel")
	self.ModelPanel:Dock(FILL)
	self.ModelPanel:SetFOV(20)
	self.ModelPanel:SetAnimated(true)
	self.ModelPanel:SetAllowManipulation(true)

	self:MakePopup()
	self:Center()
end

function PANEL:AddRow(name, height)
	local panel = self.Left:Add("eternity_panel")

	panel:DockMargin(0, 0, 0, 10)
	panel:Dock(TOP)

	panel:SetTall(height)

	local left = panel:Add("eternity_panel")

	left:DockMargin(0, 0, 10, 0)
	left:Dock(LEFT)
	left:SetWide(120)

	if #name > 0 then
		local label = left:Add("DLabel")

		label:Dock(FILL)
		label:SetFont("eternity.labelgiant")
		label:SetText(name)
		label:SetContentAlignment(9)
	end

	local right = panel:Add("eternity_panel")

	right:Dock(FILL)

	return right
end

function PANEL:Populate(species)
	self.Species = species
	self.Left:Clear()

	local skip = true

	if not GAMEMODE:IsPropertyDisabled(species, "RPName") then
		self.NameEntry = self:AddRow("Name", 20):Add("eternity_textentry")
		self.NameEntry:Dock(FILL)
		self.NameEntry:SetUpdateOnType(true)

		self.NameEntry.OnValueChange = function(pnl, val)
			self:UpdateSubmit(species)
		end

		local buttons = self:AddRow("", 20)

		self.RandomMale = buttons:Add("eternity_button")
		self.RandomMale:DockMargin(0, 0, 10, 0)
		self.RandomMale:Dock(LEFT)
		self.RandomMale:SetWide(100)
		self.RandomMale:SetText("Random Male")

		self.RandomMale.DoClick = function(pnl)
			local name = string.format("%s %s", table.Random(GAMEMODE.MaleFirstNames), table.Random(GAMEMODE.LastNames))

			self.NameEntry:SetValue(name)
		end

		self.RandomFemale = buttons:Add("eternity_button")
		self.RandomFemale:Dock(LEFT)
		self.RandomFemale:SetWide(100)
		self.RandomFemale:SetText("Random Female")

		self.RandomFemale.DoClick = function(pnl)
			local name = string.format("%s %s", table.Random(GAMEMODE.FemaleFirstNames), table.Random(GAMEMODE.LastNames))

			self.NameEntry:SetValue(name)
		end

		skip = false
	end

	if not GAMEMODE:IsPropertyDisabled(species, "Description") then
		self.Description = self:AddRow("Description", 150):Add("eternity_textentry")
		self.Description:Dock(FILL)
		self.Description:SetMultiline(true)
		self.Description:SetUpdateOnType(true)

		self.Description.OnValueChange = function(pnl, val)
			self:UpdateSubmit(species)
		end

		skip = false
	end

	if #species.PlayerModels > 1 then
		self.ModelScroll = self:AddRow("Model", 56):Add("eternity_horizontalscroll")
		self.ModelScroll:Dock(FILL)

		skip = false
	end

	if not GAMEMODE:IsPropertyDisabled(species, "CharSkin") then
		for _, v in pairs(species.PlayerModels) do
			if NumModelSkins(v) > 1 then
				self.SkinScroll = self:AddRow("Skin", 56):Add("eternity_horizontalscroll")
				self.SkinScroll:Dock(FILL)

				skip = false

				break
			end
		end
	end

	self:PopulateModels(species)
	self:PopulateSkins(species.PlayerModels[1])

	if skip then
		self:Submit()
		self:Remove()
	else
		self:UpdateSubmit()
	end
end

function PANEL:PopulateModels(species)
	if not IsValid(self.ModelScroll) then
		self.SelectedModel = species.PlayerModels[1]

		return
	end

	self.ModelScroll:Clear()

	for _, v in pairs(species.PlayerModels) do
		local icon = self.ModelScroll:Add("SpawnIcon")

		icon:SetSize(56, 56)
		icon:SetModel(v)

		icon.DoClick = function(pnl)
			self.SelectedModel = v
			self:PopulateSkins(v)
		end

		self.ModelScroll:AddPanel(icon)
	end

	self.ModelScroll.Panels[1]:DoClick()
end

function PANEL:PopulateSkins(mdl)
	if not IsValid(self.SkinScroll) then
		self.SelectedSkin = 0
		self:UpdatePreview()

		return
	end

	self.SkinScroll:Clear()

	for i = 0, NumModelSkins(mdl) - 1 do
		local icon = self.SkinScroll:Add("SpawnIcon")

		icon:SetSize(56, 56)
		icon:SetModel(mdl, i)

		icon.DoClick = function(pnl)
			self.SelectedSkin = i
			self:UpdatePreview()
		end

		self.SkinScroll:AddPanel(icon)
	end

	if self.SkinScroll.Panels[1] then
		self.SkinScroll.Panels[1]:DoClick()
	end
end

function PANEL:UpdatePreview()
	self.ModelPanel:SetModel(self.SelectedModel)
	self.ModelPanel:SetSkin(self.SelectedSkin)

	self.Species:ProcessPreview(self.ModelPanel:GetEntity(), self.ModelPanel)
end

function PANEL:UpdateSubmit()
	local data = self:FormatData()
	local ok, err = GAMEMODE:CheckCharacterValidity(self.Species, data)

	self.Confirm:SetDisabled(not ok)
	self.Confirm:SetTooltip(err or false)
end

function PANEL:Submit()
	local data = self:FormatData()
	local species = self.Species

	data.Species = species.ID

	netstream.Send("CreateCharacter", data)

	GAMEMODE:CloseGUI("CharCreate")
end

function PANEL:FormatData()
	local data = {
		CharModel = self.SelectedModel,
		CharSkin = self.SelectedSkin or 0
	}

	if not GAMEMODE:IsPropertyDisabled(self.Species, "RPName") then
		data.RPName = string.Trim(self.NameEntry:GetValue())
	end

	if not GAMEMODE:IsPropertyDisabled(self.Species, "Description") then
		data.Description = string.Trim(self.Description:GetValue())
	end

	return data
end

vgui.Register("eternity_charcreate", PANEL, "eternity_basepanel")

GM:RegisterGUI("CharCreate", function(species)
	local panel = vgui.Create("eternity_charcreate")

	panel:Populate(species)

	return panel
end, true)