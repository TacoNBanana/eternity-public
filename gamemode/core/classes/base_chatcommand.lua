local CLASS = class.Create()

CLASS.Name 			= ""
CLASS.Description 	= ""

CLASS.Category 		= "Unsorted"

CLASS.Commands 		= {}
CLASS.Indicator 	= CHATINDICATOR_NONE

CLASS.UseLanguage 	= false

CLASS.Range 		= false
CLASS.MuffledRange 	= false
CLASS.CastRange 	= false

CLASS.Hearable 		= false

CLASS.Logged 		= false

if CLIENT then
	function CLASS:ApplyChatFocus(ply, color)
		if IsValid(ply) and GAMEMODE:IsChatTarget(ply) then
			local hue, sat, val = ColorToHSV(color)

			sat = math.Clamp(sat - 0.2, 0, 1)
			val = math.Clamp(val + 0.2, 0, 1)

			color = HSVToColor(hue, sat, val)
		end

		return color
	end

	function CLASS:OnReceive(data, colors)
	end
end

function CLASS:OnCreated()
	if self.Logged then
		GAMEMODE:RegisterLogType("chat_" .. string.lower(self.Logged), LOG_CHAT, ParseChatLog)
	end
end

if SERVER then
	function CLASS:GetTargets(ply, data)
		local targets = {ply}
		local global = true

		if self.Range or self.MuffledRange then
			global = false

			targets = table.Add(targets, GAMEMODE:GetChatTargets(ply:EyePos(), self.Range or 0, self.MuffledRange or 0, self.Hearable))
		end

		if self.CastRange then
			global = false

			targets = table.Add(targets, GAMEMODE:GetChatTargets(ply:GetEyeTrace().HitPos, 0, self.CastRange, self.Hearable))
		end

		if global then
			return player.GetAll()
		end

		return table.Unique(targets)
	end

	function CLASS:Parse(ply, cmd, text)
		return true
	end

	function CLASS:Handle(ply, lang, cmd, text)
		text = string.sub(text, 1, GAMEMODE:GetConfig("ChatLimit"))
		text = string.Escape(text)

		if self.UseLanguage then
			if ply:Languages() == 0 then
				ply:SendChat("ERROR", "You cannot speak!")

				return
			elseif not ply:HasLanguage(lang) then
				ply:SendChat("ERROR", "You don't speak this language!")

				return
			end
		end

		local tab = self:Parse(ply, cmd, text, lang)

		if tab == true then
			return
		end

		tab.__Type = self.Name

		netstream.Send("SendChat", tab, self:GetTargets(ply, tab))

		self:DoLog(ply, tab)
	end

	function CLASS:DoLog(ply, tab)
		if not self.Logged then
			return
		end

		local new = {}

		for k, v in pairs(tab) do
			if IsEntity(v) then
				continue
			end

			new[k] = v
		end

		new.Ply = GAMEMODE:LogPlayer(ply)
		new.Char = GAMEMODE:LogCharacter(ply)

		GAMEMODE:WriteLog("chat_" .. string.lower(self.Logged), new)
	end
end

class.Register("base_chatcommand", CLASS)