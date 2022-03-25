local meta = FindMetaTable("Player")

GM.PlayerSettings = {}
GM.SettingCategories = {}

function GM:AddPlayerSetting(name, category, key, default, type, data, filter)
	self.PlayerSettings[key] = {
		Name = name,
		Category = category,
		Default = default,
		Type = type,
		Data = data or {},
		Filter = filter
	}

	for _, v in pairs(self.SettingCategories) do
		if v.Category == category then
			table.insert(v, key)

			return
		end
	end

	table.insert(self.SettingCategories, {
		Category = category,
		[1] = key
	})
end

local function isDonator(ply)
	return ply:IsSuperAdmin() or ply:Donator() or ply:HasBadge(BADGE_CONTRIBUTOR_GOLD)
end

GM:AddPlayerSetting("Show donator badge", "Donator", "donator_show_badge", true, TYPE_BOOL, nil, isDonator)
GM:AddPlayerSetting("Use custom reticle color", "Donator", "weapon_aimpoint_enabled", false, TYPE_BOOL, nil, isDonator)
GM:AddPlayerSetting("Reticle color", "Donator", "weapon_aimpoint_color", Color(200, 0, 0), TYPE_COLOR, nil, isDonator)
GM:AddPlayerSetting("Team-based physgun color", "Donator", "donator_physgun_color", false, TYPE_BOOL, nil, isDonator)

GM:AddPlayerSetting("Draw chat", "Chat", "chat_enabled", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw separate radio feed", "Chat", "chatradio_enabled", true, TYPE_BOOL)
GM:AddPlayerSetting("Use transparent chat background", "Chat", "chat_transparent", true, TYPE_BOOL)
GM:AddPlayerSetting("Use chat casting for long emotes", "Chat", "chat_usecasting", true, TYPE_BOOL)

GM:AddPlayerSetting("Enable focus for your target", "Chat Focus", "chat_targetfocus", true, TYPE_BOOL)
GM:AddPlayerSetting("Enable focus for people looking at you", "Chat Focus", "chat_receivefocus", true, TYPE_BOOL)

GM:AddPlayerSetting("Draw crosshairs", "Weapons", "weapon_crosshairs", true, TYPE_BOOL)
GM:AddPlayerSetting("Toggle aiming down sights", "Weapons", "weapon_toggleads", false, TYPE_BOOL)

GM:AddPlayerSetting("Show nearby spawnpoints", "UI", "ui_showspawns", false, TYPE_BOOL)
GM:AddPlayerSetting("Use transparent backgrounds", "UI", "ui_transparent", true, TYPE_BOOL)
GM:AddPlayerSetting("Use backgrounds for world labels", "UI", "ui_worldlabels", false, TYPE_BOOL)

GM:AddPlayerSetting("Enable music", "Sound", "sounds_music", true, TYPE_BOOL)
GM:AddPlayerSetting("Enable bullet impact sounds", "Sound", "sounds_bullets", true, TYPE_BOOL)

GM:AddPlayerSetting("Enable Thirdperson", "HUD", "hud_thirdperson", false, TYPE_BOOL)
GM:AddPlayerSetting("Enable HUD", "HUD", "hud_enabled", true, TYPE_BOOL)
GM:AddPlayerSetting("Use Legacy HUD (Not recommended for low FPS)", "HUD", "hud_legacy", false, TYPE_BOOL)
GM:AddPlayerSetting("Draw door info", "HUD", "hud_doors", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw button info", "HUD", "hud_buttons", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw sandbox limits", "HUD", "hud_sandbox", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw character info", "HUD", "hud_infobox", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw health", "HUD", "hud_healthbar", true, TYPE_BOOL)
GM:AddPlayerSetting("Health style", "HUD", "hud_healthstyle", HPTYPE_HEARTBEAT, TYPE_TABLE, {
	[HPTYPE_BAR] = "Health bar",
	[HPTYPE_HEARTBEAT] = "Heartbeat monitor"
})
GM:AddPlayerSetting("Draw items", "HUD", "hud_items", true, TYPE_BOOL)
GM:AddPlayerSetting("Item style", "HUD", "hud_itemstyle", ITEMTYPE_LABEL, TYPE_TABLE, {
	[ITEMTYPE_LABEL] = "Label only",
	[ITEMTYPE_GLOW] = "Glow only",
	[ITEMTYPE_BOTH] = "Both"
})
GM:AddPlayerSetting("Draw ammo", "HUD", "hud_ammo", true, TYPE_BOOL)
GM:AddPlayerSetting("Ammo style", "HUD", "hud_ammostyle", AMMOTYPE_SINGLE, TYPE_TABLE, {
	[AMMOTYPE_SINGLE] = "Clip only",
	[AMMOTYPE_DOUBLE] = "Clip/Capacity"
})
GM:AddPlayerSetting("Draw firemodes", "HUD", "hud_firemode", true, TYPE_BOOL)
GM:AddPlayerSetting("Firemode style", "HUD", "hud_firestyle", FIRETYPE_BOTH, TYPE_TABLE, {
	[FIRETYPE_MODE] = "Firemode only",
	[FIRETYPE_AMMO] = "Ammo type only",
	[FIRETYPE_BOTH] = "Both"
})
GM:AddPlayerSetting("Draw player names", "HUD", "hud_playernames", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw descriptions", "HUD", "hud_descriptions", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw typing indicators", "HUD", "hud_typing", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw restrained indicators", "HUD", "hud_restrained", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw prop ownership", "HUD", "hud_propowner", true, TYPE_BOOL)
GM:AddPlayerSetting("Prop ownership style", "HUD", "hud_propmode", PROPOWNER_BOTH, TYPE_TABLE, {
	[PROPOWNER_NAME] = "Name only",
	[PROPOWNER_STEAMID] = "SteamID only",
	[PROPOWNER_BOTH] = "Both"
})
GM:AddPlayerSetting("Draw prop descriptions", "HUD", "hud_propdescs", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw vehicle HUD", "HUD", "hud_vehicle", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw squad HUD", "HUD", "hud_squad", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw squad overlay", "HUD", "hud_squadoverlay", true, TYPE_BOOL)
GM:AddPlayerSetting("Draw HUD overlays", "HUD", "hud_overlay", true, TYPE_BOOL)

GM:AddPlayerSetting("Activate Seeall", "Seeall", "seeall_enabled", false, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Draw players", "Seeall", "seeall_players", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Show player health", "Seeall", "seeall_players_hp", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Show restrained indicators", "Seeall", "seeall_players_restrained", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Show player nicknames", "Seeall", "seeall_players_nick", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Show true identities", "Seeall", "seeall_players_identity", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Draw permaprops", "Seeall", "seeall_props", SEEALL_PROPS_PHYS, TYPE_TABLE, {
	[SEEALL_PROPS_NEVER] = "Never",
	[SEEALL_PROPS_PHYS] = "When holding a phys/toolgun",
	[SEEALL_PROPS_ALWAYS] = "Always"
}, USERGROUP_ADMIN)
GM:AddPlayerSetting("Draw items", "Seeall", "seeall_items", true, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Draw NPC's", "Seeall", "seeall_npcs", true, TYPE_BOOL, nil, USERGROUP_ADMIN)

GM:AddPlayerSetting("See all radio messages", "Admin", "admin_radio", false, TYPE_BOOL, nil, USERGROUP_ADMIN)
GM:AddPlayerSetting("Understand every language", "Admin", "admin_speech", false, TYPE_BOOL, nil, USERGROUP_ADMIN)

GM:AddPlayerSetting("Physgun mode", "Developer", "dev_physgun_mode", PHYSGUNMODE_DEFAULT, TYPE_TABLE, {
	[PHYSGUNMODE_DEFAULT] = "Default",
	[PHYSGUNMODE_CUSTOM] = "Custom color",
	[PHYSGUNMODE_RAINBOW_CLASSIC] = "Hopcolor-style rainbow",
	[PHYSGUNMODE_RAINBOW_NEW] = "HSV-style rainbow"
}, USERGROUP_DEV)
GM:AddPlayerSetting("Physgun color", "Developer", "dev_physgun_color", Color(38, 207, 232), TYPE_COLOR, nil, USERGROUP_DEV)

function meta:CanSeeSetting(filter)
	if isfunction(filter) then
		return filter(self)
	end

	if isnumber(filter) then
		return self:AdminLevel() >= filter
	end

	return false
end

if CLIENT then
	function GM:GetSetting(key)
		local setting = self.PlayerSettings[key]

		if not LocalPlayer().Settings then
			return setting.Default
		end

		if setting.Filter and not LocalPlayer():CanSeeSetting(setting.Filter) then
			return setting.Default
		end

		return LocalPlayer().Settings[key]
	end

	hook.Add("PlayerSettingsStoreChanged", "settings.PlayerSettingsStoreChanged", function(ply, old, new)
		ply.Settings = pon.decode(new)
	end)
end

if SERVER then
	function meta:GetSetting(key)
		local setting = GAMEMODE.PlayerSettings[key]

		if not self.Settings then
			return setting.Default
		end

		if setting.Filter and not self:CanSeeSetting(setting.Filter) then
			return setting.Default
		end

		return self.Settings[key]
	end

	function meta:SaveSettings()
		self:SetSettingsStore(pon.encode(self.Settings))
	end

	function meta:SetSetting(key, value)
		local setting = GAMEMODE.PlayerSettings[key]
		local old = self:GetSetting(key)

		if setting.Filter and not self:CanSeeSetting(setting.Filter) then
			return
		end

		self.Settings[key] = value
		self:SaveSettings()

		hook.Run("OnSettingChanged", self, key, old, value)
	end

	function meta:LoadSettings()
		self.Settings = pon.decode(self:SettingsStore())

		local save = false

		for k, v in pairs(GAMEMODE.PlayerSettings) do
			if self.Settings[k] == nil then
				self.Settings[k] = v.Default

				save = true
			end
		end

		for k in pairs(self.Settings) do
			if not GAMEMODE.PlayerSettings[k] then
				self.Settings[k] = nil

				save = true
			end
		end

		for k, v in pairs(self.Settings) do
			hook.Run("OnSettingChanged", self, k, nil, v)
		end

		if save then
			self:SaveSettings()
		end
	end

	hook.Add("PostPlayerLoad", "settings.PostPlayerLoad", function(ply)
		ply:LoadSettings()
	end)

	hook.Add("OnReloaded", "settings.OnReloaded", function()
		for _, v in pairs(player.GetAll()) do
			if v:PlayerLoaded() then
				v:LoadSettings()
			end
		end
	end)

	netstream.Hook("SetSetting", function(ply, data)
		local setting = GAMEMODE.PlayerSettings[data.Key]

		if setting.Type == TYPE_COLOR and data.Value.r and data.Value.g and data.Value.b then
			ply:SetSetting(data.Key, Color(data.Value.r, data.Value.g, data.Value.b))
		elseif setting.Type == TYPE_TABLE and isnumber(data.Value) and setting.Data[data.Value] then
			ply:SetSetting(data.Key, data.Value)
		elseif setting.Type == TYPE_BOOL and isbool(data.Value) then
			ply:SetSetting(data.Key, data.Value)
		end
	end)
end

hook.Add("OnSettingChanged", "setting.OnSettingChanged", function(ply, key, old, new)
	if key == "donator_show_badge" then
		ply:SetDonatorHidden(not new)
	end
end)