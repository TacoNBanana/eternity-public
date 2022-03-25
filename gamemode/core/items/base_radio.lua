ITEM = class.Create("base_item")

ITEM.Model 					= Model("models/Items/combine_rifle_cartridge01.mdl")

ITEM.EquipmentSlots 		= {EQUIPMENT_RADIO}

ITEM.ChannelCount 			= 1
ITEM.ChannelData 			= {}

ITEM.PrimaryChannel 		= 1

ITEM.CanEncrypt 			= false
ITEM.CanUsePresets 			= false

ITEM.Locked 				= false

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Configure",
		Client = function()
			self:OpenGUI()
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

if CLIENT then
	function ITEM:OpenGUI()
		if self.Locked then
			GAMEMODE:SendChat("ERROR", "Your radio is locked to this configuration!")

			return
		end

		GAMEMODE:OpenGUI("RadioUI", self)
	end
end

if SERVER then
	function ITEM:GetChannelData(channel)
		if not channel then
			channel = self.PrimaryChannel
		end

		if not self.ChannelData[channel] then
			self.ChannelData[channel] = {}
		end

		self.ChannelData = self.ChannelData

		return self.ChannelData[channel]
	end

	function ITEM:CanUsePreset(ply)
		return true
	end

	function ITEM:CanTransmit(ply)
		local data = self:GetChannelData()

		if not data or not data.Enabled or not data.Frequency then
			return false
		end

		if data.Preset then
			return self:CanUsePreset(ply)
		end

		return true
	end

	function ITEM:CanHearFrequency(ply, freq, key)
		local hear = false
		local clear = false
		local speaker = false

		for _, v in pairs(self.ChannelData) do
			if not v.Enabled or not v.Frequency or v.Frequency != freq then
				continue
			end

			hear = true

			if v.Preset then
				if self:CanUsePreset(ply) then
					clear = true
				end
			elseif not key or v.Key == key then
				clear = true
			end

			if v.Speaker then
				speaker = true
			end
		end

		return hear, clear, speaker
	end

	netstream.Hook("SetRadioFrequency", function(ply, data)
		local item = GAMEMODE:GetItem(data.ID)

		if not item or not item:CanInteract(ply) then
			return
		end

		if item.Locked then
			return
		end

		if data.Channel < 1 or data.Channel > item.ChannelCount then
			return
		end

		local channel = item:GetChannelData(data.Channel)

		data.Frequency = math.Round(data.Frequency)

		if data.Frequency < 1 or data.Frequency > 999 then
			return
		end

		if data.Key and #data.Key > 10 then
			return
		end

		channel.Frequency = data.Frequency
		channel.Key = data.Key
		channel.Preset = nil

		item.ChannelData = item.ChannelData
	end, {
		ID = {Type = TYPE_NUMBER},
		Channel = {Type = TYPE_NUMBER},
		Frequency = {Type = TYPE_NUMBER},
		Key = {Type = TYPE_STRING, Optional = true}
	})

	netstream.Hook("SetRadioEnabled", function(ply, data)
		local item = GAMEMODE:GetItem(data.ID)

		if not item or not item:CanInteract(ply) then
			return
		end

		if item.Locked then
			return
		end

		local channel = item:GetChannelData(data.Channel)

		channel.Enabled = data.State

		item.ChannelData = item.ChannelData
	end, {
		ID = {Type = TYPE_NUMBER},
		Channel = {Type = TYPE_NUMBER},
		State = {Type = TYPE_BOOL}
	})

	netstream.Hook("SetRadioSpeaker", function(ply, data)
		local item = GAMEMODE:GetItem(data.ID)

		if not item or not item:CanInteract(ply) then
			return
		end

		if item.Locked then
			return
		end

		local channel = item:GetChannelData(data.Channel)

		channel.Speaker = data.State

		item.ChannelData = item.ChannelData
	end, {
		ID = {Type = TYPE_NUMBER},
		Channel = {Type = TYPE_NUMBER},
		State = {Type = TYPE_BOOL}
	})

	netstream.Hook("SetRadioPreset", function(ply, data)
		local item = GAMEMODE:GetItem(data.ID)

		if not item or not item:CanInteract(ply) then
			return
		end

		if item.Locked or not item.CanUsePresets then
			return
		end

		local preset = CHANNELS[data.Preset]
		local channel = item:GetChannelData(data.Channel)

		channel.Frequency = preset.Frequency
		channel.Key = nil
		channel.Preset = data.Preset

		item.ChannelData = item.ChannelData
	end, {
		ID = {Type = TYPE_NUMBER},
		Channel = {Type = TYPE_NUMBER},
		Preset = {Type = TYPE_NUMBER}
	})
end

return ITEM