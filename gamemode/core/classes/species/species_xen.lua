local CLASS = class.Create("base_species")

CLASS.Name 					= "Xenian"
CLASS.Team 					= TEAM_XEN

CLASS.ForceTeamSpawn 		= true

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/headcrabclassic.mdl")
}

CLASS.DisabledProperties 	= {
	["RPName"] = true,
	["Description"] = true
}

CLASS.AllowStash 			= false
CLASS.NoFallDamage 			= true
CLASS.GasImmune 			= true

CLASS.EquipmentSlots 		= {EQUIPMENT_XEN}

CLASS.MoveSpeed 			= {
	Walk = 50,
	Run = 100,
	Jump = 310,
	Crouch = 50
}

CLASS.Voicelines 			= {
	["Alert"] = "npc/headcrab/alert1.wav",
	["Idle"] = "npc/headcrab/idle3.wav"
}

function CLASS:GetVoicelines(ply)
	local item = ply:GetEquipment(EQUIPMENT_XEN)

	if item then
		return item:GetVoicelines(ply)
	end

	return self.Voicelines
end

if SERVER then
	function CLASS:OverwriteFootsteps(ply, step, walking)
		local item = ply:GetEquipment(EQUIPMENT_XEN)

		if not item then
			return "NPC_Headcrab.Footstep"
		else
			return item:OverwriteFootsteps(ply, step, walking)
		end
	end

	function CLASS:InitialSetup(ply)
		ply:SetRPName("Headcrab")
	end

	function CLASS:GetSpeeds(ply)
		local item = ply:GetEquipment(EQUIPMENT_XEN)

		if not item or not item:GetSpeeds(ply) then
			return self.MoveSpeed.Walk, self.MoveSpeed.Run, self.MoveSpeed.Jump, self.MoveSpeed.Crouch
		end

		return item:GetSpeeds(ply)
	end
end

return CLASS