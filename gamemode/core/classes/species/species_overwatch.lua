local CLASS = class.Create("base_species")

CLASS.Name 					= "Overwatch"
CLASS.Team 					= TEAM_OVERWATCH

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 150

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/player/soldier_stripped.mdl")
}

CLASS.DisabledProperties 	= {
	["RPName"] = true,
	["Description"] = true
}

CLASS.EquipmentSlots 		= {EQUIPMENT_OVERWATCH}
CLASS.WeaponSlots 			= {EQUIPMENT_ID, EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.MoveSpeed 			= {
	Walk = 70,
	Run = 215,
	Jump = 210,
	Crouch = 70
}

CLASS.DeathSounds 			= {
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die2.wav",
	"npc/combine_soldier/die3.wav"
}

if SERVER then
	function CLASS:OverwriteFootsteps(ply, step, walking)
		if not walking then
			return step and "NPC_CombineS.RunFootstepLeft" or "NPC_CombineS.RunFootstepRight"
		end
	end

	function CLASS:InitialSetup(ply)
		local config = GAMEMODE:GetConfig("OverwatchName")
		local name = string.gsub(config, "$([%a]+)", {
			["id"] = GAMEMODE:GenerateCID(ply:CharID())
		})

		ply:SetRPName(name)
	end
end

return CLASS