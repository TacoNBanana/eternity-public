DEFINE_BASECLASS("eternity_base")

function SWEP:GetAimOffset()
	return Vector(self.AimOffset.pos), Angle(self.AimOffset.ang)
end

function SWEP:GetADSFactor()
	local target = self:GetAimOffset()

	return 1 - (self.BlendPos:Distance(target) / target:Length())
end

function SWEP:GetViewBobIntensity()
	if self.Owner:IsInEditMode() then
		return 0
	end

	if self:AimingDownSights() then
		return BaseClass.GetViewBobIntensity(self) * 0.2
	end

	return BaseClass.GetViewBobIntensity(self)
end