FIREMODE = class.Create("firemode_plasmarifle")

FIREMODE.Automatic 	= false

FIREMODE.ClipSize 		= -1
FIREMODE.Name 			= "Type-25"
FIREMODE.Ammo 			= "ammo_plasmapistol"

FIREMODE.OverheatSound 	= "drc.pp_oh"

function FIREMODE:GetDelay()
	return self:Get("Delay")
end

return FIREMODE