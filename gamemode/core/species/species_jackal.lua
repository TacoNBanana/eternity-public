local CLASS = class.Create("base_species")

CLASS.Name 					= "Kig-Yar"
CLASS.Team 					= TEAM_COVENANT

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/player/jackal.mdl")
}

CLASS.DisabledProperties 	= {
	["CharSkin"] = true
}

CLASS.AllowStash 			= false

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_LIGHT

CLASS.Voicelines 			= {}

if CLIENT then
	function CLASS:ProcessPreview(ent, pnl)
		ent:SetSkin(1)
	end
end

if SERVER then
	function CLASS:InitialSetup(ply)
		ply:GiveLanguage(LANG_COVENANT)
		ply:SetActiveLanguage(LANG_COVENANT)

		ply:SetCharSkin(1)
		ply:HandlePlayerModel()
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/viewmodels/jackalviewmodel.mdl")
		ent:SetSkin(1)
		ent:SetBodyGroups("00000000")
	end
end

return CLASS