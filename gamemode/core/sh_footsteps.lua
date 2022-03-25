function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
	return true
end

hook.Add("EntityEmitSound", "footsteps.EntityEmitSound", function(data)
	if IsValid(data.Entity) and data.Entity:IsPlayer() and data.Volume == 1 and string.find(data.OriginalSoundName, "%.step+") then
		return false
	end
end)

if SERVER then
	local function getsurface(ply)
		local tr = util.TraceLine({
			start = ply:GetPos(),
			endpos = ply:GetPos() - Vector(0, 0, 64),
			filter = ply,
			mask = MASK_PLAYERSOLID_BRUSHONLY,
			collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
		})

		if not tr.Hit then
			return
		end

		local name = util.GetSurfacePropName(tr.SurfaceProps)

		if #name < 1 then
			name = "default"
		end

		return name
	end

	local materialvolume = {
		[MAT_CONCRETE] = {0.2, 0.5},
		[MAT_METAL] = {0.2, 0.5},
		[MAT_DIRT] = {0.25, 0.55},
		[MAT_VENT] = {0.4, 0.7},
		[MAT_GRATE] = {0.2, 0.5},
		[MAT_TILE] = {0.2, 0.5},
		[MAT_SLOSH] = {0.2, 0.5}
	}

	hook.Add("PlayerThink", "footsteps.PlayerThink", function(ply)
		ply.StepSoundTime = ply.StepSoundTime or 0
		ply.StepSoundTime = math.Max(ply.StepSoundTime - (1000 * FrameTime()), 0)
		ply.StepSide = ply.StepSide or false

		if ply.StepSoundTime > 0 then
			return
		end

		if ply:IsFlagSet(FL_FROZEN) or ply:IsFlagSet(FL_ATCONTROLS) then
			return
		end

		if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_OBSERVER then
			return
		end

		local ground = ply:IsFlagSet(FL_ONGROUND)
		local moving = ply:GetVelocity():Length2D() > 0.0001
		local ladder = ply:GetMoveType() == MOVETYPE_LADDER

		if not ladder and (not ground or not moving) then
			return
		end

		local speed = math.Round(ply:GetVelocity():Length2D())
		local walking = math.abs(ply:GetWalkSpeed() - speed) < math.abs(ply:GetRunSpeed() - speed)

		if speed < ply:GetWalkSpeed() then
			return
		end

		if ply:KeyDown(IN_WALK) then
			walking = true
		end

		local water = ply:WaterLevel()

		local volume = 0.2
		local surfaceprop = getsurface(ply)
		local snd

		if ladder then
			volume = 0.5
			surfaceprop = "ladder"

			ply.StepSoundTime = hook.Run("PlayerStepSoundTime", ply, STEPSOUNDTIME_ON_LADDER, walking)
		elseif water == 2 then
			ply.SkipStep = ply.SkipStep or 0

			if ply.SkipStep == 0 then
				ply.SkipStep = ply.SkipStep + 1

				return
			elseif ply.SkipStep + 1 == 3 then
				ply.SkipStep = 0
			end

			volume = 0.65
			surfaceprop = "wade"

			ply.StepSoundTime = hook.Run("PlayerStepSoundTime", ply, STEPSOUNDTIME_WATER_KNEE, walking)
		elseif water == 1 then
			volume = walking and 0.2 or 0.5
			surfaceprop = "water"

			ply.StepSoundTime = hook.Run("PlayerStepSoundTime", ply, STEPSOUNDTIME_WATER_FOOT, walking)
		else
			if not surfaceprop then
				return
			end

			local surfacedata = util.GetSurfaceData(util.GetSurfaceIndex(surfaceprop))
			local volumeset = materialvolume[surfacedata.material]

			ply.StepSoundTime = hook.Run("PlayerStepSoundTime", ply, STEPSOUNDTIME_NORMAL, walking)

			if volumeset then
				volume = walking and volumeset[1] or volumeset[2]
			end

			if ply:Crouching() then
				volume = volume * 0.65
			end

			snd = ply:GetActiveSpecies():OverwriteFootsteps(ply, ply.StepSide, walking)

			if not snd then
				snd = ply.StepSide and surfacedata.stepLeftSound or surfacedata.stepRightSound
			end
		end

		if not snd then
			local surfacedata = util.GetSurfaceData(util.GetSurfaceIndex(surfaceprop))

			snd = ply.StepSide and surfacedata.stepLeftSound or surfacedata.stepRightSound
		end

		ply.StepSide = not ply.StepSide

		local soundfile = snd
		local level = 75
		local pitch = 100

		local sounddata = sound.GetProperties(snd)

		if sounddata then
			soundfile = sounddata.sound
			level = sounddata.level
			pitch = sounddata.pitch or 100
		end

		if istable(soundfile) then
			soundfile = table.Random(soundfile)
		end

		if istable(pitch) then
			pitch = math.random(pitch[1], pitch[2])
		end

		ply:EmitSound(soundfile, level, pitch, volume, CHAN_AUTO)
	end)
end