local emeta = FindMetaTable("Entity")
local pmeta = FindMetaTable("Player")

function emeta:CameraName()
	if self:IsPlayer() then
		return self:RPName()
	elseif self:GetClass() == "ent_camera" then
		return self:GetCameraName()
	elseif self:GetClass() == "npc_combine_camera" then
		local pos = self:GetPos()

		return string.format("%s-%s-%s", math.Round(pos.x), math.Round(pos.y), math.Round(pos.z))
	end
end

function emeta:GetCameraPos()
	if self:IsPlayer() then
		local att = self:GetAttachment(self:LookupAttachment("eyes"))

		return att.Pos, self:EyeAngles()
	elseif self:GetClass() == "ent_camera" then
		local pos = self:LocalToWorld(Vector(25.65, 0, -5))

		return LocalToWorld(Vector(12, -0.2, 4.5), Angle(), pos, self:LocalToWorldAngles(self:GetCameraAngle()))
	elseif self:GetClass() == "npc_combine_camera" then
		local att = self:GetAttachment(1)

		return LocalToWorld(Vector(4.5, 0, 0), Angle(), att.Pos, att.Ang)
	else
		return self:GetPos(), self:GetAngles()
	end
end

function pmeta:IsInCamera()
	local camera = self:Camera()

	return IsValid(camera) and self:GetViewEntity() == self
end

function pmeta:IsCameraTarget(ply)
	if self == ply then
		return false
	end

	if self:GetNoDraw() or self:Health() <= 0 then
		return false
	end

	return true
end

local binds = {
	IN_ATTACK,
	IN_ATTACK2,
	IN_RELOAD,
	IN_ZOOM,
	IN_JUMP,
	IN_DUCK
}

hook.Add("StartCommand", "camera.StartCommand", function(ply, cmd)
	if not ply:IsInCamera() then
		ply.LastViewAngles = cmd:GetViewAngles()

		return
	end

	local camera = ply:Camera()

	if camera:GetClass() == "ent_camera" then
		if SERVER then
			local zoom = camera:GetCameraZoom()
			local diff = math.ClampAngle(Angle(cmd:GetMouseY() * 0.01, -cmd:GetMouseX() * 0.01), Angle(-2, -2, 0), Angle(2, 2, 0))
			local ang = camera:GetCameraAngle() + (diff * math.ClampedRemap(zoom, 5, 90, 0.05, 1))

			ang:Normalize()

			ang.p = math.NormalizeAngle(math.Clamp(ang.p, unpack(camera.PitchRange)))
			ang.y = math.NormalizeAngle(math.Clamp(ang.y, unpack(camera.YawRange)))

			camera:SetCameraAngle(ang)
		end

		if CLIENT then
			local tab = part.Get(camera, "Camera")

			if tab and IsValid(tab.Ent) then
				tab.Ent:SetAngles(camera:LocalToWorldAngles(camera:GetCameraAngle()))
			end
		end
	end

	ply.LastViewAngles = ply.LastViewAngles or cmd:GetViewAngles()

	cmd:SetViewAngles(ply.LastViewAngles)

	for _, v in pairs(binds) do
		if cmd:KeyDown(v) then
			cmd:RemoveKey(v)
		end
	end
end)

hook.Add("FinishMove", "camera.FinishMove", function(ply, mv)
	if not ply:IsInCamera() then
		return
	end

	local camera = ply:Camera()

	if SERVER and camera:GetClass() == "ent_camera" then
		local zoom = camera:GetCameraZoom()

		if mv:KeyDown(IN_FORWARD) then
			camera:SetCameraZoom(math.Clamp(zoom - (FrameTime() * 50), unpack(camera.ZoomRange)))
		elseif mv:KeyDown(IN_BACK) then
			camera:SetCameraZoom(math.Clamp(zoom + (FrameTime() * 50), unpack(camera.ZoomRange)))
		end
	end

	return true
end)