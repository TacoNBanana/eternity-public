local meta = FindMetaTable("Entity")

accessor.Entity("NoDamage", "Entity", false)
accessor.Entity("PermaProp", "Entity", false)
accessor.Entity("SteamID", "Entity", false)
accessor.Entity("PlayerName", "Entity", false)
accessor.Entity("Description", "Entity", false)
accessor.Entity("FakePlayer", "Entity", false)

function GM:CanSeePos(pos1, pos2, filter)
	local tr = util.TraceLine({
		start = pos1,
		endpos = pos2,
		filter = filter,
		mask = MASK_SOLID + CONTENTS_WINDOW + CONTENTS_GRATE
	})

	return tr.Fraction == 1
end

function meta:CanSee(target)
	local filter = {self}

	if IsEntity(target) then
		if not IsValid(target) then
			return false
		end

		if target:GetNoDraw() then
			return false
		end

		table.insert(filter, target)

		target = target:EyePos()
	end

	return GAMEMODE:CanSeePos(self:EyePos(), target, filter)
end

function meta:WithinInteractRange(ply, range)
	local eye = ply:EyePos()
	local dist = self:NearestPoint(eye):DistToSqr(eye)

	range = range or GAMEMODE:GetConfig("InteractRange")
	range = range * range

	return dist <= range
end

if SERVER then
	hook.Add("EntityTakeDamage", "entity.EntityTakeDamage", function(ent, dmg)
		if ent:PermaProp() then
			dmg:ScaleDamage(0)

			return true
		end

		if (ent:IsPlayer() and ent:IsInNoClip()) or ent:NoDamage() then
			dmg:ScaleDamage(0)

			return true
		end
	end)
end