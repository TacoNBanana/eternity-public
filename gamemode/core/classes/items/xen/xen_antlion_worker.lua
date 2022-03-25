ITEM = class.Create("base_xen")

ITEM.Name 			= "Antlion Worker"

ITEM.Model 			= Model("models/gibs/antlion_worker_gibs_head.mdl")

ITEM.Voicelines 	= {
	["Distract"] = "npc/antlion/distract1.wav",
	["Idle 1"] = "npc/antlion/idle1.wav",
	["Idle 2"] = "npc/antlion/idle2.wav",
	["Idle 3"] = "npc/antlion/idle3.wav",
	["Idle 4"] = "npc/antlion/idle4.wav",
	["Idle 5"] = "npc/antlion/idle5.wav",
	["Scream 1"] = "npc/antlion/antlion_preburst_scream1.wav",
	["Scream 2"] = "npc/antlion/antlion_preburst_scream2.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/antlion_worker.mdl")
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 195, 355, 410, 90
	end

	function ITEM:OverwriteFootsteps(ply, step, walking)
		return "NPC_Antlion.Footstep"
	end
end

return ITEM