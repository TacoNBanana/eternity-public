AMMO = class.Create("ammo_base")

AMMO.Offset = Vector(0, 0, 0)
AMMO.Entity = "ent_projectile_plasma"

function AMMO:OnFired(ply, weapon, cone)
	math.randomseed(ply:GetCurrentCommand():CommandNumber())

	local aimcone = Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0)

	if SERVER then
		local pos = LocalToWorld(self.Offset, Angle(), ply:GetShootPos(), ply:EyeAngles())

		if not util.IsInWorld(pos) then
			pos = ply:GetShootPos()
		end

		local ang = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles() + aimcone * 25):Forward():Angle()

		local ent = ents.Create(self.Entity)

		ent:SetPos(pos)
		ent:SetAngles(ang)

		ent:SetOwner(ply)

		ent:Spawn()
		ent:Activate()
	end

	weapon:EmitSound(weapon.FireSound)
end

return AMMO