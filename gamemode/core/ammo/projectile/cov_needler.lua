AMMO = class.Create("ammo_projectile")

AMMO.Name 		= "Subanese crystal"

AMMO.Offset 	= Vector(-2, -10, -5)
AMMO.Entity 	= "ent_projectile_needler"

function AMMO:OnFired(ply, weapon, cone)
	math.randomseed(ply:GetCurrentCommand():CommandNumber())

	local aimcone = Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0)

	if SERVER then
		local pos = LocalToWorld(self.Offset, Angle(), ply:GetShootPos(), ply:EyeAngles())

		if not util.IsInWorld(pos) then
			pos = ply:GetShootPos()
		end

		local ang = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles() + aimcone * 25):Forward():Angle()
		local targets = ents.FindInCone(pos, ang:Forward(), 2048, math.cos(math.rad(15)))

		local target
		local maxdist = math.huge

		for _, v in pairs(targets) do
			if not IsValid(v) or not (v:IsNPC() or v:IsPlayer()) then
				continue
			end

			if v:Health() <= 0 then
				continue
			end

			local center = v:WorldSpaceCenter()

			if not ply:VisibleVec(center) then
				continue
			end

			local dist = pos:DistToSqr(center)

			if dist >= maxdist then
				continue
			end

			target = v
			maxdist = dist
		end

		local ent = ents.Create(self.Entity)

		ent:SetPos(pos)
		ent:SetAngles(ang)

		ent:SetOwner(ply)

		if IsValid(target) then
			ent:SetTarget(target)
		end

		ent:Spawn()
		ent:Activate()
	end

	weapon:EmitSound(weapon.FireSound)
end

return AMMO