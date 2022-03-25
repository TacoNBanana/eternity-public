ITEM = class.Create("base_xen")

ITEM.Name 			= "Antlion"

ITEM.Model 			= Model("models/gibs/antlion_gib_large_2.mdl")

ITEM.Voicelines 	= {
	["Distract"] = "npc/antlion/distract1.wav",
	["Idle 1"] = "npc/antlion/idle1.wav",
	["Idle 2"] = "npc/antlion/idle2.wav",
	["Idle 3"] = "npc/antlion/idle3.wav",
	["Idle 4"] = "npc/antlion/idle4.wav",
	["Idle 5"] = "npc/antlion/idle5.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/antlion.mdl")
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