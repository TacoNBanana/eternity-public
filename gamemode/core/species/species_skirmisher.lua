local CLASS = class.Create("base_species")

CLASS.Name 					= "T'vaoan"
CLASS.Team 					= TEAM_COVENANT

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/player/skirmisher.mdl")
}

CLASS.DisabledProperties 	= {}

CLASS.AllowStash 			= false

CLASS.EquipmentSlots 		= {EQUIPMENT_ARMOR}
CLASS.WeaponSlots 			= {EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.ArmorLevel 			= ARMOR_LIGHT

CLASS.Voicelines 			= {}

local color = Color(28, 28, 28):ToVector()

if CLIENT then
	function CLASS:ProcessPreview(ent, pnl)
		ent.GetPlayerColor = function() return color end
	end
end

if SERVER then
	function CLASS:InitialSetup(ply)
		ply:GiveLanguage(LANG_COVENANT)
		ply:SetActiveLanguage(LANG_COVENANT)
	end

	function CLASS:GetModelData(ply)
		return {
			_base = {
				Model = ply:CharModel(),
				PlayerColor = color
			}
		}
	end

	function CLASS:SetupHands(ply, ent)
		ent:SetModel("models/viewmodels/skirmisherviewmodel.mdl")
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")

		local bodygroup = ply:ModelData()._base.Bodygroups

		if bodygroup then
			ent:SetBodygroup(1, bodygroup["Body Options"])
		end
	end
end

return CLASS