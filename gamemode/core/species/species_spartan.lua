local CLASS = class.Create("base_species")

CLASS.Name 					= "SPARTAN-III"
CLASS.Team 					= TEAM_SPARTAN

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/models/valk/haloreach/unsc/spartan/spartan_vb.mdl"),
}

CLASS.DisabledProperties 	= {
	["CharSkin"] = true
}

CLASS.AllowStash 			= true

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_ID, EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_HEAVY

CLASS.MoveSpeed 			= {
	Walk = 80,
	Run = 260,
	Jump = 250,
	Crouch = 80
}

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

if CLIENT then
	local overlay = CreateMaterial("SpartanOverlay", "UnlitGeneric", {
		["$basetexture"] = "models/vuthakral/halo/HUD/spartan_overlay",
		["$translucent"] = 1,
		["$ignorez"] = 1
	})

	function CLASS:PreDrawHUD()
		if not GAMEMODE:IsFirstPerson() or not GAMEMODE:GetSetting("hud_overlay") then
			return
		end

		cam.Start2D()
			surface.SetMaterial(overlay)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	end
else
	function CLASS:InitialSetup(ply)
		ply:SetActiveLanguage(LANG_ENG)
	end

	function CLASS:HandleDeathSounds(ply)
		local tab = self.DeathSounds[ply:Gender()]

		if tab and #tab > 0 then
			local snd = table.Random(tab)

			ply:EmitSound(snd, 75, 100, 0.5)
		end
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/weapons/c_arms_hev.mdl")
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")
	end

	function CLASS:GetModelData(ply)
		return {
			_base = {
				Model = ply:CharModel(),
				Skin = 0,
				PlayerColor = Color(72, 72, 72):ToVector(),
				Scale = 1.1
			}
		}
	end
end

return CLASS