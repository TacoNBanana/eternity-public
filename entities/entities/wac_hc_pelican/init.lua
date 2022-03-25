include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.EngineHealth = 3500

ENT.Wheels = {
	{
		mdl = "models/cessna/cessna172_nwheel.mdl",
		pos = Vector(-330, 138, -78),
		friction = 100,
		mass = 500
	},
	{
		mdl = "models/cessna/cessna172_nwheel.mdl",
		pos = Vector(-330, -138, -78),
		friction = 100,
		mass = 500
	},
	{
		mdl = "models/cessna/cessna172_nwheel.mdl",
		pos = Vector(185, 0, -142),
		friction = 100,
		mass = 500
	},
}

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then
		return
	end

	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal * 160)
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply

	ent:SetBodygroup(2, 2) -- interior doorway
	ent:SetBodygroup(4, 1) -- nose cap
	ent:SetBodygroup(5, 1) -- extra seats

	ent:SetSkin(1)

	return ent
end

function ENT:Initialize()
	self:base("wac_hc_base").Initialize(self)

	for _, v in pairs(self.wheels) do
		v:SetNoDraw(true)
	end
end

function ENT:addRotors()
	self:base("wac_hc_base").addRotors(self)

	self.topRotor:SetNotSolid(true)
	self.backRotor:SetNotSolid(true)
	self.backRotor:SetNoDraw(true)
end

function ENT:KillTopRotor()
	self:setEngine(false)
	self:SetNWFloat("up", 0)
	self:SetNWFloat("uptime", 0)
	self.rotorRpm = 0
	self:setVar("rotorRpm", 0)

	self.topRotor:Remove()
	self.topRotor = nil
end

function ENT:CustomThink()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self:SetAngularVelocity(phys:GetAngleVelocity())
	end
end

function ENT:receiveInput(name, value, seat)
	self:base("wac_hc_base").receiveInput(self, name, value, seat)

	if seat == 1 then
		if name == "Fire" and value > 0.5 then
			self:SetVTOLMode(not self:GetVTOLMode())
			self:SetVTOLTimer(CurTime())
		elseif name == "NextWeapon" and value > 0.5 then
			self:SetLandingGearDown(not self:GetLandingGearDown())
			self:SetHatchOpen(not self:GetHatchOpen())

			for _, wheel in pairs(self.wheels) do
				local phys = wheel:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetMass(self:GetLandingGearDown() and 500 or 10)
				end
			end
		end
	end
end

-- Madness lies below

function ENT:PhysicsUpdate(ph)
	if self.LastPhys == CurTime() then return end

	local dir = self:GetAngles() + Angle(self:GetVTOLFraction() * 20, 0, 0)

	local vel = ph:GetVelocity()
	local pos = self:GetPos()
	local ri = dir:Right()
	local up = dir:Up()
	local fwd = dir:Forward()
	local ang = self:GetAngles()
	local dvel = vel:Length()
	local lvel = self:WorldToLocal(pos + vel)
	local hover = self:calcHover(ph, pos, vel, ang)
	local rotateX = (self.controls.roll * 1.5 + hover.r) * self.rotorRpm
	local rotateY = (self.controls.pitch + hover.p) * self.rotorRpm
	local rotateZ = self.controls.yaw * 1.5 * self.rotorRpm

	self.arcade = IsValid(self.passengers[1]) and self.passengers[1]:GetInfo("wac_cl_air_arcade") or 0

	--local phm = (wac.aircraft.cvars.doubleTick:GetBool() and 2 or 1)
	local phm = FrameTime() * 66

	if self.UsePhysRotor then
		if self.active and not self.engineDead then
			self.engineRpm = math.Clamp(self.engineRpm + FrameTime() * 0.1 * wac.aircraft.cvars.startSpeed:GetFloat(), 0, 1)
		else
			self.engineRpm = math.Clamp(self.engineRpm - FrameTime() * 0.16 * wac.aircraft.cvars.startSpeed:GetFloat(), 0, 1)
		end

		if self.topRotor and self.topRotor.Phys and self.topRotor.Phys:IsValid() then
			if self.RotorBlurModel then
				self.topRotor.vis:SetColor(Color(255, 255, 255, math.Clamp(1.3 - self.rotorRpm, 0.1, 1) * 255))
			end

			-- top rotor physics
			local rotor = {}
			rotor.phys = self.topRotor.Phys
			rotor.angVel = rotor.phys:GetAngleVelocity()
			rotor.upvel = self.topRotor:WorldToLocal(self.topRotor:GetVelocity() + self.topRotor:GetPos()).z
			rotor.brake = math.Clamp(math.abs(rotor.angVel.z) - 2950, 0, 100) / 10 + math.pow(math.Clamp(1500 - math.abs(rotor.angVel.z), 0, 1500) / 900, 3) + math.abs(rotor.angVel.z / 10000) - (rotor.upvel - self.rotorRpm) * (self.controls.throttle - 0.5) / 1000
			-- RPM cap
			rotor.targetAngVel = Vector(0, 0, math.pow(self.engineRpm, 2) * self.TopRotor.dir * 10) - rotor.angVel * rotor.brake / 200
			rotor.phys:AddAngleVelocity(rotor.targetAngVel)
			self.rotorRpm = math.Clamp(rotor.angVel.z / 3000 * self.TopRotor.dir, -1, 1)
			-- body physics
			local mind = (100 - self.topRotor.fHealth) / 100
			ph:AddAngleVelocity(VectorRand() * self.rotorRpm * mind * phm)

			if IsValid(self.backRotor) and self.backRotor.Phys:IsValid() then
				--self.backRotor.Phys:AddAngleVelocity(Vector(0,self.rotorRpm*300*self.BackRotor.dir-self.backRotor.Phys:GetAngleVelocity().y/10,0)*phm)
				if self.TwinBladed then
					self.backRotor.Phys:AddAngleVelocity(rotor.targetAngVel * phm)
				else
					self.backRotor.Phys:AddAngleVelocity(Vector(0, self.rotorRpm * 300 * self.BackRotor.dir - self.backRotor.Phys:GetAngleVelocity().y / 10, 0) * phm)
				end
			else
				ph:AddAngleVelocity(Vector(0, 0, 0 - self.rotorRpm * self.TopRotor.dir / 2) * phm)
				ph:AddAngleVelocity(VectorRand() * self.rotorRpm * mind * phm)

				if not self.sounds.CrashAlarm:IsPlaying() and not self.disabled then
					self.sounds.CrashAlarm:Play()
				end
			end

			local throttle = self.Agility.Thrust * up * ((self.controls.throttle + hover.t) * self.rotorRpm * 1.7 * self.EngineForce / 15 + self.rotorRpm * 9.15)
			local brakez = self:LocalToWorld(Vector(0, 0, lvel.z * dvel * self.rotorRpm / 100000 * self.Aerodynamics.RailRotor)) - pos
			ph:AddVelocity((throttle - brakez) * phm)
		elseif IsValid(self.backRotor) and self.backRotor.Phys:IsValid() then
			local backSpeed = (self.backRotor.Phys:GetAngleVelocity() - ph:GetAngleVelocity()).y
			ph:AddAngleVelocity(Vector(0, 0, backSpeed / 300))
			self.backRotor.Phys:AddAngleVelocity(self.backRotor.Phys:GetAngleVelocity() * -0.01)
		end
	else
		self.rotorRpm = math.Approach(self.rotorRpm, self.active and 1 or 0, self.EngineForce / 1000)
		ph:SetVelocity(vel * 0.999 + (up * self.rotorRpm * (self.controls.throttle + 1) * 7 + (fwd * math.Clamp(ang.p * 0.1, -2, 2) + ri * math.Clamp(ang.r * 0.1, -2, 2)) * self.rotorRpm) * phm)
	end

	local controlAng = Vector(rotateX, rotateY, IsValid(self.backRotor) and rotateZ or 0) * self.Agility.Rotate * (1 + self.arcade)
	local aeroVelocity, aeroAng = self:calcAerodynamics(ph)
	ph:AddAngleVelocity((aeroAng + controlAng) * phm)
	ph:AddVelocity(aeroVelocity * phm)

	for _, e in pairs(self.wheels) do
		if IsValid(e) then
			local phw = e:GetPhysicsObject()

			if phw:IsValid() then
				local lpos = self:WorldToLocal(e:GetPos())
				e:GetPhysicsObject():AddVelocity((Vector(0, 0, 6) + self:LocalToWorld(Vector(0, 0, lpos.y * rotateX - lpos.x * rotateY) / 4) - pos) * phm)
				e:GetPhysicsObject():AddVelocity(up * ang.r * lpos.y / self.WheelStabilize * phm)

				if self.controls.throttle < -0.8 then
					phw:AddAngleVelocity(phw:GetAngleVelocity() * -0.5 * phm)
				end -- apply wheel brake
			end
		end
	end

	self.LastPhys = CurTime()
end