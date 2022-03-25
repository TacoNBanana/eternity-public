ITEM = class.Create("base_xen")

ITEM.Name 			= "Zombie Torso"

ITEM.Model 			= Model("models/gibs/hgibs.mdl")

ITEM.Voicelines 	= {
	["Alert 1"] = "npc/zombie/zombie_alert1.wav",
	["Alert 2"] = "npc/zombie/zombie_alert2.wav",
	["Alert 3"] = "npc/zombie/zombie_alert3.wav"
}

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = Model("models/Zombie/Classic_torso.mdl"),
				Bodygroups = {
					headcrab1 = 1
				}
			}
		}
	end

	function ITEM:GetSpeeds(ply)
		return 31, 60, 210, 31
	end
end

return ITEM