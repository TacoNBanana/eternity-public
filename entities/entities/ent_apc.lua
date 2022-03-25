-- Heavily based off of Zauber's Combine APC

AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 				= "ent_base"

ENT.PrintName 			= "Combine APC"
ENT.Category 			= "Eternity"

ENT.Spawnable 			= true
ENT.AdminOnly 			= true

ENT.Model 				= Model("models/combine_apc.mdl")
ENT.FakeModel 			= Model("models/Items/combine_rifle_ammo01.mdl")

ENT.MaxHealth 			= 5000
ENT.MaxPassengers		= 6

ENT.Passengers 			= {}

ENT.PrimaryDamage 		= 40
ENT.PrimaryForce		= 2
ENT.PrimaryDelay 		= 0.1
ENT.PrimarySpread		= 0.01

ENT.SecondaryReload 	= 2

ENT.DestructDamage 		= 500
ENT.DestructRadius		= 250

if CLIENT then
	ENT.HUDHealthFlashTime 		= 0.5
	ENT.HUDCurZoom				= 75
	ENT.HUDMinZoom				= 75
	ENT.HUDMaxZoom				= 25
	ENT.HUDZoomRate				= 2.5

	ENT.HUDOKCol				= Color(8, 91, 181)
	ENT.HUDOKColBg				= Color(149, 214, 243, 80)
	ENT.HUDBadCol				= Color(227, 0, 0)
	ENT.HUDBadColBg				= Color(120, 0, 0, 120)
end

function ENT:Initialize()
	self:SetModel(self.FakeModel)
	self:SetRenderMode(RENDERMODE_NONE)
	self:SetNoDraw(true)

	self:SetPos(self:GetPos() + Vector(0, 0, 60))

	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetNotSolid(true)

	if SERVER then
		self.DriverSeat = ents.Create("prop_vehicle_jeep")
		self.DriverSeat:SetModel(self.Model)
		self.DriverSeat:SetPos(self:GetPos() - self:GetUp() * 50)
		self.DriverSeat:SetAngles(self:GetAngles())
		self.DriverSeat:SetSolid(SOLID_VPHYSICS)
		self.DriverSeat:SetKeyValue("vehiclescript", "scripts/vehicles/apc_script.txt")
		self.DriverSeat:SetKeyValue("limitview", "0")

		self.DriverSeat.CanPhys = function(_, ply)
			return self:CanPhys(ply)
		end

		self.DriverSeat.CanTool = function(_, ply, tool)
			return self:CanTool(ply, tool)
		end

		self.DriverSeat:Spawn()
		self.DriverSeat.APC = self

		self.GunnerSeat = ents.Create("prop_vehicle_prisoner_pod")
		self.GunnerSeat:SetModel(self.FakeModel)
		self.GunnerSeat:SetPos(self:GetPos() - self:GetUp() * 10 + self:GetRight() * 10)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(self:GetUp(), 180)
		self.GunnerSeat:SetAngles(ang)
		self.GunnerSeat:SetSolid(SOLID_NONE)
		self.GunnerSeat:SetNotSolid(true)
		self.GunnerSeat:SetMoveType(MOVETYPE_NONE)
		self.GunnerSeat:SetRenderMode(RENDERMODE_NONE)
		self.GunnerSeat:SetNoDraw(true)
		self.GunnerSeat:SetKeyValue("limitview", 0)

		self.GunnerSeat.CanPhys = function() return false end
		self.GunnerSeat.CanTool = function() return false end

		self.GunnerSeat:Spawn()
		self.GunnerSeat.APC = self
		self.GunnerSeat:GetPhysicsObject():EnableCollisions(false)

		self.Turret = ents.Create("base_gmodentity")
		self.Turret:SetModel(self.FakeModel)
		self.Turret:SetPos(self.DriverSeat:GetAttachment(self.DriverSeat:LookupAttachment("muzzle")).Pos)
		self.Turret:SetNotSolid(true)
		self.Turret:SetMoveType(MOVETYPE_NONE)
		self.Turret:SetRenderMode(RENDERMODE_NONE)
		self.Turret.NextShot = 0

		self.Turret.CanPhys = function() return false end
		self.Turret.CanTool = function() return false end

		self.Turret:Spawn()

		self:SetDriverSeat(self.DriverSeat)
		self:SetGunnerSeat(self.GunnerSeat)
		self:SetTurret(self.Turret)

		self:SetParent(self.DriverSeat)
		self.GunnerSeat:SetParent(self.DriverSeat)
		self.Turret:SetParent(self.DriverSeat)

		self:SetAPCHealth(self.MaxHealth)

		self:SetHatchLocked(true)

		self:SetNextPrimary(0)
		self:SetNextSecondary(0)

		self:SetNextAlarm(-1)

		self.DriverSeat:Fire("TurnOff", "")
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Driver")
	self:NetworkVar("Entity", 1, "DriverSeat")
	self:NetworkVar("Entity", 2, "Gunner")
	self:NetworkVar("Entity", 3, "GunnerSeat")
	self:NetworkVar("Entity", 4, "Turret")

	self:NetworkVar("Float", 0, "APCHealth")
	self:NetworkVar("Float", 1, "NextPrimary")
	self:NetworkVar("Float", 2, "NextSecondary")
	self:NetworkVar("Float", 3, "NextAlarm")

	self:NetworkVar("Bool", 0, "Active")
	self:NetworkVar("Bool", 1, "SlowMode")
	self:NetworkVar("Bool", 2, "HatchLocked")
	self:NetworkVar("Bool", 3, "SirenActive")
	self:NetworkVar("Bool", 4, "FirstPersonView")
	self:NetworkVar("Bool", 5, "SelfDestructing")
end

function ENT:CanPhys(ply)
	return self:CheckAccess(ply, "phys")
end

function ENT:CanTool(ply, tool)
	return ply:IsAdmin()
end

local function limitPitch(ang)
	return math.Clamp(ang, -45, 45)
end

local function processAngle(ang)
	ang.pitch = limitPitch(math.NormalizeAngle(ang.pitch))
	ang.yaw = math.NormalizeAngle(ang.yaw)
	ang.roll = math.NormalizeAngle(ang.roll)
	return ang
end

if SERVER then
	function ENT:Think()
		local nextAlarm = self:GetNextAlarm()

		if nextAlarm ~= -1 and nextAlarm <= CurTime() then
			self:GetDriverSeat():GetPhysicsObject():AddVelocity(Vector(0, 0, 150))
			self:SetNextAlarm(nextAlarm + 0.969)
		end

		local gunner = self:GetGunner()

		if IsValid(gunner) then
			local gunnerAng, apcAng = processAngle(gunner:GetAimVector():Angle()), self:GetAngles()
			local driverSeat = self:GetDriverSeat()

			driverSeat:SetPoseParameter("vehicle_weapon_yaw", math.NormalizeAngle(gunnerAng.yaw - apcAng.yaw - 90))
			driverSeat:SetPoseParameter("vehicle_weapon_pitch", limitPitch(math.NormalizeAngle(gunnerAng.pitch - apcAng.pitch)))

			if self:GetNextPrimary() < CurTime() and gunner:KeyDown(IN_ATTACK) then
				self:FireTurret()
			end

			if self:GetNextSecondary() < CurTime() and gunner:KeyDown(IN_ATTACK2) then
				self:FireRocket()
			end
		end

		self:NextThink(CurTime())

		return true
	end

	local accessToPermission = {
		["driver"] 	= PERMISSION_APC_DRIVER,
		["gunner"] 	= PERMISSION_APC_DRIVER,
		["phys"] 	= PERMISSION_MAINTENANCE
	}

	function ENT:CheckAccess(ply, access)
		if ply:IsAdmin() then
			return true
		end

		local perm = accessToPermission[access]

		if perm then
			return ply:HasPermission(accessToPermission[access], true)
		end

		return false
	end

	function ENT:OnRemove()
		if IsValid(self:GetDriver()) then
			self:Exit(self:GetDriver())
		end

		if IsValid(self:GetGunner()) then
			self:Exit(self:GetGunner())
		end

		for _, seat in pairs(self.Passengers) do
			self:Exit(seat:GetPassenger(0))
			seat:Remove()
		end

		if IsValid(self:GetDriverSeat()) then
			self:GetDriverSeat():Remove()
		end

		if IsValid(self:GetGunnerSeat()) then
			self:GetGunnerSeat():Remove()
		end

		if self.SirenSound then
			self.SirenSound:Stop()
		end

		self:StopSound("apc_engine_start")
	end

	hook.Add("CanPlayerEnterVehicle", "apc.CanPlayerEnterVehicle", function(ply, veh)
		local apc = veh.APC

		if IsValid(apc) then
			if apc:GetSelfDestructing() then
				return false
			end

			return true
		end
	end)

	hook.Add("CanExitVehicle", "apc.CanExitVehicle", function(veh, ply)
		local apc = veh.APC

		if IsValid(apc) then
			if ply.APCBlock and ply.APCBlock > CurTime() then
				return false
			end

			if apc:GetSelfDestructing() then
				return false
			end

			if apc:GetHatchLocked() and ply != apc:GetDriver() and ply != apc:GetGunner() then
				return false
			end
		end
	end)

	hook.Add("PlayerUse", "apc.PlayerUse", function(ply, ent)
		local apc = ent.APC

		if IsValid(apc) and not IsValid(ply:GetVehicle()) then
			if ply.APCBlock and ply.APCBlock > CurTime() then
				return false
			end

			if apc:GetSelfDestructing() then
				return false
			end

			local driver, gunner = apc:GetDriver(), apc:GetGunner()

			if not ply:KeyDown(IN_WALK) then
				if not IsValid(driver) and apc:CheckAccess(ply, "driver") then
					ply:EnterVehicle(apc:GetDriverSeat())

					return false
				elseif not IsValid(gunner) and apc:CheckAccess(ply, "gunner") then
					ply:EnterVehicle(apc:GetGunnerSeat())

					return false
				end
			end

			if not apc:GetHatchLocked() and #apc.Passengers < apc.MaxPassengers then
				apc:AddPassenger(ply)

				return false
			end

			ply:EmitSound("buttons/combine_button_locked.wav")
			ply.APCBlock = CurTime() + 0.5

			return false
		end
	end)

	hook.Add("PlayerEnteredVehicle", "apc.playerEnteredVehicle", function(ply, veh)
		local apc = veh.APC

		if IsValid(apc) then
			apc:NewOperator(ply, veh)

			ply.APCBlock = CurTime() + 0.5
		end
	end)

	hook.Add("PlayerLeaveVehicle", "apc.PlayerLeaveVehicle", function(ply, veh)
		local apc = veh.APC

		if IsValid(apc) then
			apc:RemovePassenger(ply, veh)

			ply.APCBlock = CurTime() + 0.5
		end
	end)

	hook.Add("PlayerDisconnected", "apc.PlayerDisconnected", function(ply)
		local veh = ply:GetVehicle()

		if IsValid(veh) and IsValid(veh.APC) then
			veh.APC:RemovePassenger(ply, veh)
		end
	end)

	function ENT:NewOperator(ply, seat)
		if seat == self:GetDriverSeat() then
			self:SetDriver(ply)
			self:Enter(ply)
		elseif seat == self:GetGunnerSeat() then
			self:SetGunner(ply)
			self:Enter(ply)
		end

		local passengers = {}

		for _, seat in pairs(self.Passengers) do
			table.insert(passengers, seat:GetPassenger(0))
		end

		netstream.Send("UpdateAPCPassengers", {
			APC = self,
			Passengers = passengers
		}, ply)
	end

	function ENT:AddPassenger(ply)
		local seat = ents.Create("prop_vehicle_prisoner_pod")
		seat:SetModel(self.FakeModel)
		seat:SetPos(self:GetPos())
		seat:SetAngles(self:GetAngles())
		seat:SetSolid(SOLID_NONE)
		seat:SetNotSolid(true)
		seat:SetMoveType(MOVETYPE_NONE)
		seat:SetRenderMode(RENDERMODE_NONE)
		seat:SetNoDraw(true)
		seat:SetKeyValue("limitview", 0)

		seat.CanPhys = function() return false end
		seat.CanTool = function() return false end

		seat:Spawn()

		seat.APC = self
		seat:GetPhysicsObject():EnableCollisions(false)
		seat:SetParent(self:GetDriverSeat())

		ply:EnterVehicle(seat)
		self:Enter(ply)

		table.insert(self.Passengers, seat)

		netstream.Send("AddAPCPassenger", {
			APC = self,
			Passenger = ply
		}, {self:GetDriver(), self:GetGunner()})
	end

	function ENT:RemovePassenger(ply, seat)
		if seat == self:GetDriverSeat() then
			if ply == self:GetDriver() then
				self:SetDriver(nil)

				ply:SetPos(self:GetPos() + self:GetForward() * 60 + self:GetUp() * 60)
				ply:SetEyeAngles((-self:GetRight()):Angle())
			end
		elseif seat == self:GetGunnerSeat() then
			if ply == self:GetGunner() then
				self:SetGunner(nil)

				ply:SetPos(self:GetPos() - self:GetForward() * 60 + self:GetUp() * 60)
				ply:SetEyeAngles((-self:GetRight()):Angle())

				self:GetDriverSeat():SetPoseParameter("vehicle_weapon_yaw", 0)
				self:GetDriverSeat():SetPoseParameter("vehicle_weapon_pitch", 0)
			end
		else
			for k, v in pairs(self.Passengers) do
				if v == seat then
					ply:SetPos(self:GetPos() + self:GetRight() * 150 + self:GetUp() * 12)
					ply:SetEyeAngles(self:GetRight():Angle())

					seat:Remove()
					table.remove(self.Passengers, k)

					netstream.Send("RemoveAPCPassenger", {
						APC = self,
						Passenger = ply
					}, {self:GetDriver(), self:GetGunner()})

					break
				end
			end
		end

		self:Exit(ply)
	end

	local nocollideList = {}

	local function handlePlayerCollisions(ply)
		if not IsValid(ply) or not ply:Alive() or IsValid(ply:GetVehicle()) then
			nocollideList[ply] = nil
			return
		end

		local tr = util.TraceEntity({
			start = ply:GetPos(),
			endpos = ply:GetPos(),
			filter = ply
		}, ply)

		if tr.Hit then
			timer.Simple(0.5, function()
				handlePlayerCollisions(ply)
			end)

			return
		end

		ply:SetCustomCollisionCheck(nocollideList[ply])

		nocollideList[ply] = nil
	end

	hook.Add("ShouldCollide", "apc.ShouldCollide", function(ent1, ent2)
		if not IsValid(ent1) or not IsValid(ent2) then
			return
		end

		if (ent2:IsPlayer() and nocollideList[ent1] ~= nil) or (ent1:IsPlayer() and nocollideList[ent2] ~= nil) then
			return false
		end
	end)

	function ENT:Enter(ply)
		ply:SetNoDraw(true)
		ply:SetAPC(self)
	end

	function ENT:Exit(ply)
		ply:SetNoDraw(false)
		ply:SetAPC(false)

		nocollideList[ply] = ply:GetCustomCollisionCheck()

		timer.Simple(0.5, function()
			handlePlayerCollisions(ply)
		end)
	end

	hook.Add("KeyPress", "apc.KeyPress", function(ply, key)
		local veh = ply:GetVehicle()
		local apc = veh.APC

		if IsValid(apc) then
			if ply == apc:GetDriver() then
				if key == IN_ATTACK then
					apc:ToggleEngine()
				elseif key == IN_ATTACK2 then
					apc:ToggleSpeed()
				elseif key == IN_SPEED then
					if not IsValid(apc:GetGunner()) and apc:CheckAccess(ply, "gunner") then
						apc:DriverToGunner(ply)
					end
				elseif key == IN_RELOAD then
					apc:ToggleSiren()
				elseif key == IN_WALK then
					apc:ToggleHatch()
				elseif key == IN_DUCK then
					apc:ToggleFirstPerson()
				elseif key == IN_ZOOM then
					apc:RemoteOpen(ply)
				end
			elseif ply == apc:GetGunner() then
				if key == IN_SPEED then
					if not IsValid(apc:GetDriver()) and apc:CheckAccess(ply, "driver") then
						apc:GunnerToDriver(ply)
					end
				end
			end
		end
	end)

	function ENT:RemoteOpen(ply)
		if self.Destructing then
			return
		end

		local attachLookup = self.DriverSeat:LookupAttachment('cannon_muzzle')
		local attach = self.DriverSeat:GetAttachment(attachLookup)

		local pos = attach.Pos + self:GetRight() * -2
		local ent = util.TraceLine{
			start = pos,
			endpos = pos + self:GetRight() * -512,
			filter = {self, self.DriverSeat}
		}.Entity

		if IsValid(ent) and ent:IsDoor() and ent:DoorType() == DOOR_COMBINE then
			ent:Fire("Open")
		end
	end

	function ENT:ToggleEngine()
		if self:GetSelfDestructing() then
			return
		end

		local active = not self:GetActive()
		self:SetActive(active)

		if active then
			self:StartEngine()
		else
			self:StopEngine()
		end
	end

	function ENT:StartEngine()
		self:EmitSound("apc_engine_start")

		timer.Simple(1, function()
			if IsValid(self) then
				local ent = self:GetDriverSeat()
				ent:Fire("TurnOn", "")
				ent:Fire("HandbrakeOff", "")
			end
		end)
	end

	function ENT:StopEngine()
		self:GetDriverSeat():Fire("TurnOff", "")
		self:StopSound("apc_engine_start")
		self:EmitSound("apc_engine_stop")
	end

	function ENT:ToggleSpeed()
		local slow = not self:GetSlowMode()
		self:SetSlowMode(slow)
		self:GetDriverSeat():SetKeyValue("vehiclescript", string.format("scripts/vehicles/apc_script%s.txt", slow and "_slow" or ""))
		RunConsoleCommand("vehicle_flushscript")
	end

	function ENT:ToggleSiren()
		if self:GetSelfDestructing() then
			return
		end

		local active = not self:GetSirenActive()
		self:SetSirenActive(active)

		if active then
			self.SirenSound = CreateSound(self:GetDriverSeat(), "d1_canals_08.siren01")
			self.SirenSound:SetSoundLevel(150)
			self.SirenSound:PlayEx(1, 100)
		elseif self.SirenSound then
			self:SetNextAlarm(-1)
			self.SirenSound:FadeOut(1.5)

			timer.Simple(1.6, function()
				if IsValid(self) and self.SirenSound then
					self.SirenSound:Stop()
					self.SirenSound = nil
				end
			end)
		end
	end

	function ENT:StartAlarm()
		if self:GetSelfDestructing() then
			return
		end

		if not self:GetSirenActive() then
			self:ToggleSiren()
		end

		self.SirenSound:ChangePitch(200, 0)
		self:SetNextAlarm(CurTime() + 0.969)
	end

	function ENT:ToggleHatch()
		if self:GetSelfDestructing() then
			return
		end

		self:SetHatchLocked(not self:GetHatchLocked())
	end

	function ENT:FireTurret()
		if self:GetSelfDestructing() then
			return
		end

		self:SetNextPrimary(CurTime() + self.PrimaryDelay)

		local turret, driverSeat = self:GetTurret(), self:GetDriverSeat()
		local index = driverSeat:LookupAttachment("muzzle")
		local att = driverSeat:GetAttachment(index)
		att.Pos = att.Pos - 5 * att.Ang:Forward() - att.Ang:Up() * 6
		turret:SetPos(att.Pos)
		turret:SetAngles(att.Ang)

		turret:EmitSound("Weapon_AR2.Single")

		local bullet = {}
			bullet.Num = 1
			bullet.Src = att.Pos
			bullet.Dir = att.Ang:Forward()
			bullet.Spread = Vector(self.PrimarySpread, self.PrimarySpread, 0)
			bullet.Tracer = 1
			bullet.TracerName = "AR2Tracer"
			bullet.Force = self.PrimaryForce
			bullet.Damage = self.PrimaryDamage
			bullet.Attacker = self:GetGunner()
		turret:FireBullets(bullet)

		local ed = EffectData()
			ed:SetEntity(driverSeat)
			ed:SetAngles(att.Ang)
			ed:SetOrigin(att.Pos)
			ed:SetScale(1.8)
			ed:SetAttachment(index)
		util.Effect('AirboatMuzzleFlash', ed)
	end

	function ENT:FireRocket()
		if self:GetSelfDestructing() then
			return
		end

		self:SetNextSecondary(CurTime() + self.SecondaryReload)

		self:EmitSound("PropAPC.FireRocket")
		local driverSeat = self:GetDriverSeat()
		local index = driverSeat:LookupAttachment("cannon_muzzle")
		local att = driverSeat:GetAttachment(index)
		local ent = ents.Create("ent_apc_rocket")
			ent:SetOwner(self:GetGunner())
			ent:SetPos(att.Pos + self:GetForward() * 2)
			ent:SetAngles(att.Ang)
			ent.APC = self
		ent:Spawn()

		local ed = EffectData()
			ed:SetEntity(driverSeat)
			ed:SetScale(2)
			ed:SetAttachment(index)
		util.Effect("AirboatMuzzleFlash", ed)

		timer.Simple(self.SecondaryReload, function()
			if IsValid(self) then
				self:EmitSound("buttons.snd6")
			end
		end)
	end

	function ENT:DriverToGunner(ply)
		if self:GetSelfDestructing() then
			return
		end

		ply:ExitVehicle()
		self:SetDriver(nil)
		ply:EnterVehicle(self:GetGunnerSeat())
	end

	function ENT:GunnerToDriver(ply)
		if self:GetSelfDestructing() then
			return
		end

		ply:ExitVehicle()
		self:SetGunner(nil)
		ply:EnterVehicle(self:GetDriverSeat())
	end

	function ENT:ToggleFirstPerson()
		self:SetFirstPersonView(not self:GetFirstPersonView())
	end

	hook.Add('SetupPlayerVisibility', 'apc.SetupPlayerVisibility', function(ply, ent)
		local apc = ply:APC()

		if IsValid(apc) then
			AddOriginToPVS(apc:GetDriverSeat():WorldSpaceCenter())
		end
	end)

	hook.Add("EntityTakeDamage", "apc.EntityTakeDamage", function(ent, dmg)
		if IsValid(ent) and ent:GetClass() == "prop_vehicle_jeep" and IsValid(ent.APC) and dmg:GetDamage() > 1 then
			ent.APC:HandleDamage(dmg)
		end
	end)

	function ENT:HandleDamage(dmg)
		self:SetAPCHealth(math.Max(self:GetAPCHealth() - dmg:GetDamage(), 0))

		if self:GetAPCHealth() <= 0 then
			timer.Simple(0, function()
				if IsValid(self) then
					self:Explode()
				end
			end)
		end
	end

	function ENT:SelfDestruct()
		if self:GetSelfDestructing() then
			return
		end

		self:SetSelfDestructing(true)

		for i = 0, 3 do
			timer.Simple(i, function() if IsValid(self) then self:EmitSound("buttons.snd16") end end)
		end

		for i = 1, 4 do
			timer.Simple(3 + i/2, function() if IsValid(self) then self:EmitSound("buttons.snd16") end end)
		end

		for i = 1, 9 do
			timer.Simple(5 + i/8, function() if IsValid(self) then self:EmitSound("buttons.snd16") end end)
		end

		timer.Simple(6.25, function()
			if IsValid(self) then
				self:Explode()
			end
		end)

		self:GetDriverSeat():Fire("TurnOff", "")
		self:GetDriverSeat():Fire("Lock", "")
	end

	function ENT:Explode()
		if self.Exploded then
			return
		end

		local apc = self:GetDriverSeat()
		local driver, gunner = self:GetDriver(), self:GetGunner()

		if IsValid(driver) then
			driver:ExitVehicle()
			self:SetDriver(nil)
			self:Exit(driver)
			driver:SetPos(apc:GetPos() + apc:GetForward() * 150 - apc:GetRight() * 50 + apc:GetUp() * 150)
			driver:SetVelocity(apc:GetForward() * 500 + apc:GetUp() * 600 - apc:GetRight() * math.random(50, 200))
			driver:Kill()
		end

		if IsValid(gunner) then
			gunner:ExitVehicle()
			self:Setgunner(nil)
			self:Exit(gunner)
			gunner:SetPos(apc:GetPos() + apc:GetForward() * 150 + apc:GetRight() * 50 + apc:GetUp() * 150)
			gunner:SetVelocity(apc:GetForward() * 500 + apc:GetUp() * 600 + apc:GetRight() * math.random(50, 200))
			gunner:Kill()
		end

		for k, seat in pairs(self.Passengers) do
			local passenger = seat:GetPassenger(0)
			passenger:ExitVehicle()
			seat:Remove()
			table.remove(self.Passengers, k)
			self:Exit(passenger)
			passenger:Kill()
		end

		local expl = ents.Create("env_explosion")
			expl:SetPos(apc:GetPos() + apc:GetForward() * 80 + apc:GetUp() * 10)
			expl:SetKeyValue("imagnitude", tostring(self.DestructDamage))
			expl:SetKeyValue("iradiusoverride", tostring(self.DestructRadius))
		expl:Spawn()
		expl:Fire("explode", "", 0)


		local gibs = {}

		for i = 1, 5 do
			local ent = ents.Create("prop_physics")
			ent:SetModel("models/combine_apc_destroyed_gib0" .. i .. ".mdl")
			ent:SetPos(apc:GetPos())
			ent:SetAngles(apc:GetAngles())
			ent:Spawn()
			table.insert(gibs, ent)
		end

		undo.ReplaceEntity(self, gibs[1])
		cleanup.ReplaceEntity(self, gibs[1])

		gibs[1]:CallOnRemove("APCCleanUp", function(_, clean)
			for _, v in pairs(clean) do
				if IsValid(v) then
					v:Remove()
				end
			end
		end, gibs)

		local ent = ents.Create("prop_physics")
			ent:SetModel("models/combine_apc_destroyed_gib06.mdl")
			ent:SetPos(self:GetPos() - self:GetRight() * 110 - self:GetUp() * 30)
			ent:SetAngles(self:GetForward():Angle())
		ent:Spawn()
		table.insert(gibs, ent)

		expl = ents.Create("env_physexplosion")
			expl:SetPos(apc:GetPos() + apc:GetForward() * 80)
			expl:SetKeyValue("magnitude", tostring(self.DestructDamage))
			expl:SetKeyValue("spawnflags", "1")
		expl:Spawn()
		expl:Fire("explode", "", 0)
		expl:Fire("kill", "", 1)

		self:Remove()
		self.Exploded = true
	end
else
	netstream.Hook("UpdateAPCPassengers", function(data)
		local apc = data.APC
		local passengers = data.Passengers

		apc.Passengers = passengers or {}
	end)

	netstream.Hook("AddAPCPassenger", function(data)
		local apc = data.APC
		local passenger = data.Passenger

		table.insert(apc.Passengers, passenger)
	end)

	netstream.Hook("RemoveAPCPassenger", function(data)
		local apc = data.APC
		local passenger = data.Passenger

		table.RemoveByValue(apc.Passengers, passenger)
	end)

	hook.Add("CalcView", "apc.CalcView", function(ply, origin, angles, fov)
		local apc = LocalPlayer():APC()

		if not IsValid(apc) then
			return
		end

		local driverSeat = apc:GetDriverSeat()

		if LocalPlayer() == apc:GetGunner() then
			local att = driverSeat:GetAttachment(driverSeat:LookupAttachment("gun_def"))

			if not att then
				return
			end

			local trace = util.TraceLine({
				start = att.Pos,
				endpos = att.Pos + att.Ang:Up() * 5,
				mask = MASK_SOLID_BRUSHONLY
			})

			local view = {}
			view.origin = trace.HitPos
			view.angles = processAngle(LocalPlayer():GetAimVector():Angle())
			view.fov = apc.HUDCurZoom

			return view
		else
			if apc:GetFirstPersonView() and LocalPlayer() == apc:GetDriver() then
				view = {
					origin = driverSeat:GetPos() + driverSeat:GetUp() * 50 - driverSeat:GetRight() * 100,
					angles = (-driverSeat:GetRight()):Angle(),
					fov = 90
				}
			else
				angles = driverSeat:LocalToWorldAngles(Angle(0, angles.y - driverSeat:GetAngles().y, 0))

				angles.p = 15
				angles.r = 0

				local trace = util.TraceLine({
					start = driverSeat:WorldSpaceCenter(),
					endpos = driverSeat:WorldSpaceCenter() - angles:Forward() * 250,
					mask = MASK_SOLID_BRUSHONLY
				})

				view = {}
				view.origin = trace.HitPos + trace.HitNormal * 5
				view.angles = angles
				view.fov = fov
			end

			return view
		end
	end)

	hook.Add("Tick", "apc.Tick", function()
		local apc = LocalPlayer().APC and LocalPlayer():APC()

		if not IsValid(apc) then
			return
		end

		if LocalPlayer() == apc:GetGunner() then
			apc.HUDCurZoom = math.Clamp(apc.HUDCurZoom + (LocalPlayer():KeyDown(IN_ZOOM) and -apc.HUDZoomRate or apc.HUDZoomRate), apc.HUDMaxZoom, apc.HUDMinZoom)
		end
	end)
end