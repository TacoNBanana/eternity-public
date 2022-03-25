AMMO = class.Create()

AMMO.Name 	= ""

AMMO.Limited = false

function AMMO:OnFired(ply, weapon, cone)
	weapon:EmitSound(weapon.FireSound)
end

return AMMO