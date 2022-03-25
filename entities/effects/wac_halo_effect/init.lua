function EFFECT:Init(data)
	self.die = 0.2
	self.dietime = CurTime()+self.die
	self.ent = data:GetEntity()
	self.offset = data:GetOrigin()
	self.emitter = ParticleEmitter(self.ent:GetPos())
	self.power = data:GetMagnitude()
	self.radius = data:GetRadius() or 20
end

function EFFECT:Think()
	if CurTime() > self.dietime then
		return false
	end

	if not IsValid(self.ent) then
		return false
	end

	local emitter = self.emitter
	local spawnpos = self.ent:LocalToWorld(self.offset + Vector(math.random(-self.radius, self.radius), math.random(-self.radius, self.radius), 0))
	local velocity = self.ent:GetUp() * self.power * -math.random(500, 1000)
	local particle = emitter:Add("sprites/heatwave", spawnpos)

	if (particle) then
		particle:SetVelocity(velocity)
		particle:SetLifeTime(0)
		particle:SetDieTime(self.die)
		particle:SetStartSize(20)
		particle:SetEndSize(10)
		particle:SetAirResistance(0)
		particle:SetCollide(true)
		particle:SetBounce(0)
	end

	return true
end

function EFFECT:Render()
end