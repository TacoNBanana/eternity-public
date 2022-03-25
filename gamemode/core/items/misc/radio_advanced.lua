ITEM = class.Create("base_radio")

ITEM.Name 					= "Command radio"
ITEM.Description 			= "A more complex radio package meant for command personnel. Comes with the ability to configure multiple channels and support for encrypted transmissions.\n\nSelected channel: %s"

ITEM.OutlineColor 			= Color(127, 159, 255)

ITEM.ChannelCount 			= 3
ITEM.CanEncrypt 			= true
ITEM.CanUsePresets 			= true

function ITEM:GetDescription()
	return string.format(self.Description, self.PrimaryChannel)
end

if SERVER then
	function ITEM:CanUsePreset(ply)
		return true
	end
end

return ITEM