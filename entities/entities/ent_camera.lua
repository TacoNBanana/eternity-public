AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 					= "ent_worldent"
ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.PrintName 				= "Camera"
ENT.Category 				= "Eternity"

ENT.Spawnable 				= true
ENT.AdminOnly 				= true

ENT.Model 					= Model("models/eternity/camera_base.mdl")

ENT.PitchRange  			= {-8, 30}
ENT.YawRange 				= {-120, 120}
ENT.ZoomRange 				= {5, 90}

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end

	if CLIENT then
		part.Add(self, "Camera", {
			Model = "models/eternity/camera_head.mdl",
			Ang = self:GetAngles(),
			Pos = self:LocalToWorld(Vector(25.65, 0, -5)),
			NoMerge = true
		})
	end

	self:SetCameraZoom(90)

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")

	self:NetworkVar("Angle", 0, "CameraAngle")
	self:NetworkVar("Float", 0, "CameraZoom")
	self:NetworkVar("String", 0, "CameraName")
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not ply:IsInEditMode() or self:IsReady() or not interact then
		return tab
	end

	table.insert(tab, {
		Name = "Set Default Angle",
		Callback = function()
			local ang = self:WorldToLocalAngles(ply:EyeAngles())

			ang.p = math.Clamp(ang.p, unpack(self.PitchRange))
			ang.y = math.Clamp(ang.y, unpack(self.YawRange))

			self:SetCameraAngle(ang)
		end
	})

	table.insert(tab, {
		Name = "Set Camera Name",
		Client = function()
			return GAMEMODE:OpenGUI("Input", "string", "Set Camera Name", {
				Default = self:GetCameraName(),
				Max = 30
			})
		end,
		Callback = function(val)
			if not GAMEMODE:CheckInput("string", {
				Max = 30
			}, val) then
				return
			end

			self:SetCameraName(val)
		end
	})

	return tab
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		if LocalPlayer():Camera() != self then
			local tab = part.Get(self, "Camera")

			if tab and IsValid(tab.Ent) then
				tab.Ent:SetAngles(self:LocalToWorldAngles(self:GetCameraAngle()))
			end
		end

		if LocalPlayer():IsInEditMode() and self:GetCameraName() != "" then
			GAMEMODE:DrawWorldText(self:LocalToWorld(Vector(25.65, 0, 10)), self:GetCameraName())
		end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:GetCustomData()
		return {
			Angle = self:GetCameraAngle(),
			Name = self:GetCameraName()
		}
	end

	function ENT:LoadCustomData(data)
		self:SetCameraAngle(data.Angle)
		self:SetCameraName(data.Name)
	end
end