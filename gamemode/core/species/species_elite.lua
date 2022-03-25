local CLASS = class.Create("base_species")

CLASS.Name 					= "Sangheili"
CLASS.Team 					= TEAM_COVENANT

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/halo_reach/players/elite_minor.mdl")
}

CLASS.DisabledProperties 	= {
	["CharSkin"] = true
}

CLASS.AllowStash 			= false

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_HEAVY

CLASS.MoveSpeed 			= {
	Walk = 50,
	Run = 300,
	Jump = 300,
	Crouch = 50
}

CLASS.Voicelines 			= {}

if CLIENT then
	local overlay = CreateMaterial("EliteOverlay", "UnlitGeneric", {
		["$basetexture"] = "models/vuthakral/halo/HUD/elite_overlay",
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
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	end
else
	function CLASS:InitialSetup(ply)
		ply:GiveLanguage(LANG_COVENANT)
		ply:SetActiveLanguage(LANG_COVENANT)
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/weapons/c_arms_hev.mdl")
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")
	end

	function CLASS:GetModelData(ply)
		return {
			_base = {
				Model = "models/halo_reach/players/elite_minor.mdl",
				Skin = 1
			}
		}
	end
end

return CLASS