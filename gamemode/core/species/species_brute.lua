local CLASS = class.Create("base_species")

CLASS.Name 					= "Jiralhanae"
CLASS.Team 					= TEAM_COVENANT

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/valk/haloreach/covenant/brute/brute.mdl")
}

CLASS.DisabledProperties 	= {
	["CharSkin"] = true
}

CLASS.AllowStash 			= false

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_HEAVY

CLASS.Voicelines 			= {}

if SERVER then
	function CLASS:InitialSetup(ply)
		ply:GiveLanguage(LANG_COVENANT)
		ply:SetActiveLanguage(LANG_COVENANT)
	end

	function CLASS:GetModelData(ply)
		return {
			_base = {
				Model = "models/valk/haloreach/covenant/brute/brute.mdl",
				Scale = 1.2
			}
		}
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/valk/haloreach/covenant/brute/brute_hands.mdl")
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")
	end
end

return CLASS