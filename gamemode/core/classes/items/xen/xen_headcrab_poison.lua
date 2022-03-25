ITEM = class.Create("base_xen")

ITEM.Name 			= "Poison Headcrab"

ITEM.Model 			= Model("models/gibs/antlion_gib_small_2.mdl")

ITEM.Voicelines 	= {
	["Idle 1"] = "npc/headcrab_poison/ph_idle1.wav",
	["Idle 2"] = "npc/headcrab_poison/ph_idle2.wav",
	["Idle 3"] = "npc/headcrab_poison/ph_idle3.wav",
	["Rattle 1"] = "npc/headcrab_poison/ph_rattle1.wav",
	["Rattle 2"] = "npc/headcrab_poison/ph_rattle2.wav",
	["Rattle 3"] = "npc/headcrab_poison/ph_rattle3.wav",
	["Talk 1"] = "npc/headcrab_poison/ph_talk1.wav",
	["Talk 2"] = "npc/headcrab_poison/ph_talk2.wav",
	["Talk 3"] = "npc/headcrab_poison/ph_talk3.wav",
	["Warning 1"] = "npc/headcrab_poison/ph_warning1.wav",
	["Warning 2"] = "npc/headcrab_poison/ph_warning2.wav",
	["Warning 3"] = "npc/headcrab_poison/ph_warning3.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/headcrabblack.mdl")
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 25, 110, 310, 25
	end

	function ITEM:OverwriteFootsteps(ply, step, walking)
		if walking then
			return "NPC_BlackHeadcrab.FootstepWalk"
		end

		return "NPC_BlackHeadcrab.Footstep"
	end
end

return ITEM