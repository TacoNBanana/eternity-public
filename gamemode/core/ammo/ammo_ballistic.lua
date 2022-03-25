AMMO = class.Create("ammo_base")

AMMO.Damage 	= 0

AMMO.Amount 	= 1
AMMO.Spread 	= 0

AMMO.Tracer 	= "tracer"

function AMMO:Callback(attacker, tr, dmginfo)
	if SERVER then
		netstream.Send("ImpactSound", {HitPos = tr.HitPos})
	end
end

function AMMO:OnFired(ply, weapon, cone)
	math.randomseed(ply:GetCurrentCommand():CommandNumber())

	local aimcone = Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0)
	local bullet = {}

	bullet.Num 			= self.Amount
	bullet.Src 			= ply:GetShootPos()
	bullet.Dir 			= (ply:GetAimVector():Angle() + ply:GetViewPunchAngles() + aimcone * 25):Forward()
	bullet.Spread 		= Vector(self.Spread, self.Spread, 0)
	bullet.Damage 		= self.Damage
	bullet.Tracer 		= 1
	bullet.TracerName 	= self.Tracer
	bullet.Force 		= self.Damage * 0.3
	bullet.AmmoType 	= ""

	bullet.Callback = function(attacker, tr, dmginfo)
		self:Callback(attacker, tr, dmginfo)
	end

	weapon:EmitSound(weapon.FireSound)

	ply:FireBullets(bullet)
end

return AMMO