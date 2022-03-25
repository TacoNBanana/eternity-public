local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Set radio channel"
CLASS.Description = "Set your radio's channel if it supports more than one."

CLASS.Category = "Radio"

CLASS.Commands = {"rset"}

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		local radio = ply:GetEquipment(EQUIPMENT_RADIO)

		if not radio then
			ply:SendChat("ERROR", "You don't have a radio!")

			return true
		end

		if radio.ChannelCount == 1 then
			ply:SendChat("ERROR", "Your radio only has one channel!")

			return true
		end

		local channel = tonumber(text)

		if not channel then
			ply:SendChat("ERROR", string.format("Specify a channel between 1 and %s.", radio.ChannelCount))

			return true
		end

		radio.PrimaryChannel = channel

		ply:SendChat("NOTICE", string.format("Now transmitting on channel %s.", channel))

		return true
	end
end

return CLASS