SWEP.CrossAmount = 0
SWEP.CrossAlpha = 255

function SWEP:CrosshairVisible()
	if not GAMEMODE:GetSetting("hud_enabled") then
		return false
	end

	if not GAMEMODE:GetSetting("weapon_crosshairs") then
		return false
	end

	if LocalPlayer():IsInEditMode() then
		return true
	end

	if self:ShouldLower() then
		return false
	end

	if self:GetAmmoType() == "" then
		return false
	end

	if self:AimingDownSights() then
		return false
	end

	if self:GetBroken() then
		return false
	end

	return true
end

function SWEP:DoDrawCrosshair(x, y)
	local FT = FrameTime()
	local ply = self.Owner

	if ply:ShouldDrawLocalPlayer() then
		return true
	end

	if self:CrosshairVisible() then
		self.CrossAlpha = Lerp(FT * 15, self.CrossAlpha, 255)
	else
		self.CrossAlpha = Lerp(FT * 15, self.CrossAlpha, 0)
	end

	self.CrossAmount = Lerp(FT * 10, self.CrossAmount, (self.CurrentCone * 350) * (90 / math.Clamp(GetConVar("fov_desired"):GetInt(), 75, 90)))

	surface.SetDrawColor(0, 0, 0, self.CrossAlpha * 0.75) -- background

	surface.DrawRect(x - 13 - self.CrossAmount, y - 1, 12, 3) -- left
	surface.DrawRect(x + 3 + self.CrossAmount, y - 1, 12, 3) -- right
	surface.DrawRect(x - 1, y - 13 - self.CrossAmount, 3, 12) -- up
	surface.DrawRect(x - 1, y + 3 + self.CrossAmount, 3, 12) -- down

	surface.SetDrawColor(255, 255, 255, self.CrossAlpha) -- Foreground

	surface.DrawRect(x - 12 - self.CrossAmount, y, 10, 1) -- left
	surface.DrawRect(x + 4 + self.CrossAmount, y, 10, 1) -- right
	surface.DrawRect(x, y - 12 - self.CrossAmount, 1, 10) -- up
	surface.DrawRect(x, y + 4 + self.CrossAmount, 1, 10) -- down

	return true
end

function SWEP:DrawAimpoint()
	if not self:AimingDownSights() or self:IsReloading() then
		return
	end

	local data = self.Aimpoint

	if not data then
		return
	end

	local diff = self:AimPosDiff(self:GetAimOffset())

	-- draw the reticle only when it's close to center of the aiming position
	if diff > 0.9 and diff < 1.1 then
		cam.IgnoreZ(true)
			local limit = 0.13
			local dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, limit)
			local col = GAMEMODE:GetSetting("weapon_aimpoint_enabled") and GAMEMODE:GetSetting("weapon_aimpoint_color") or data.Color

			col.a = (limit - dist) / limit * 150

			local ang = self.VM:GetAngles()

			ang:RotateAroundAxis(ang:Right(), -self.BlendAng.x)

			if self.ViewModelFlip then
				ang:RotateAroundAxis(ang:Up(), self.BlendAng.y)
				ang:RotateAroundAxis(ang:Forward(), self.BlendAng.z)
			else
				ang:RotateAroundAxis(ang:Up(), -self.BlendAng.y)
				ang:RotateAroundAxis(ang:Forward(), -self.BlendAng.z)
			end

			local pos = EyePos() + ang:Forward() * 100

			render.SetMaterial(data.Material)
			render.DrawSprite(pos, data.Size, data.Size, col)
		cam.IgnoreZ(false)
	end
end