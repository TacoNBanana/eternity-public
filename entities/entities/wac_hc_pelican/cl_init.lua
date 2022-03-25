include("shared.lua")

ENT.thirdPerson = {
	distance = 1500,
	angle = 10
}

function ENT:CustomThink()
	if not self:GetNWBool("locked") then
		self:AnimateWings()
		self:AnimateHatch()
		self:AnimateLandingGear()
	end
end

function ENT:AnimateWings()
	local angVel = self:GetAngularVelocity()
	local clampedAngVel = math.Clamp(angVel:Dot(self:GetUp()), -60, 60)
	local clampedRollVel = math.Clamp(angVel:Dot(self:GetForward()), -20, 20)

	local rotFront = math.Remap(clampedAngVel, -60, 60, 10, -10)
	local rotRear = math.Remap(clampedAngVel, -60, 60, -10, 10)

	local rollFront = math.Remap(clampedRollVel, -20, 20, -10, 10)
	local rollBack = math.Remap(clampedRollVel, -20, 20, 10, -10)

	local front = math.Remap(self:GetVTOLFraction(), 0, 1, -35, -10)
	local back = math.Remap(self:GetVTOLFraction(), 0, 1, -20, 0)

	local curFrontLeftAng, desFrontLeftAng = self:GetManipulateBoneAngles(14), Angle(0, 0, front + rotFront + rollFront)
	local curFrontRightAng, desFrontRightAng = self:GetManipulateBoneAngles(15), Angle(0, 0, front - rotFront - rollFront)

	local curRearRightAng, desRearRightAng = self:GetManipulateBoneAngles(16), Angle(0, 0, back + rotRear + rollBack)
	local curRearLeftAng, desRearLeftAng = self:GetManipulateBoneAngles(17), Angle(0, 0, back - rotRear - rollBack)

	self:ManipulateBoneAngles(14, LerpAngle(FrameTime() * 5, curFrontLeftAng, desFrontLeftAng))
	self:ManipulateBoneAngles(15, LerpAngle(FrameTime() * 5, curFrontRightAng, desFrontRightAng))

	self:ManipulateBoneAngles(16, LerpAngle(FrameTime() * 5, curRearRightAng, desRearRightAng))
	self:ManipulateBoneAngles(17, LerpAngle(FrameTime() * 5, curRearLeftAng, desRearLeftAng))
end

function ENT:AnimateHatch()
	local curLowerAng, desLowerAng = self:GetManipulateBoneAngles(22), Angle()
	local curUpperAng, desUpperAng = self:GetManipulateBoneAngles(23), Angle()

	if self:GetHatchOpen() then
		desLowerAng = Angle(0, 0, -100)
		desUpperAng = Angle(0, 0, -30)
	end

	self:ManipulateBoneAngles(22, LerpAngle(FrameTime() * 1.5, curLowerAng, desLowerAng))
	self:ManipulateBoneAngles(23, LerpAngle(FrameTime(), curUpperAng, desUpperAng))
end

function ENT:AnimateLandingGear()
	local curLeftAng, desLeftAng = self:GetManipulateBoneAngles(2), Angle()
	local curRightAng, desRightAng = self:GetManipulateBoneAngles(6), Angle()

	local curFrontAng, desFrontAng = self:GetManipulateBoneAngles(9), Angle()
	local curHatchRAng, desHatchRAng = self:GetManipulateBoneAngles(5), Angle()
	local curHatchLAng, desHatchLAng = self:GetManipulateBoneAngles(11), Angle()

	if self:GetLandingGearDown() then
		desLeftAng = Angle(-42, -25, 0)
		desRightAng = Angle(-42, 25, 0)

		desFrontAng = Angle(90, 0, 0)
		desHatchRAng = Angle(5, 6, -60)
		desHatchLAng = Angle(5, -6, 60)
	end

	self:ManipulateBoneAngles(2, LerpAngle(FrameTime() * 2, curLeftAng, desLeftAng))
	self:ManipulateBoneAngles(6, LerpAngle(FrameTime() * 2, curRightAng, desRightAng))

	self:ManipulateBoneAngles(9, LerpAngle(FrameTime() * 2, curFrontAng, desFrontAng))
	self:ManipulateBoneAngles(5, LerpAngle(FrameTime() * 2, curHatchRAng, desHatchRAng))
	self:ManipulateBoneAngles(11, LerpAngle(FrameTime() * 2, curHatchLAng, desHatchLAng))
end