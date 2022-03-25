ITEM = class.Create("base_radio")

ITEM.Name 					= "Long-range radio"
ITEM.Description 			= "A headset meant for connecting to a long-range radio pack while still offering short-range options.\n\nSelected channel: %s"

ITEM.OutlineColor 			= Color(127, 159, 255)

ITEM.License 				= LICENSE_QM

ITEM.ChannelCount 			= 2
ITEM.CanUsePresets 			= true

function ITEM:GetDescription()
	return string.format(self.Description, self.PrimaryChannel)
end

if SERVER then
	function ITEM:CanUsePreset(ply)
		local backpack = ply:GetEquipment(EQUIPMENT_BACK)

		if not backpack or not backpack:IsTypeOf("backpack_radio") then
			return false, "You don't have a radio pack on you!"
		end

		return true
	end
end

return ITEM