ITEM = class.Create("base_xen")

ITEM.Name 			= "Poison Zombie"

ITEM.Model 			= Model("models/gibs/hgibs.mdl")

ITEM.Voicelines 	= {
	["Alert 1"] = "npc/zombie_poison/pz_alert1.wav",
	["Alert 2"] = "npc/zombie_poison/pz_alert2.wav",
	["Call"] = "npc/zombie_poison/pz_call1.wav",
	["Idle 1"] = "npc/zombie_poison/pz_idle2.wav",
	["Idle 2"] = "npc/zombie_poison/pz_idle3.wav",
	["Idle 3"] = "npc/zombie_poison/pz_idle4.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/Zombie/Poison.mdl"),
				Bodygroups = {
					headcrab1 = 1,
					headcrab2 = 1,
					headcrab3 = 1,
					headcrab4 = 1
				}
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 55, 150, 210, 55
	end
end

return ITEM