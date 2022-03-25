ITEM = class.Create("base_xen")

ITEM.Name 			= "Antlion Guard"

ITEM.Model 			= Model("models/weapons/w_bugbait.mdl")

ITEM.Voicelines 	= {
	["Angry 1"] = "npc/antlion_guard/angry1.wav",
	["Angry 2"] = "npc/antlion_guard/angry2.wav",
	["Angry 3"] = "npc/antlion_guard/angry3.wav",
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/antlion_guard.mdl")
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 180, 470, 210, 90
	end

	function ITEM:OverwriteFootsteps(ply, step, walking)
		return "NPC_AntlionGuard.StepHeavy"
	end
end

return ITEM