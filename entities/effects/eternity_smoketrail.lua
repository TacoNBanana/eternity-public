EFFECT.Mat = Material("trails/smoke")

local function translatefov(ent, pos, inverse)
	local worldx = math.tan(LocalPlayer():GetFOV() * (math.pi / 360))
	local viewx = math.tan(ent.ViewModelFOV * (math.pi / 360))

	local factor = Vector(worldx / viewx, worldx / viewx, 0)
	local tmp = pos - EyePos()

	local eye = EyeAngles()
	local transformed = Vector(eye:Right():Dot(tmp), eye:Up():Dot(tmp), eye:Forward():Dot(tmp))

	if inverse then
		transformed.x = transformed.x / factor.x
		transformed.y = transformed.y / factor.y
	else
		transformed.x = transformed.x * factor.x
		transformed.y = transformed.y * factor.y
	end

	local out = (eye:Right() * transformed.x) + (eye:Up() * transformed.y) + (eye:Forward() * transformed.z)

	return EyePos() + out
end

function EFFECT:Init(data)
	self.Pos = data:GetStart()
	self.Ent = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.Start = self:GetStartPos(self.Pos, self.Ent, self.Attachment)
	self.End = data:GetOrigin()

	self.Normal = (self.Start - self.End):Angle():Forward()

	self:SetRenderBoundsWS(self.Start, self.End)

	self.StartTime = CurTime()
	self.Lifetime = 0.5
end

function EFFECT:GetStartPos(pos, ent, index)
	if not IsValid(ent) then
		return pos
	end

	if not ent:IsWeapon() then
		return pos
	end

	if ent:IsCarriedByLocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		local vm = ent.VM

		if IsValid(vm) then
			local att = vm:GetAttachment(index)

			if att then
				return translatefov(ent, att.Pos)
			end
		end
	else
		local att = ent:GetAttachment(index)

		if att then
			return att.Pos
		end
	end

	return pos
end

function EFFECT:Think()
	if CurTime() - self.StartTime > self.Lifetime then
		return false
	end

	return true
end

function EFFECT:GetAlpha()
	return math.Remap(CurTime() - self.StartTime, 0, self.Lifetime, 155, 0)
end

function EFFECT:GetSize()
	return math.Remap(CurTime() - self.StartTime, 0, self.Lifetime, 2, 4)
end

function EFFECT:Render()
	local alpha = self:GetAlpha()

	if alpha < 1 then
		return
	end

	local length = (self.Start - self.End):Length()

	render.SetMaterial(self.Mat)
	render.DrawBeam(self.Start, self.End, self:GetSize(), 0, length / 128, Color(182, 182, 182, alpha))
end