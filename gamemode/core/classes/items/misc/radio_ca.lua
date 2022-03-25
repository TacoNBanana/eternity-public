ITEM = class.Create("base_radio")

ITEM.Name 					= "Civil Administration radio"
ITEM.Description 			= "A combine-manufactured radio issued specifically to Civil Administration personnel. Hardcoded to a single frequency."

ITEM.ChannelData 			= {
	[1] = {
		Enabled = true,
		Frequency = 1005,
		Preset = 6
	}
}

ITEM.Locked 				= true

return ITEM