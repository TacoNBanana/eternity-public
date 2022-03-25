hook.Add("CalcView", "camera.CalcView", function(ply, pos, ang, fov, znear, zfar)
	local camera = ply:Camera()

	if ply:IsInCamera() then
		local view = {
			origin = pos,
			angles = ang,
			fov = fov,
			znear = 0.5,
			zfar = zfar,
			drawviewer = true
		}

		view.origin, view.angles = camera:GetCameraPos()

		if camera:IsPlayer() then
			camera:ManipulateBoneScale(camera:LookupBone("ValveBiped.Bip01_Head1"), Vector(0, 0, 0))
		elseif camera:GetClass() == "ent_camera" then
			view.fov = camera:GetCameraZoom()
		end

		return view
	elseif IsValid(camera) and camera:IsPlayer() then
		camera:ManipulateBoneScale(camera:LookupBone("ValveBiped.Bip01_Head1"), Vector(1, 1, 1))
	end
end)

function GM:DrawCameraHUD(camera)
	local pos = camera:GetPos()
	local ang = select(2, camera:GetCameraPos())
	local w, h = ScrW() * 0.5, ScrH() * 0.5
	local w2, h2 = 290, 210

	local x = w - w2
	local y = h - h2

	self:DrawCameraTargets()

	local textx = x + 8
	local texty = y + 8

	local function addText(text)
		if text and #text > 0 then
			draw.SimpleText(text, "eternity.camera", textx, texty, Color(255, 255, 255))
		end

		texty = texty + 18
	end

	addText(string.format("ID %s", camera:CameraName()))
	addText()
	addText(string.format("POS (%s, %s, %s)", math.Round(pos.x), math.Round(pos.y), math.Round(pos.z)))
	addText(string.format("ANG (%s, %s, %s)", math.Round(ang.p), math.Round(ang.y), math.Round(ang.r)))

	if camera:GetClass() == "ent_camera" then
		local zoom = math.Round(math.ClampedRemap(camera:GetCameraZoom(), camera.ZoomRange[1], camera.ZoomRange[2], 100, 0))

		addText(string.format("ZOOM %s%%", zoom))
	end

	surface.SetDrawColor(235, 235, 235, 230)

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = w + w2

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = w - w2
	y = h + h2

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y - 128)

	x = w + w2

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y - 128)

	surface.DrawLine(w - 48, h, w - 8, h)
	surface.DrawLine(w + 48, h, w + 8, h)
	surface.DrawLine(w, h - 48, w, h - 8)
	surface.DrawLine(w, h + 48, w, h + 8)
end

function GM:DrawCameraTargets()
	local targets = {}

	for _, v in pairs(player.GetAll()) do
		if not IsValid(v) or v:IsDormant() then
			continue
		end

		if v:GetNoDraw() then
			continue
		end

		local vis = v:GetVisible()

		if vis == 0 then
			continue
		end

		local min = v:OBBMins()
		local max = v:OBBMaxs()
		local ang = v:GetAngles()

		local positions = {
			LocalToWorld(Vector(max.x, max.y, max.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(max.x, min.y, max.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(max.x, max.y, min.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(max.x, min.y, min.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(min.x, max.y, max.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(min.x, min.y, max.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(min.x, max.y, min.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen(),
			LocalToWorld(Vector(min.x, min.y, min.z), Angle(), v:GetPos(), Angle(0, ang.y, 0)):ToScreen()
		}

		local hudmin = Vector(math.floor(positions[1].x), math.floor(positions[1].y), 0)
		local hudmax = Vector(math.ceil(positions[1].x), math.ceil(positions[1].y), 0)

		for i = 2, 8 do
			local pos = positions[i]

			hudmin.x = math.min(hudmin.x, math.floor(pos.x))
			hudmin.y = math.min(hudmin.y, math.floor(pos.y))

			hudmax.x = math.max(hudmax.x, math.ceil(pos.x))
			hudmax.y = math.max(hudmax.y, math.ceil(pos.y))
		end

		table.insert(targets, {
			Entity = v,
			Distance = EyePos():Distance(v:GetPos()),
			Min = hudmin,
			Max = hudmax,
			Alpha = vis
		})
	end

	for _, v in SortedPairsByMemberValue(targets, "Distance") do
		local ply = v.Entity
		local w = v.Max.x - v.Min.x
		local h = v.Max.y - v.Min.y
		local color = GAMEMODE:GetTeamColor(v.Entity)

		surface.SetAlphaMultiplier(v.Alpha)

		surface.SetDrawColor(ColorAlpha(color, 50))
		surface.DrawRect(v.Min.x, v.Min.y, w, h)

		surface.SetDrawColor(color)
		surface.DrawOutlinedRect(v.Min.x, v.Min.y, w, h)

		local x = v.Min.x + (w * 0.5)
		local y = v.Min.y - (w * 0.05)
		local scale = w * 0.0006

		self:DrawScaleText(ply:RPName(), x, y, GAMEMODE:GetTeamColor(ply), "eternity.camera2", scale)

		surface.SetAlphaMultiplier(1)
	end
end

hook.Add("PlayerCameraChanged", "camera.PlayerCameraChanged", function(ply, old, new)
	if ply != LocalPlayer() then
		return
	end

	if IsValid(old) and old:IsPlayer() then
		old:ManipulateBoneScale(old:LookupBone("ValveBiped.Bip01_Head1"), Vector(1, 1, 1))
	end
end)

hook.Add("HUDPaint", "camera.HUDPaint", function()
	if LocalPlayer():IsInCamera() then
		local camera = LocalPlayer():Camera()

		GAMEMODE:DrawCameraHUD(camera)
	end
end)

hook.Add("RenderScreenspaceEffects", "camera.RenderScreenspaceEffects", function()
	if LocalPlayer():IsInCamera() then
		local tab = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}

		DrawColorModify(tab)
	end
end)

hook.Add("ShouldDrawLocalPlayer", "camera.ShouldDrawLocalPlayer", function(ply)
	if LocalPlayer():IsInCamera() then
		return true
	end
end)

hook.Add("Think", "camera.Think", function()
	if not LocalPlayer():IsInCamera() then
		return
	end

	if input.IsKeyDown(KEY_ESCAPE) then
		gui.HideGameUI()

		netstream.Send("ResetSurveillance")
	end
end)