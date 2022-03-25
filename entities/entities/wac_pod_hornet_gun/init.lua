include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.Sounds = {
	shoot = "Warkanum/minigun_shoot.wav",
	stop = "Warkanum/minigun_wind_stop.wav",
}

function ENT:fireBullet(pos)
	if not self:takeAmmo(1) then
		return
	end

	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.aircraft:LocalToWorld(pos)
	bullet.Dir = self:GetForward()
	bullet.Spread = Vector(0.015, 0.015, 0)
	bullet.Tracer = self.Tracer
	bullet.Force = self.Force
	bullet.Damage = self.Damage
	bullet.Attacker = self:getAttacker()
	bullet.Callback = function(ply, tr, dmg)
		if not SERVER then
			return
		end

		local ed = EffectData()
		ed:SetEntity(self)
		ed:SetAngles(tr.HitNormal:Angle())
		ed:SetOrigin(tr.HitPos)
		ed:SetScale(30)
		util.Effect("wac_impact_m197", ed)

		local tracer = EffectData()
		tracer:SetEntity(self)
		tracer:SetStart(bullet.Src)
		tracer:SetOrigin(tr.HitPos)
		tracer:SetScale(7500)
		util.Effect("Tracer", tracer)

		util.BlastDamage(self, ply, tr.HitPos, 64, 40)
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(bullet.Src)
	effectdata:SetAngles(self:GetAngles())
	effectdata:SetScale(0.8)
	util.Effect("MuzzleEffect", effectdata)

	self.aircraft:FireBullets(bullet)
end


function ENT:fire()
	if not self.shooting then
		self.shooting = true
		self.sounds.stop:Stop()
		self.sounds.shoot:Play()
	end

	if self.Sequential then
		self.currentPod = self.currentPod or 1
		self:fireBullet(self.Pods[self.currentPod], self:GetAngles())
		self.currentPod = (self.currentPod == #self.Pods and 1 or self.currentPod + 1)
	else
		for _, pos in pairs(self.Pods) do
			self:fireBullet(pos, self:GetAngles())
		end
	end

	self:SetNextShot(self:GetLastShot() + 60 / self.FireRate)
end


function ENT:stop()
	if self.shooting then
		self.sounds.shoot:Stop()
		self.sounds.stop:Play()
		self.shooting = false
	end
end