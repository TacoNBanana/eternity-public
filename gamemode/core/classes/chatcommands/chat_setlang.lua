local CLASS = class.Create("base_chatcommand")

CLASS.Name = "Set language"
CLASS.Description = "Say something in the spoken language or set your default language."

CLASS.Category = "Languages"

CLASS.Commands = {}
CLASS.Indicator = CHATINDICATOR_TYPING

for k, v in pairs(LANGUAGES) do
	CLASS.Commands[k] = v.Command
end

if SERVER then
	function CLASS:Parse(ply, cmd, text, lang)
		lang = GAMEMODE:LanguageFromCommand(cmd)

		if #text > 0 then
			local command = GAMEMODE.MessageTypes.Say

			command:Handle(ply, lang, "say", text)
		elseif ply:ActiveLanguage() != lang then
			if not ply:HasLanguage(lang) then
				ply:SendChat("ERROR", "You don't speak this language!")

				return true
			end

			ply:SetActiveLanguage(lang)

			ply:SendChat("NOTICE", string.format("You are now speaking in %s.", LANGUAGES[lang].Name))
		end

		return true
	end
end

return CLASS