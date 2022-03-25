local CLASS = class.Create("base_species")

CLASS.Name 					= "Mgalekgolo"
CLASS.Team 					= TEAM_COVENANT

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/valk/haloreach/covenant/characters/hunter/hunter_player.mdl")
}

CLASS.DisabledProperties 	= {}

CLASS.AllowStash 			= false

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_RADIO, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_MASSIVE

CLASS.MoveSpeed 			= {
	Walk = 67,
	Run = 200,
	Jump = 210,
	Crouch = 67
}

CLASS.Voicelines 			= {}

if SERVER then
	function CLASS:InitialSetup(ply)
		ply:GiveLanguage(LANG_COVENANT)
		ply:SetActiveLanguage(LANG_COVENANT)
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/valk/haloreach/covenant/characters/hunter/c_arms_hunter.mdl")
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")
	end
end

return CLASS