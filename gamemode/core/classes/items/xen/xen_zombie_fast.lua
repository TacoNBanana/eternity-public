ITEM = class.Create("base_xen")

ITEM.Name 			= "Fast Zombie"

ITEM.Model 			= Model("models/gibs/hgibs.mdl")

ITEM.Voicelines 	= {
	["Alert"] = "npc/fast_zombie/fz_alert_close1.wav",
	["Frenzy"] = "npc/fast_zombie/fz_frenzy1.wav",
	["Scream"] = "npc/fast_zombie/fz_scream1.wav",
	["Idle 1"] = "npc/fast_zombie/idle1.wav",
	["Idle 2"] = "npc/fast_zombie/idle2.wav",
	["Idle 3"] = "npc/fast_zombie/idle3.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/Zombie/Fast.mdl"),
				Bodygroups = {
					headcrab1 = 1
				}
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 55, 215, 600, 55
	end
end

return ITEM