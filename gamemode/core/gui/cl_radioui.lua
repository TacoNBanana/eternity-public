local PANEL = {}

function PANEL:Init()
	self:SetSize(300, 137)
	self:DockPadding(5, 5, 5, 5)

	self:SetAllowEscape(true)
	self:SetDrawTopBar(true)
	self:SetTitle("Radio configuration")
	self:SetDraggable(true)

	local top = self:Add("eternity_panel")

	top:DockMargin(0, 0, 0, 5)
	top:Dock(TOP)
	top:SetTall(22)

	self.ChannelLeft = top:Add("eternity_button")
	self.ChannelLeft:Dock(LEFT)
	self.ChannelLeft:SetText("<")

	self.ChannelLeft.DoClick = function(pnl)
		self:SetChannel(self.Channel - 1)
	end

	self.ChannelRight = top:Add("eternity_button")
	self.ChannelRight:Dock(RIGHT)
	self.ChannelRight:SetText(">")

	self.ChannelRight.DoClick = function(pnl)
		self:SetChannel(self.Channel + 1)
	end

	self.ChannelIndicator = top:Add("eternity_button")
	self.ChannelIndicator:Dock(FILL)
	self.ChannelIndicator:SetDisabled(true)
	self.ChannelIndicator:SetText("Channel: 0")

	local frequencyline = self:Add("eternity_panel")

	frequencyline:DockMargin(0, 0, 0, 5)
	frequencyline:Dock(TOP)
	frequencyline:SetTall(22)

	local frequencylabel = frequencyline:Add("eternity_label")

	frequencylabel:DockMargin(2, 0, 0, 0)
	frequencylabel:Dock(LEFT)
	frequencylabel:SetWide(60)
	frequencylabel:SetContentAlignment(6)
	frequencylabel:SetText("Frequency:")

	self.FrequencyEdit = frequencyline:Add("eternity_textentry")
	self.FrequencyEdit:DockMargin(5, 0, 5, 0)
	self.FrequencyEdit:Dock(FILL)
	self.FrequencyEdit:SetUpdateOnType(true)

	self.FrequencyEdit.OnValueChange = function(pnl, val)
		self:HandleValueChange()
	end

	self.FrequencyEdit.AllowInput = function(pnl, char)
		if #pnl:GetValue() >= 3 then
			return true
		end

		if not string.find("0123456789", char) then
			return true
		end
	end

	local encryption = self:Add("eternity_panel")

	encryption:DockMargin(0, 0, 0, 5)
	encryption:Dock(TOP)
	encryption:SetTall(22)

	self.EncryptionLabel = encryption:Add("eternity_label")
	self.EncryptionLabel:DockMargin(2, 0, 0, 0)
	self.EncryptionLabel:Dock(LEFT)
	self.EncryptionLabel:SetWide(60)
	self.EncryptionLabel:SetContentAlignment(6)
	self.EncryptionLabel:SetText("Key:")

	self.EncryptionEdit = encryption:Add("eternity_textentry")
	self.EncryptionEdit:DockMargin(5, 0, 0, 0)
	self.EncryptionEdit:Dock(FILL)
	self.EncryptionEdit:SetUpdateOnType(true)

	self.EncryptionEdit.OnValueChange = function(pnl, val)
		self:HandleValueChange()
	end

	self.EncryptionEdit.AllowInput = function(pnl, char)
		if #pnl:GetValue() >= 10 then
			return true
		end
	end

	self.Save = frequencyline:Add("eternity_button")
	self.Save:Dock(RIGHT)
	self.Save:SetWide(80)
	self.Save:SetText("Save")
	self.Save:SetDisabled(true)

	self.Save.DoClick = function(pnl)
		local stored = self:GetChannelData()
		local frequency = self.FrequencyEdit:GetValue()
		local key

		if IsValid(self.EncryptionEdit) then
			key = self.EncryptionEdit:GetValue()

			if key == "" then
				key = nil
			end
		end

		stored.Frequency = frequency
		stored.Key = key
		stored.Preset = nil

		local data = {
			ID = self.ItemID,
			Channel = self.Channel,
			Frequency = tonumber(frequency),
			Key = key
		}

		if IsValid(self.EncryptionEdit) then
			self.EncryptionEdit:SetValue("")
		end

		if IsValid(self.Presets) then
			self.Presets:SetText("Presets")
		end

		pnl:SetDisabled(true)

		netstream.Send("SetRadioFrequency", data)
	end

	local buttons = self:Add("eternity_panel")

	buttons:Dock(FILL)

	self.EnableToggle = buttons:Add("eternity_togglebutton")
	self.EnableToggle:DockMargin(0, 0, 5, 0)
	self.EnableToggle:Dock(LEFT)
	self.EnableToggle:SetWide(80)
	self.EnableToggle:SetText("Enabled")

	self.EnableToggle.OnToggle = function(pnl, state)
		self:GetChannelData().Enabled = state

		netstream.Send("SetRadioEnabled", {
			ID = self.ItemID,
			Channel = self.Channel,
			State = state
		})
	end

	self.SpeakerToggle = buttons:Add("eternity_togglebutton")
	self.SpeakerToggle:DockMargin(0, 0, 5, 0)
	self.SpeakerToggle:Dock(LEFT)
	self.SpeakerToggle:SetWide(80)
	self.SpeakerToggle:SetText("Speaker")

	self.SpeakerToggle.OnToggle = function(pnl, state)
		self:GetChannelData().Speaker = state

		netstream.Send("SetRadioSpeaker", {
			ID = self.ItemID,
			Channel = self.Channel,
			State = state
		})
	end

	self.Presets = buttons:Add("eternity_combobox")
	self.Presets:Dock(FILL)
	self.Presets:SetText("Presets")
	self.Presets:SetSortItems(false)

	for k, v in pairs(CHANNELS) do
		self.Presets:AddChoice(v.Name, k)
	end

	self.Presets.OnSelect = function(pnl, index, val, data)
		local channel = CHANNELS[data]
		local stored = self:GetChannelData()

		self.FrequencyEdit:SetValue("")

		if IsValid(self.EncryptionEdit) then
			self.EncryptionEdit:SetValue("")
		end

		stored.Frequency = channel.Frequency
		stored.Key = nil
		stored.Preset = data

		netstream.Send("SetRadioPreset", {
			ID = self.ItemID,
			Channel = self.Channel,
			Preset = data
		})
	end

	self:MakePopup()
	self:Center()
end

function PANEL:HandleValueChange()
	local disabled = false
	local freq = self.FrequencyEdit:GetValue()

	if not tonumber(freq) then
		disabled = true
	elseif #freq < 1 or #freq > 3 then
		disabled = true
	elseif tonumber(freq) < 1 or tonumber(freq) > 999 then
		disabled = true
	elseif not GAMEMODE:CheckNameValidity(freq, "0123456789") then
		disabled = true
	end

	if IsValid(self.EncryptionEdit) then
		local key = self.EncryptionEdit:GetValue()

		if #key > 10 then
			disabled = true
		end
	end

	self.Save:SetDisabled(disabled)
end

function PANEL:GetChannelData(channel)
	if not channel then
		channel = self.Channel
	end

	if not self.ChannelData[channel] then
		self.ChannelData[channel] = {}
	end

	return self.ChannelData[channel]
end

function PANEL:SetChannel(channel)
	self.Channel = channel

	self.ChannelLeft:SetDisabled(channel <= 1)
	self.ChannelRight:SetDisabled(channel >= self.MaxChannels)

	self.ChannelIndicator:SetText("Channel: " .. channel)

	local data = self:GetChannelData()

	if not data then
		return
	end

	if data.Preset then
		if IsValid(self.Presets) then
			self.Presets:SetText(CHANNELS[data.Preset].Name)
		end

		self.FrequencyEdit:SetValue("")
	else
		if IsValid(self.Presets) then
			self.Presets:SetText("Presets")
		end

		self.FrequencyEdit:SetValue(data.Frequency or "")
	end

	self.EnableToggle:SetState(data.Enabled or false)
	self.SpeakerToggle:SetState(data.Speaker or false)

	self.Save:SetDisabled(true)
end

function PANEL:Setup(item)
	self.ItemID = item.NetworkID
	self.ChannelData = table.Copy(item.ChannelData)
	self.MaxChannels = item.ChannelCount

	if not item.CanUsePresets then
		self.Presets:Remove()
	end

	if not item.CanEncrypt then
		self.EncryptionLabel:Remove()
		self.EncryptionEdit:Remove()
	end

	self:SetChannel(1)
end

vgui.Register("eternity_radioui", PANEL, "eternity_basepanel")

GM:RegisterGUI("RadioUI", function(item)
	local instance = vgui.Create("eternity_radioui")

	instance:Setup(item)

	return instance
end)