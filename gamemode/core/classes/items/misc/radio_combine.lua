ITEM = class.Create("base_radio")

ITEM.Name 					= "Combine radio"
ITEM.Description 			= "A combine-issued radio, capable of integrating with a biosignal to decrypt combine signals.\n\nSelected channel: %s"

ITEM.OutlineColor 			= Color(33, 106, 196)

ITEM.ChannelCount 			= 2
ITEM.CanEncrypt 			= true
ITEM.IsCombine 				= true

function ITEM:GetDescription()
	return string.format(self.Description, self.PrimaryChannel)
end

return ITEM