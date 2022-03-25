include("shared.lua")

ENT.thirdPerson = {
	distance = 500,
}

function ENT:CustomThink()
	if not self:GetNWBool("locked") then
		self:AnimateRotors()
		self:AnimateWings()
		self:AnimateHeatwave()
	end
end


function ENT:AnimateRotors()
	local rpm = self:GetNWFloat("rotorRpm") * 2000
	self.RPM = self.RPM and (self.RPM + rpm * FrameTime()) or 0

	local rotLeft = Matrix()
	rotLeft:SetAngles(Angle(80, 0, 5))
	rotLeft:Rotate(Angle(0, self.RPM, 0))

	local rotRight = Matrix()
	rotRight:SetAngles(Angle(100, -2, -2))
	rotRight:Rotate(Angle(0, -self.RPM, 0))

	self:ManipulateBoneAngles(5, rotLeft:GetAngles())
	self:ManipulateBoneAngles(8, rotRight:GetAngles())
end

function ENT:AnimateWings()
	local angVel = self:GetAngularVelocity()
	local clampedAngVel = math.Clamp(angVel:Dot(self:GetUp()), -60, 60)

	local rotLeft = math.Remap(clampedAngVel, -60, 60, 30, -20)
	local rotRight = math.Remap(clampedAngVel, -60, 60, -20, 30)

	local curLeftAng, desLeftAng = self:GetManipulateBoneAngles(3), Angle(rotLeft * self.rotorRpm, 0, 0)
	local curRightAng, desRightAng = self:GetManipulateBoneAngles(6), Angle(rotRight * self.rotorRpm, 0, 0)

	self:SetPoseParameter("steering", 0)
	self:InvalidateBoneCache()

	self:ManipulateBoneAngles(3, LerpAngle(FrameTime() * 10, curLeftAng, desLeftAng))
	self:ManipulateBoneAngles(6, LerpAngle(FrameTime() * 10, curRightAng, desRightAng))
end

-- heatwave
local cureffect = 0
function ENT:AnimateHeatwave()
	local throttle = self:GetNWFloat("up", 0)
	local active = self:GetNWBool("active", false)
	local v = LocalPlayer():GetVehicle()

	if IsValid(v) then
		local ent = v:GetNWEntity("wac_aircraft")

		if self == ent and active and throttle > 0 and CurTime() > cureffect then
			cureffect = CurTime() + 0.1

			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(Vector(5, 115, 85))
				ed:SetMagnitude(throttle)
				ed:SetRadius(8)
			util.Effect("wac_halo_effect", ed)

				ed:SetOrigin(Vector(5, -115, 85))
			util.Effect("wac_halo_effect", ed)
		end
	end
end