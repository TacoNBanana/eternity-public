ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "Dropship 77-Pelican"
ENT.Category			= "hop's halo gubbins"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model				= "models/valk/haloreach/unsc/pelican/pelican.mdl"
ENT.EngineForce			= 40
ENT.Weight				= 8000

ENT.SmokePos			= Vector(-265, 0, 185)
ENT.FirePos				= Vector(-100, 0, 160)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(20, 0, 50),
	model = "models/props_junk/PopCan01a.mdl"
}

ENT.BackRotor = {
	dir = -1,
	pos = Vector(-500, 0, 180),
	model =  "models/props_junk/PopCan01a.mdl"
}

ENT.Seats = {
	-- pilot
	{
		pos = Vector(266, 0, -45),
		exit = Vector(230, -15, -50)
	},
	-- co-pilot
	{
		pos = Vector(222, 22, -15),
		exit = Vector(222, 0, -50)
	},

	-- left row pax
	{
		pos = Vector(61, 60, -58),
		exit = Vector(61, 30, -50),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(30.5, 60, -58),
		exit = Vector(30.5, 30, -50),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(-0.5, 60, -58),
		exit = Vector(-0.5, 30, -50),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(-31.5, 60, -58),
		exit = Vector(-31.5, 30, -50),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(-62, 60, -58),
		exit = Vector(-62, 30, -50),
		ang = Angle(0, -90, 0)
	},
	{
		pos = Vector(-93, 60, -58),
		exit = Vector(-93, 30, -50),
		ang = Angle(0, -90, 0)
	},

	-- right row pax
	{
		pos = Vector(61, -60, -58),
		exit = Vector(61, -20, -50),
		ang = Angle(0, 90, 0)
	},
	{
		pos = Vector(30.5, -60, -58),
		exit = Vector(30.5, -20, -50),
		ang = Angle(0, 90, 0)
	},
	{
		pos = Vector(-0.5, -60, -58),
		exit = Vector(-0.5, -20, -50),
		ang = Angle(0, 90, 0)
	},
	{
		pos = Vector(-31.5, -60, -58),
		exit = Vector(-31.5, -20, -50),
		ang = Angle(0, 90, 0)
	},
	{
		pos = Vector(-62, -60, -58),
		exit = Vector(-62, -20, -50),
		ang = Angle(0, 90, 0)
	},
	{
		pos = Vector(-93, -60, -58),
		exit = Vector(-93, -20, -50),
		ang = Angle(0, 90, 0)
	},
}

ENT.TransitionTimer 	= 1

function ENT:GetVTOLFraction()
	local val = math.ClampedRemap(CurTime() - self:GetVTOLTimer(), 0, self.TransitionTimer, 0, 1)

	if self:GetVTOLMode() == true then
		return val
	else
		return 1 - val
	end
end

ENT.Sounds = {
	Start 			= "WAC/pelican/startup.wav",
	Blades 			= "WAC/pelican/internal.wav",
	Engine 			= "WAC/pelican/external.wav",
	MissileAlert 	= "HelicopterVehicle/MissileNearby.mp3",
	MissileShoot 	= "HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm 		= "WAC/Heli/fire_alarm_tank.wav",
	LowHealth 		= "WAC/Heli/fire_alarm.wav",
	CrashAlarm 		= "WAC/Heli/FireSmoke.wav",
}

function ENT:SetupDataTables()
	self:base("wac_hc_base").SetupDataTables(self)

	self:NetworkVar("Vector", 0, "AngularVelocity")
	self:NetworkVar("Bool", 1, "HatchOpen")
	self:NetworkVar("Bool", 2, "LandingGearDown")

	self:NetworkVar("Bool", 3, "VTOLMode")
	self:NetworkVar("Float", 1, "VTOLTimer")

	if SERVER then
		self:SetAngularVelocity(Vector())
		self:SetHatchOpen(true)
		self:SetLandingGearDown(true)

		self:SetVTOLMode(false)
		self:SetVTOLTimer(CurTime() - self.TransitionTimer)
	end
end