FIREMODE = class.Create("firemode_semi")

FIREMODE.Automatic 	= true

FIREMODE.Name 		= "Type-33"

function FIREMODE:GetDelay()
	return self.Weapon:GetFireDuration() > self:Get("DelayRamp") and self:Get("MinDelay") or self:Get("MaxDelay")
end

return FIREMODE