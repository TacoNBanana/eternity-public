local CLASS = class.Create("base_species")

CLASS.Name 					= "Human"
CLASS.Team 					= TEAM_UNSC

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	-- Male
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_alfie.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_carl.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_donnie.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_fabrice.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_gilberto.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_islambek.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_john.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_jose.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_michael.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_ray.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_rob.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_yasser.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_g_yohannes.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_heretic.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/male/offduty_snippy.mdl"),
	-- Female
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_faridah.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_hank.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_katya.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_linda.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_ltd.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_miia.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_neca.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_reid.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_tequila.mdl"),
	Model("models/ishi/halo_rebirth/player/offduty/female/offduty_wallaby.mdl")
}

CLASS.DisabledProperties 	= {
	["CharSkin"] = true
}

CLASS.AllowStash 			= true

CLASS.EquipmentSlots 		= {EQUIPMENT_HEAD, EQUIPMENT_TORSO, EQUIPMENT_BACK, EQUIPMENT_UNDERSUIT}
CLASS.WeaponSlots 			= {EQUIPMENT_ID, EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.DeathSounds 			= {
	[GENDER_MALE] = {
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	},
	[GENDER_FEMALE] = {
		"vo/npc/female01/pain01.wav",
		"vo/npc/female01/pain02.wav",
		"vo/npc/female01/pain03.wav",
		"vo/npc/female01/pain04.wav",
		"vo/npc/female01/pain05.wav",
		"vo/npc/female01/pain06.wav",
		"vo/npc/female01/pain07.wav",
		"vo/npc/female01/pain08.wav",
		"vo/npc/female01/pain09.wav"
	}
}

if SERVER then
	local loadout = {
		[EQUIPMENT_HEAD] = "helmet_marine_basic",
		[EQUIPMENT_TORSO] = "armor_marine_basic",
		[EQUIPMENT_UNDERSUIT] = "undersuit_marine_brown",
		[EQUIPMENT_RADIO] = "radio_basic"
	}

	function CLASS:InitialSetup(ply)
		ply:SetActiveLanguage(LANG_ENG)

		for k, v in pairs(loadout) do
			local item = GAMEMODE:CreateItem(v)

			ply:GetInventory(k):AddItem(item, 1, 1)
		end
	end

	function CLASS:HandleDeathSounds(ply)
		local tab = self.DeathSounds[ply:Gender()]

		if tab and #tab > 0 then
			local snd = table.Random(tab)

			ply:EmitSound(snd, 75, 100, 0.5)
		end
	end
end

return CLASS