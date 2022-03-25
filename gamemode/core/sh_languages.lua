local meta = FindMetaTable("Player")

function GM:LanguageFromCommand(cmd)
	return _G["LANG_" .. string.upper(cmd)] or LANG_NONE
end

function meta:GetLanguages()
	if self:Languages() == LANG_NONE then
		return {}
	end

	local tab = {}

	for k in pairs(LANGUAGES) do
		if self:HasLanguage(k) then
			table.insert(tab, k)
		end
	end

	return tab
end

function meta:HasLanguage(id)
	return tobool(bit.band(self:Languages(), 2^(id - 1)))
end

function meta:CanHearLanguage(id)
	if CLIENT and GAMEMODE:GetSetting("admin_speech") then
		return true
	elseif SERVER and self:GetSetting("admin_speech") then
		return true
	end

	return self:HasLanguage(id)
end

if SERVER then
	function meta:GiveLanguage(id)
		if self:HasLanguage(id) then
			return
		end

		self:SetLanguages(self:Languages() + 2^(id - 1))
	end

	function meta:TakeLanguage(id)
		if not self:HasLanguage(id) then
			return
		end

		self:SetLanguages(self:Languages() - 2^(id - 1))
	end
end