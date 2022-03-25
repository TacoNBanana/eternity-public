ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName 			= "AV-14 Attack VTOL"
ENT.Category 			= "hop's halo gubbins"
ENT.Spawnable 			= true
ENT.AdminSpawnable 		= true

ENT.Model 				= "models/valk/h3/unsc/hornet/hornet.mdl"
ENT.EngineForce 		= 40
ENT.Weight 				= 1800

ENT.SmokePos 			= Vector(-30, 0, 75)
ENT.FirePos 			= Vector(-10, 0, 100)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(0, 0, 120),
	model = false
}

ENT.BackRotor = {
	dir = 1,
	pos = Vector(0, 0, 100),
	model = "models/props_junk/PopCan01a.mdl"
}

ENT.Seats = {
	{
		pos = Vector(90, 0, 37),
		exit = Vector(115, 90, 25),
		weapons = {"M134", "Hydra 70"}
	},
	{
		pos = Vector(55, 35, 15),
		exit = Vector(115, 90, 5),
		ang = Angle(0, 70, 0)
	},
	{
		pos = Vector(55, -35, 15),
		exit = Vector(115, -90, 5),
		ang = Angle(0, -70, 0)
	}
}

ENT.Weapons = {
	["M134"] = {
		class = "wac_pod_hornet_gun",
		info = {
			Pods = {
				Vector(43, 25, 101),
				Vector(43, -25, 101)
			}
		}
	},
	["Hydra 70"] = {
		class = "wac_pod_hornet_rocket",
		info = {
			Pods = {
				Vector(45, 30, 8),
				Vector(45, -30, 8)
			}
		}
	}
}

ENT.Sounds = {
	Start 			= "WAC/hornet/start.wav",
	Blades 			= "WAC/hornet/external.wav",
	Engine 			= "WAC/hornet/internal.wav",
	MissileAlert 	= "HelicopterVehicle/MissileNearby.mp3",
	MissileShoot 	= "HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm 		= "WAC/Heli/fire_alarm_tank.wav",
	LowHealth 		= "WAC/Heli/fire_alarm.wav",
	CrashAlarm 		= "WAC/Heli/FireSmoke.wav"
}

function ENT:SetupDataTables()
	self:base("wac_hc_base").SetupDataTables(self)

	self:NetworkVar("Vector", 0, "AngularVelocity")

	if SERVER then
		self:SetAngularVelocity(Vector())
	end
end