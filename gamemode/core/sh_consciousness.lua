local emeta = FindMetaTable("Entity")
local meta = FindMetaTable("Player")

if CLIENT then
	hook.Add("CalcView", "consciousness.CalcView", function(ply, pos, ang, fov, znear, zfar)
		local ragdoll = ply:GetRagdoll()

		if IsValid(ragdoll) then
			local min, max = ragdoll:GetRenderBounds()
			local radius = (min - max):Length()
			local target = (ragdoll:GetPos() + Vector(0, 0, 10)) + (min + max) / 2 + ang:Forward() * -radius

			tr = util.TraceHull({
				start = pos,
				endpos = target,
				filter = {ragdoll, ply},
				mins = Vector(-4, -4, -4),
				maxs = Vector(4, 4, 4)
			})

			local hit = tr.HitPos

			if tr.Hit and not tr.StartSolid then
				hit = hit + tr.HitNormal * 4
			end

			return {
				origin = hit,
				angles = ang,
				fov = fov,
				znear = znear,
				zfar = zfar,
				drawviewer = true
			}
		end
	end)

	hook.Add("EntityFakePlayerChanged", "consciousness.EntityFakePlayerChanged", function(ent, old, new)
		if IsValid(new) then
			part.Copy(new, ent)
		else
			part.Clear(ent)
		end
	end)
end

function meta:GetRagdoll()
	local index = self:RagdollIndex()

	if not index then
		return NULL
	end

	return Entity(index)
end

if SERVER then
	hook.Add("PlayerConsciousnessChanged", "consciousness.PlayerConsciousnessChanged", function(ply, old, new)
		if new == 0 and not IsValid(ply:GetRagdoll()) then
			ply:PassOut()
		elseif new == 100 and IsValid(ply:GetRagdoll()) then
			ply:WakeUp()
		end
	end)

	hook.Add("PlayerThink", "consciousness.PlayerThink", function(ply)
		ply.NextConsciousnessTick = ply.NextConsciousnessTick or CurTime()

		if ply.NextConsciousnessTick <= CurTime() and ply:Consciousness() < 100 and ply:Alive() then
			local ragdoll = ply:GetRagdoll()

			if IsValid(ragdoll) then
				ply:SetPos(ragdoll:GetPos())

				if ragdoll:GetVelocity():Length() > 15 then
					return
				end
			end

			ply:TakeCDamage(-1)
			ply.NextConsciousnessTick = CurTime() + GAMEMODE:GetConfig("ConsciousnessRate")
		end
	end)

	hook.Add("EntityTakeDamage", "consciousness.EntityTakeDamage", function(ent, dmg)
		local ply = ent:FakePlayer()

		if not IsValid(ply) then
			return
		end

		if dmg:GetDamageType() == DMG_CRUSH then
			return
		end

		ply:TakeDamageInfo(dmg)
	end)

	hook.Add("EntityRemoved", "consciousness.EntityRemoved", function(ent)
		local ply = ent:FakePlayer()

		if not IsValid(ply) or ply:Consciousness() >= 100 then
			return
		end

		ply:SetConsciousness(0)
		ply:Kill()
	end)

	function emeta:TakeCDamage(amt)
		local ent = self

		if ent:GetClass() == "prop_ragdoll" then
			ent = ent:FakePlayer()

			if not IsValid(ent) then
				return
			end
		end

		if not ent:IsPlayer() then
			return
		end

		ent:SetConsciousness(math.Clamp(ent:Consciousness() - amt, 0, 100))
	end

	function meta:SetRagdoll(ent)
		self:SetRagdollIndex(ent:EntIndex())
	end

	function meta:ClearRagdoll()
		if IsValid(self:GetRagdoll()) then
			self:GetRagdoll():Remove()
		end

		self:SetRagdollIndex(false)
	end

	function meta:CreateRagdollClone()
		if IsValid(self:GetRagdoll()) then
			self:GetRagdoll():Remove()
		end

		local ragdoll = ents.Create("prop_ragdoll")

		ragdoll:SetPos(self:GetPos())
		ragdoll:SetAngles(self:GetAngles())

		local data = self:ModelData()

		if data._base then
			ragdoll:ApplyModel(data._base)
		end

		ragdoll:Spawn()
		ragdoll:Activate()

		ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
			local bone = ragdoll:GetPhysicsObjectNum(i)

			if IsValid(bone) then
				local pos, ang = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))

				if pos and ang then
					bone:SetPos(pos)
					bone:SetAngles(ang)
				end
			end
		end

		ragdoll:SetFakePlayer(self)
		self:SetRagdoll(ragdoll)
	end

	function meta:PassOut()
		if self:FlashlightIsOn() then
			self:Flashlight(false)
		end

		self:AllowFlashlight(false)

		self:ExitVehicle()
		self:SetNoTarget(true)
		self:SetNoDraw(true)
		self:SetNotSolid(true)

		self:SetMoveType(MOVETYPE_NONE)

		local species = self:GetActiveSpecies()

		self:SelectWeapon(species.WeaponLoadout[1])

		self:CreateRagdollClone()
	end

	function meta:WakeUp(spawn)
		if not spawn and IsValid(self:GetRagdoll()) then
			self:SetPos(self:GetRagdoll():GetPos())
		end

		self:ClearRagdoll()

		self:AllowFlashlight(true)

		self:SetNoTarget(false)
		self:SetNoDraw(false)
		self:SetNotSolid(false)

		self:SetMoveType(MOVETYPE_WALK)
	end
end