ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "UH-144 Falcon"
ENT.Category			= "hop's halo gubbins"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model				= "models/valk/haloreach/unsc/falcon/falcon.mdl"
ENT.EngineForce			= 40
ENT.Weight				= 8000

ENT.SmokePos			= Vector(-90, 0, 120)
ENT.FirePos				= Vector(-75, 0, 100)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(15, 0, 120),
	model = false
}

ENT.BackRotor = {
	dir = 1,
	pos = Vector(0, 0, 90),
	model = "models/props_junk/PopCan01a.mdl"
}

ENT.Seats = {
	{
		pos = Vector(90, 0, 30),
		exit = Vector(115.55, 80, 10)
	},
	{
		pos = Vector(28, 20, 30),
		exit = Vector(50, 100, 10),
		ang = Angle(0, 180, 0)
	},
	{
		pos = Vector(28, -17, 30),
		exit = Vector(50, -100, 10),
		ang = Angle(0, 180, 0)
	},
	{
		pos = Vector(-32, 10, 25),
		exit = Vector(-15, 100, 10),
	},
	{
		pos = Vector(-32, -10, 25),
		exit = Vector(-15, -100, 10),
	},
	{
		pos = Vector(-34, -30, 25),
		exit = Vector(-50, -100, 10),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(-34, 30, 25),
		exit = Vector(-50, 100, 10),
		ang = Angle(0, 90, 0)
	}
}

ENT.Sounds = {
	Start 			= "WAC/falcon/start.wav",
	Blades 			= "WAC/falcon/external.wav",
	Engine 			= "WAC/falcon/internal.wav",
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