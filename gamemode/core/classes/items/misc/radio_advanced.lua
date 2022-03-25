ITEM = class.Create("base_radio")

ITEM.Name 					= "Advanced radio"
ITEM.Description 			= "A well-maintained handheld radio, features a second channel and the ability to encrypt traffic.\n\nSelected channel: %s"

ITEM.ChannelCount 			= 2
ITEM.CanEncrypt 			= true

function ITEM:GetDescription()
	return string.format(self.Description, self.PrimaryChannel)
end

return ITEM