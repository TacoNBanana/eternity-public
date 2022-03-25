local meta = FindMetaTable("Entity")

function meta:GetDoorTextPos(reversed)
	local center = self:WorldSpaceCenter()

	local trace = {
		endpos = center,
		filter = ents.FindInSphere(center, 20)
	}

	for k, v in pairs(trace.filter) do
		if v == self then
			trace.filter[k] = nil
		end
	end

	local size = self:OBBMins() - self:OBBMaxs()

	size.x = math.abs(size.x)
	size.y = math.abs(size.y)
	size.z = math.abs(size.z)

	local offset
	local width = 0

	if size.z < size.x and size.z < size.y then
		offset = self:GetUp() * size.z
		width = size.y
	elseif size.x < size.y then
		offset = self:GetForward() * size.x
		width = size.y
	elseif size.y < size.x then
		offset = self:GetRight() * size.y
		width = size.x
	end

	if reverse then
		trace.start = center - offset
	else
		trace.start = center + offset
	end

	local tr = util.TraceLine(trace)

	if tr.HitWorld then
		if not reversed then
			return self:GetDoorTextPos(true)
		else
			return false
		end
	end

	local ang = tr.HitNormal:Angle()
	local ang2 = tr.HitNormal:Angle()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	ang2:RotateAroundAxis(ang2:Forward(), 90)
	ang2:RotateAroundAxis(ang2:Right(), -90)

	local len = (center - tr.HitPos):Length() + 1

	local pos = center - (len * tr.HitNormal)
	local pos2 = center + (len * tr.HitNormal)

	return {
		Pos = pos,
		Ang = ang,
		Pos2 = pos2,
		Ang2 = ang2,
		Width = math.abs(width)
	}
end

function meta:GetDoorColor()
	local door = self:DoorType()

	if door == DOOR_NOCONFIG then
		return Color(255, 0, 0)
	elseif door == DOOR_PUBLIC then
		return Color(0, 120, 0)
	elseif door == DOOR_BUYABLE then
		return Color(255, 255, 100)
	elseif door == DOOR_COMBINE then
		return Color(33, 106, 196)
	elseif door == DOOR_IGNORED then
		return Color(255, 255, 255)
	end
end

function meta:GetDoorSubtitle(name)
	local door = self:DoorType()

	if door == DOOR_BUYABLE then
		if self:IsOwned() then
			return self:DoorCustomName() != "" and self:DoorCustomName() or "This door is owned"
		else
			return "This door can be purchased"
		end
	end

	return self:DoorSubtitle()
end

function GM:DrawDoorEdit()
	local groups = {}

	for _, v in pairs(self.Doors) do
		if not IsValid(v) then
			continue
		end

		local group = v:DoorGroup()

		if group != "" then
			groups[group] = groups[group] or {}

			table.insert(groups[group], v:WorldSpaceCenter())
		end

		if v:IsDormant() then
			continue
		end

		render.SetColorMaterial()
		render.DrawBox(v:GetPos(), v:GetAngles(), v:OBBMins() - Vector(0.1, 0.1, 0.1), v:OBBMaxs() + Vector(0.1, 0.1, 0.1), ColorAlpha(v:GetDoorColor(), 50), true)
	end

	for k, v in pairs(groups) do
		if #v <= 1 then
			continue
		end

		render.SetColorMaterial()

		local pos = Vector()

		for _, vec in pairs(v) do
			pos = pos + vec
		end

		pos = pos / #v

		render.DepthRange(0, 0)
			for _, vec in pairs(v) do
				render.DrawLine(vec, pos, Color(0, 120, 0), true)
			end

			render.DrawBox(pos, Angle(), Vector(-1, -1, -1) * 5, Vector(1, 1, 1) * 5, Color(0, 120, 0, 100), true)

			GAMEMODE:DrawWorldText(pos + Vector(0, 0, 5), k)
		render.DepthRange(0, 1)
	end
end

function GM:DrawDoorInfo()
	local config = self:GetConfig("EntityRange")
	local colors = self:GetConfig("UIColors")

	local done = {}

	for _, v in pairs(self.Doors) do
		if done[v] then
			continue
		end

		done[v] = true

		if not IsValid(v) or v:IsDormant() then
			continue
		end

		local name = v:DoorName()

		if name == "" then
			continue
		end

		local alpha = math.ClampedRemap(EyePos():Distance(v:WorldSpaceCenter()), config.Max, config.Min, 0, 255)

		if alpha > 0 then
			local data = v:GetDoorTextPos()

			if not data then
				continue
			end

			surface.SetFont("eternity.labelworld")

			local sub = v:GetDoorSubtitle()

			local w1, h = surface.GetTextSize(name)
			local w2 = surface.GetTextSize(sub)

			local scale1 = math.min(math.abs((data.Width * 0.6) / w1), 0.04)
			local scale2 = math.min(math.abs((data.Width * 0.6) / w2), 0.02)

			if name != "" then
				local color = ColorAlpha(colors.TextNormal, alpha)

				cam.Start3D2D(data.Pos, data.Ang, scale1)
					draw.SimpleTextOutlined(name, "eternity.labelworld", 0, -h, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				cam.End3D2D()

				cam.Start3D2D(data.Pos2, data.Ang2, scale1)
					draw.SimpleTextOutlined(name, "eternity.labelworld", 0, -h, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				cam.End3D2D()
			end

			if sub != "" then
				local color = ColorAlpha(colors.Primary, alpha)

				cam.Start3D2D(data.Pos, data.Ang, scale2)
					draw.SimpleTextOutlined(sub, "eternity.labelworld", 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				cam.End3D2D()

				cam.Start3D2D(data.Pos2, data.Ang2, scale2)
					draw.SimpleTextOutlined(sub, "eternity.labelworld", 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				cam.End3D2D()
			end
		end
	end
end

local lock = Material("sprites/light_glow02_add")

function GM:DrawCombineLocks()
	for _, v in pairs(self.Doors) do
		if not IsValid(v) or v:IsDormant() or not v:CombineLock() then
			continue
		end

		local offset = v:CombineLockSide() and Vector(12.5, 42.7, -8.7) or Vector(-12.5, 42.7, -8.7)
		local pos = v:LocalToWorld(offset)

		render.SetMaterial(lock)
		render.DrawSprite(pos, 8, 8, v:DoorLocked() and Color(255, 0, 0) or Color(0, 255, 0))
	end
end

hook.Add("PostDrawTranslucentRenderables", "doors.PostDrawTranslucentRenderables", function(depth, skybox)
	if skybox then
		return
	end

	if GAMEMODE:HUDEnabled("doors", true) then
		GAMEMODE:DrawDoorInfo()
	end

	if LocalPlayer():IsInEditMode() then
		GAMEMODE:DrawDoorEdit()
	end

	GAMEMODE:DrawCombineLocks()
end)

hook.Add("EntityCombineLockChanged", "doors.EntityCombineLockChanged", function(ent, old, new)
	if not ent:IsDoor() then
		return
	end

	part.Clear(ent)

	if new then
		if ent:CombineLockSide() then
			part.Add(ent, "CombineLock", {
				Model = "models/props_combine/combine_lock01.mdl",
				Ang = ent:GetAngles() - Angle(0, 90, 0),
				Pos = ent:LocalToWorld(Vector(7, 39, 0)),
				NoMerge = true
			})
		else
			part.Add(ent, "CombineLock", {
				Model = "models/props_combine/combine_lock01.mdl",
				Ang = ent:GetAngles() + Angle(0, 90, 0),
				Pos = ent:LocalToWorld(Vector(-7, 39, 0)),
				Scale = Vector(-1, 1, 1),
				Invert = true,
				NoMerge = true
			})
		end
	end
end)