AMMO = class.Create("ammo_ballistic")

AMMO.Name 		= "12-gauge Breaching slugs"

AMMO.Damage 	= 20

AMMO.Amount 	= 1
AMMO.Spread 	= 0

AMMO.Tracer 	= "tracer"

function AMMO:Callback(attacker, tr, dmginfo)
	if SERVER then
		sound.Play("bullet_impact", tr.HitPos, 120, 100, 1)

		local ent = tr.Entity

		if not IsValid(ent) or not ent:IsDoor() then
			return
		end

		local classname = ent:GetClass()

		if classname != "prop_door_rotating" and classname != "func_door_rotating" then
			return
		end

		if ent:DoorType() == DOOR_COMBINE or ent:DoorType() == DOOR_IGNORED then
			return
		end

		local pos = dmginfo:GetDamagePosition()

		if pos:DistToSqr(attacker:EyePos()) > 130^2 then
			return
		end

		local handle = ent:LookupBone("handle")

		if not handle or pos:DistToSqr(ent:GetBonePosition(handle)) > 8^2 then
			return
		end

		ent:RamDoor(attacker)
	end
end

return AMMO