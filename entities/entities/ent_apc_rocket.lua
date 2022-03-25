-- Heavily based off of Zauber's Combine APC

AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 	= "ent_base"

ENT.Model 	= Model("models/weapons/W_missile_closed.mdl")

ENT.Damage 	= 128
ENT.Fuse 	= 0.1

for i = 4, 9 do
	util.PrecacheSound("ambient/explosions/explode_" .. math.random(4, 9) .. ".wav")
end

function ENT:Initialize()
	if SERVER then
		self.SpawnTime = CurTime()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		local phys = self:GetPhysicsObject()
		phys:Wake()
		phys:EnableGravity(false)

		self:StartMotionController()
		self.Destination = Vector(0, 0, 0)

		self.ShadowParams = {
			secondstoarrive = 0.5,
			maxangular = 0.000001,
			maxangulardamp = 1,
			maxspeed = 500000,
			maxspeeddamp = 500,
			dampfactor = 0.7,
			teleportdistance = 0
		}

		self:SetCustomCollisionCheck(true)
		self:EmitSound("Missile.Ignite")
	else
		self.Emitter = ParticleEmitter(Vector(0, 0, 0))
		self.NextSmoke = CurTime()
	end
end

function ENT:Think()
	if SERVER then
		local owner = self:GetOwner()
		if not IsValid(owner) or not IsValid(self.APC) then
			self:Remove()
			return
		end

		-- Not a gunner anymore?
		local vehicle = owner:GetVehicle()
		if vehicle ~= self.APC:GetGunnerSeat() then
			self:Remove()
			return
		end

		local driverSeat = self.APC:GetDriverSeat()
		local attach = driverSeat:GetAttachment(driverSeat:LookupAttachment('muzzle'))
		self.Destination = util.TraceLine({
			start = attach.Pos - 15 * attach.Ang:Forward() + attach.Ang:Right(),
			endpos = attach.Pos - 15 * attach.Ang:Forward() + attach.Ang:Right() + attach.Ang:Forward() * 16384,
			filter = {self.APC, driverSeat, self.APC:GetGunnerSeat(), self.APC:GetTurret()},
			mask = MASK_SHOT
		}).HitPos
	else
		if not self.Emitter then
			self.Emitter = ParticleEmitter(Vector(0, 0, 0))
		end

		if CurTime() >= self.NextSmoke then
			local vec = -self:GetForward()

			local smoke = self.Emitter:Add("particles/smokey", self:GetPos() + vec * 45)
				smoke:SetVelocity(vec)
				smoke:SetDieTime(0.8)
				smoke:SetStartAlpha(math.Rand(50, 150))
				smoke:SetStartSize(math.Rand(8, 16))
				smoke:SetEndSize(math.Rand(16, 32))
				smoke:SetRoll(math.Rand(-0.3, 0.3))
				smoke:SetColor(190, 190, 190, 180, 128)

			local flame = self.Emitter:Add("particles/flamelet5", self:GetPos() + vec * 15)
				flame:SetVelocity(vec)
				flame:SetDieTime(0.1)
				flame:SetStartAlpha(math.Rand(150, 255))
				flame:SetStartSize(math.Rand(2, 4))
				flame:SetEndSize(math.Rand(8, 16))
				flame:SetRoll(math.Rand(-0.3, 0.3))
				flame:SetColor(190, 190, 190, 180, 128)

			self.NextSmoke = CurTime() + 0.015
		end
	end
end

if SERVER then
	function ENT:OnRemove()
		self:StopSound("Missile.Ignite")

		local expl = ents.Create("env_explosion")
			expl:SetPos(self:GetPos())
			expl:SetOwner(self:GetOwner())
			expl:SetKeyValue("imagnitude", tostring(self.Damage))
			expl.APC = self.APC
		expl:Spawn()
		expl:Fire("explode")

		local physexpl = ents.Create("env_physexplosion")
			physexpl:SetPos(self:GetPos())
			physexpl:SetKeyValue("magnitude", tostring(self.Damage))
			physexpl:SetKeyValue("spawnflags", "1")
		physexpl:Spawn()
		physexpl:Fire("explode", "", 0)
		physexpl:Fire("kill", "", 1)
	end

	function ENT:OnTakeDamage()
		self:Remove()
	end

	function ENT:PhysicsSimulate(phys, dt)
		if not IsValid(self.APC) then
			return
		end

		phys:Wake()

		local spos = self:GetPos()
		local dir = ((self.Destination - spos):GetNormalized() + self:GetAngles():Forward() * 10) / 11
		local ang = dir:Angle()
		local vec = spos + dir * 512 + self:GetAngles():Forward() * 100

		if CurTime() < self.SpawnTime + self.Fuse then
			vec = spos + self:GetForward() * 1024 + dir * 64
			ang = self.APC:GetForward():Angle()
		else
			phys:SetAngles(ang)
		end

		self.ShadowParams.pos = vec
		self.ShadowParams.deltatime = dt
		self.ShadowParams.ang = ang
		phys:ComputeShadowControl(self.ShadowParams)
	end

	function ENT:PhysicsCollide(data, physobj)
		if IsValid(self.APC) and data.HitEntity == self.APC:GetDriverSeat() and CurTime() - self.SpawnTime <= self.Fuse then
			return
		end

		timer.Simple(0, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end

	local function shouldCollide(ent1, ent2)
		if
			(ent1:GetClass() == 'ent_apc_rocket' and ent2 == ent1.APC:GetDriverSeat() and CurTime() - ent1.SpawnTime <= ent1.Fuse)
			or
			(ent2:GetClass() == 'ent_apc_rocket' and ent1 == ent2.APC:GetDriverSeat() and CurTime() - ent2.SpawnTime <= ent2.Fuse)
		then
			return true
		end
	end
	hook.Add('ShouldCollide', 'apc_rocket.ShouldCollide', shouldCollide)
end