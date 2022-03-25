AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 				= "ent_worldent"
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.PrintName 			= "Spawnpoint Group"
ENT.Category 			= "Eternity"

ENT.Spawnable 			= true
ENT.AdminOnly 			= true

ENT.SpawnAngleOffset 	= Angle(0, 90, 0)

ENT.Model 				= Model("models/props_combine/breenconsole.mdl")
ENT.LightMat 			= Material("particle/particle_glow_05_addnofog")

ENT.Sounds = {
	Use = Sound("buttons/lightswitch2.wav")
}

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

		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")

	self:NetworkVar("String", 0, "Spawngroup")
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not ply:IsInEditMode() or self:IsReady() or not interact then
		return tab
	end

	table.insert(tab, {
		Name = "Set Spawngroup",
		Client = function()
			return GAMEMODE:OpenGUI("Input", "string", "Set Spawngroup", {
				Default = self:GetSpawngroup(),
				Max = 30
			})
		end,
		Callback = function(val)
			if not GAMEMODE:CheckInput("string", {
				Max = 30
			}, val) then
				return
			end

			self:SetSpawngroup(val)
		end
	})

	return tab
end

function ENT:CanSave()
	return self:GetSpawngroup() != ""
end

if CLIENT then
	function ENT:GetSpriteColor()
		if not self:IsReady() or LocalPlayer():GetActiveSpecies().ForceTeamSpawn then
			return Color(255, 0, 0)
		end

		if LocalPlayer():Spawngroup() == self:GetSpawngroup() then
			return Color(33, 255, 0)
		end

		return Color(255, 223, 127)
	end

	function ENT:Draw()
		self:DrawModel()

		render.SetMaterial(self.LightMat)
		render.DrawSprite(self:LocalToWorld(Vector(13.9, -5, 48)), 8, 8, self:GetSpriteColor())

		if LocalPlayer():IsInEditMode() and self:GetSpawngroup() != "" then
			GAMEMODE:DrawWorldText(self:GetPos() + Vector(0, 0, 60), self:GetSpawngroup())
		end
	end
end

if SERVER then
	function ENT:Use(ply)
		if not self:IsReady() then
			return
		end

		if ply:GetActiveSpecies().ForceTeamSpawn then
			return
		end

		local group = self:GetSpawngroup()

		self:EmitSound(self.Sounds.Use)

		if ply:Spawngroup() == group then
			ply:SetSpawngroup("")
			ply:SendChat("NOTICE", "Your spawnpoint has been reset.")
		else
			ply:SetSpawngroup(group)
			ply:SendChat("NOTICE", "Your spawnpoint has been set to this area.")
		end
	end

	function ENT:GetCustomData()
		return {
			Spawngroup = self:GetSpawngroup()
		}
	end

	function ENT:LoadCustomData(data)
		self:SetSpawngroup(data.Spawngroup)
	end
end