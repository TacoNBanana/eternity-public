include("shared.lua")

ENT.thirdPerson = {
	distance = 500
}

function ENT:CustomThink()
	if not self:GetNWBool("locked") then
		self:AnimateRotors()
		self:AnimateWings()
	end
end

function ENT:AnimateRotors()
	local rpm = self:GetNWFloat("rotorRpm") * 2000
	self.RPM = self.RPM and (self.RPM + rpm * FrameTime()) or 0

	self:ManipulateBoneAngles(17, Angle(0, 0, self.RPM))
	self:ManipulateBoneAngles(18, Angle(0, 0, -self.RPM))
end

function ENT:AnimateWings()
	local angVel = self:GetAngularVelocity()
	local clampedAngVel = math.Clamp(angVel:Dot(self:GetUp()), -60, 60)

	local rotRight = math.Remap(clampedAngVel, -60, 60, -20, 30)
	local rotLeft = math.Remap(clampedAngVel, -60, 60, 30, -20)

	local curRightAng, desRightAng = self:GetManipulateBoneAngles(6), Angle(0, 0, rotRight * self.rotorRpm)
	local curLeftAng, desLeftAng = self:GetManipulateBoneAngles(9), Angle(0, 0, rotLeft * self.rotorRpm)

	self:SetPoseParameter("steering", 0)
	self:InvalidateBoneCache()

	self:ManipulateBoneAngles(6, LerpAngle(FrameTime() * 5, curRightAng, desRightAng))
	self:ManipulateBoneAngles(9, LerpAngle(FrameTime() * 5, curLeftAng, desLeftAng))
end