SWEP.BlendPos = Vector()
SWEP.BlendAng = Angle()

SWEP.RecoilPos = Vector()
SWEP.RecoilAng = Angle()

SWEP.OldDelta = Angle()

SWEP.AngleDelta = Angle()
SWEP.AngleDelta2 = Angle()

SWEP.PosMod = Vector()
SWEP.AngMod = Angle()

SWEP.RunTime = 0
SWEP.FireMove = 0

SWEP.RecoilPos = Vector()
SWEP.RecoilAng = Angle()

SWEP.RecoilPos2 = Vector()
SWEP.RecoilAng2 = Angle()

SWEP.RecoilLowerSpeed = 0

-- The default viewmodel is used as the source for bullet tracers, so it needs to be in the correct position
function SWEP:GetViewModelPosition(pos, ang)
	if not self.VM or not IsValid(self.VM) then
		return
	end

	self.VM:SetupBones()

	pos = self.VM:GetPos()
	ang = self.VM:GetAngles()

	return pos, ang
end

function SWEP:ProcessVMSway(FT)
	local eye = EyeAngles()
	local delta = Angle(eye.p, eye.y, 0) - self.OldDelta

	delta.p = math.Clamp(-delta.p, -5, 5)

	self.AngleDelta2 = LerpAngle(math.Clamp(FT * 12, 0, 1), self.AngleDelta2, self.AngleDelta)

	local angDiff = Angle(self.AngleDelta.p - self.AngleDelta2.p, self.AngleDelta.y - self.AngleDelta2.y, 0)

	self.AngleDelta = LerpAngle(math.Clamp(FT * 10, 0, 1), self.AngleDelta, delta + angDiff)
	self.AngleDelta.y = math.Clamp(self.AngleDelta.y, -25, 25)

	self.OldDelta.p = eye.p
	self.OldDelta.y = eye.y
end

-- Sets up the position and angles of the custom VM
function SWEP:HandleVMOffsets()
	local CT = UnPredictedCurTime()
	local FT = FrameTime()

	local ply = self.Owner

	local vel = ply:GetVelocity():Length()
	local walk = ply:GetWalkSpeed()

	local pos = Vector()
	local ang = Angle()

	self:ProcessVMSway(FT)

	if vel < (walk * self.RunThreshold) or not ply:OnGround() then
		-- Idle sway
		local mult = 1

		if self.Owner:IsInEditMode() then
			mult = 0
		elseif self.AimingDownSights and self:AimingDownSights() then
			mult = 0.2
		end

		local sin = math.sin(CT) * mult
		local cos = math.cos(CT) * mult
		local tan = math.atan(cos * sin, cos * sin) * math.max(mult, 1)

		ang.p = ang.p + tan * 1.15
		ang.y = ang.y + cos * 0.4
		ang.r = ang.r + tan

		pos.y = pos.y + tan * 0.2
	end

	pos, ang = self:WalkBob(pos, ang)

	if self:IsSprinting() then
		-- Sprint sway
		local run = ply:GetRunSpeed()
		local mult = math.Clamp(vel / run, 0, 1)

		self.RunTime = self.RunTime + FT * (7.5 + math.Clamp(vel / 120, 0, 5))

		local runtime = self.RunTime

		local sin1 = math.sin(runtime) * mult
		local cos1 = math.cos(runtime) * mult
		local tan1 = math.atan(cos1 * sin1, cos1 * sin1) * mult

		ang.p = ang.p + tan1 * mult * self.VMMovementScale
		ang.y = ang.y - sin1 * -10 * mult * self.VMMovementScale
		ang.r = ang.r + cos1 * 4 * mult * self.VMMovementScale

		pos.x = pos.x - cos1 * 0.6 * mult * self.VMMovementScale
		pos.y = pos.y + sin1 * 0.6 * mult * self.VMMovementScale
		pos.z = pos.z + tan1 * 2 * mult * self.VMMovementScale
	end

	local TargetPos, TargetAng = self:GetVMTarget()

	self.BlendPos = LerpVector(FT * self.ApproachSpeed, self.BlendPos, TargetPos)
	self.BlendAng = LerpAngle(FT * self.ApproachSpeed, self.BlendAng, TargetAng)

	self.PosMod = LerpVector(FT * 10, self.PosMod, pos)
	self.AngMod = LerpAngle(FT * 10, self.AngMod, ang)

	-- Handle recoil
	self.RecoilLowerSpeed = math.Approach(self.RecoilLowerSpeed, 10, FT * 10)

	self.RecoilPos2 = LerpVector(FT * self.RecoilLowerSpeed * 0.9, self.RecoilPos2, self.RecoilPos)
	self.RecoilAng2 = LerpAngle(FT * self.RecoilLowerSpeed * 0.9, self.RecoilAng2, self.RecoilAng)

	local diffPos = self.RecoilPos - self.RecoilPos2
	local diffAng = self.RecoilAng - self.RecoilAng2

	self.RecoilPos = LerpVector(FT * self.RecoilLowerSpeed, self.RecoilPos, diffPos)
	self.RecoilAng = LerpAngle(FT * self.RecoilLowerSpeed, self.RecoilAng, diffAng)

	self.FireMove = Lerp(FT * 15, self.FireMove, 0)
end

-- Gets the target position for the viewmodel
function SWEP:GetVMTarget()
	local ply = self.Owner
	local eye = EyeAngles()

	local vel = ply:GetVelocity()
	local len = vel:Length()

	local TargetPos = Vector(self.DefaultOffset.pos)
	local TargetAng = Angle(self.DefaultOffset.ang)

	if self:ShouldLower() then
		TargetPos = Vector(self.LoweredOffset.pos)
		TargetAng = Angle(self.LoweredOffset.ang)

		-- Offset the weapon depending on the view pitch
		local verticalOffset = EyeAngles().p * 0.4

		TargetAng.x = TargetAng.x - math.Clamp(verticalOffset, 0, 10) * 1
		TargetAng.y = TargetAng.y - verticalOffset * 0.5 * 1
		TargetAng.z = TargetAng.z - verticalOffset * 0.2 * 1

		TargetPos.z = TargetPos.z + math.Clamp(verticalOffset * 0.2, -10, 3)
	elseif self.AimingDownSights and self:AimingDownSights() then
		TargetPos, TargetAng = self:GetAimOffset()
	end

	-- Apply a roll based on our sideways velocity
	local roll = math.Clamp((vel:Dot(eye:Right()) * 0.04) * len / ply:GetWalkSpeed(), -5, 5)

	if self.ViewModelFlip then
		TargetAng.z = TargetAng.z - roll
	else
		TargetAng.z = TargetAng.z + roll
	end

	return TargetPos, TargetAng
end

-- Applies the VM position and angles
function SWEP:ApplyVMOffsets()
	local pos = EyePos()
	local ang = EyeAngles()

	-- Apply the weapon's position
	ang:RotateAroundAxis(ang:Right(), self.BlendAng.x + self.RecoilAng.p)

	local sway = self.Owner:IsInEditMode() and 0 or self.SwayIntensity

	if self.ViewModelFlip then
		ang:RotateAroundAxis(ang:Up(), -self.BlendAng.y + self.RecoilAng.y - self.AngleDelta.y * 0.4 * sway)
		ang:RotateAroundAxis(ang:Forward(), -self.BlendAng.z + self.RecoilAng.r + self.AngleDelta.y * 0.4 * sway)

		pos = pos - (self.BlendPos.x - self.AngleDelta.y * 0.05 * sway - self.RecoilPos.z) * ang:Right()
	else
		ang:RotateAroundAxis(ang:Up(), self.BlendAng.y + self.RecoilAng.y - self.AngleDelta.y * 0.4 * sway)
		ang:RotateAroundAxis(ang:Forward(), self.BlendAng.z + self.RecoilAng.r + self.AngleDelta.y * 0.4 * sway)

		pos = pos + (self.BlendPos.x + self.AngleDelta.y * 0.05 * sway + self.RecoilPos.z) * ang:Right()
	end

	pos = pos + (self.BlendPos.y - self.FireMove - self.RecoilPos.y) * ang:Forward()
	pos = pos + (self.BlendPos.z - self.AngleDelta.p * 0.1 * sway - self.RecoilPos.z) * ang:Up()

	-- Offset the position
	ang:RotateAroundAxis(ang:Right(), self.AngMod.p)

	ang:RotateAroundAxis(ang:Up(), self.AngMod.y)
	ang:RotateAroundAxis(ang:Forward(), self.AngMod.r)

	pos = pos + self.PosMod.x * ang:Right()
	pos = pos + self.PosMod.y * ang:Forward()
	pos = pos + self.PosMod.z * ang:Up()

	if self.IsValid(self.VM) and not self.DevFrozen then
		self.VM:SetPos(pos)
		self.VM:SetAngles(ang)
	end
end

function SWEP:ApplyVMRecoil(mult)
	mult = mult or 1

	local power = 0.25

	local up = math.Rand(0.3, 0.4) * power * 2 * mult
	local forward = math.Rand(0.75, 0.85) * power * mult
	local side = math.Rand(-0.2, 0.2) * power * 0.5 * mult
	local roll = math.Rand(-0.25, 0.25) * power * 5 * mult

	local strength = math.Clamp(self.Recoil, 0.3, 1.8)

	self.RecoilLowerSpeed = 5

	self.RecoilPos.y = strength * forward * 10
	self.RecoilPos.z = strength * side

	self.RecoilAng.p = strength * up * (self.RecoilMult or 10)
	self.RecoilAng.y = strength * side
	self.RecoilAng.r = strength * roll * 2
end

function SWEP:AimPosDiff(pos, ang)
	local sway = (self.AngleDelta.p * 0.75 + self.AngleDelta.y * 0.25) * 0.05

	pos = Vector(self.BlendPos - pos)
	ang = Vector(self.BlendAng - ang)

	ang.z = 0

	pos = pos:Length()
	ang = ang:Length() - sway

	local dependance = pos + ang

	return 1 - dependance
end

SWEP.TI = 0
SWEP.WalkTI = 0
SWEP.WalkPos = Vector()
SWEP.WalkPos2 = Vector()

local rateScale = 2
local walkRate = 160 / 60 * (math.pi * 2) / 1.085 / 2 * rateScale

function SWEP:GetViewBobIntensity()
	local ply = self.Owner

	return math.min(ply:GetVelocity():Length2D() / ply:GetWalkSpeed(), 1)
end

function SWEP:WalkBob(pos, ang)
	local FT = FrameTime()
	local ply = self.Owner
	local vel = ply:GetVelocity():Length2D()

	local velocity = math.max(vel - ply:GetVelocity().z * 0.5, 0)
	local rate = math.min(math.max(0.15, math.sqrt(velocity / ply:GetRunSpeed()) * 1.75), self:IsSprinting() and 5 or 1)
	local intensity = self:GetViewBobIntensity()

	self.TI = self.TI + (FT * rate)
	self.WalkTI = self.WalkTI + FT * 160 / 60 * vel / ply:GetWalkSpeed()

	self.WalkPos.x = Lerp(FT * 5 * rateScale, self.WalkPos.x, -math.sin(self.TI * walkRate * 0.5) * intensity)
	self.WalkPos.y = Lerp(FT * 5 * rateScale, self.WalkPos.y, math.sin(self.TI * walkRate) / 1.5 * intensity)

	self.WalkPos2.x = Lerp(FT * 5 * rateScale, self.WalkPos2.x, -math.sin((self.TI * walkRate * 0.5) + math.pi / 3) * intensity)
	self.WalkPos2.y = Lerp(FT * 5 * rateScale, self.WalkPos2.y, math.sin(self.TI * walkRate + math.pi / 3) / 1.5 * intensity)

	pos:Add(self.WalkPos.x * 0.33 * Vector(1, 0, 0))
	pos:Add(self.WalkPos.y * 0.25 * Vector(0, 0, 1))

	ang:RotateAroundAxis(ang:Right(), -self.WalkPos2.y)
	ang:RotateAroundAxis(ang:Up(), self.WalkPos2.x)
	ang:RotateAroundAxis(ang:Forward(), self.WalkPos.x)

	return pos, ang
end