AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Admin Teleport"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/editor/playerstart.mdl")

function ENT:SpawnFunction(ply, tr, class)
	local ent = BaseClass.SpawnFunction(self, ply, tr, class)

	if not IsValid(ent) then
		return
	end

	ent:SetPos(ply:GetPos())
	ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_BBOX)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end

	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetSubMaterial(0, "models/shiny")
	self:SetColor(Color(0, 255, 255))

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")
	self:NetworkVar("Int", 1, "Team")

	self:NetworkVar("String", 0, "TeleportID")
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not ply:IsInEditMode() or self:IsReady() or not interact then
		return tab
	end

	table.insert(tab, {
		Name = "Set Teleport ID",
		Client = function()
			return GAMEMODE:OpenGUI("Input", "string", "Set Teleport ID", {
				Default = self:GetTeleportID(),
				Max = 30
			})
		end,
		Callback = function(val)
			if not GAMEMODE:CheckInput("string", {
				Max = 30
			}, val) then
				return
			end

			for _, v in pairs(ents.FindByClass("ent_adminteleport")) do
				if v != self and v:GetTeleportID() == val then
					ply:SendChat("ERROR", "There already exists a teleport with this ID!")

					return
				end
			end

			self:SetTeleportID(val)
		end
	})

	return tab
end

function ENT:CanSave()
	return self:GetTeleportID() != ""
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsInEditMode() then
			self:DrawModel()

			GAMEMODE:DrawWorldText(self:GetPos() + Vector(0, 0, 80), self:GetTeleportID())

			return
		end

		if not self:IsReady() then
			self:DrawModel()

			return
		end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:OnInitialLoad()
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end

	function ENT:GetCustomData()
		return {
			TeleportID = self:GetTeleportID(),
		}
	end

	function ENT:LoadCustomData(data)
		self:SetTeleportID(data.TeleportID)
	end
end