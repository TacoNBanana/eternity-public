AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Spawnpoint"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/editor/playerstart.mdl")

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
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")
	self:NetworkVar("Int", 1, "Team")

	self:NetworkVar("String", 0, "Spawngroup")
end

function ENT:Think()
	if self:GetTeam() > 0 then
		self:SetColor(team.GetColor(self:GetTeam()))
	else
		self:SetColor(Color(0, 255, 63))
	end

	self:RemoveAllDecals()
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

			self:SetTeam(0)
			self:SetSpawngroup(val)
		end
	})

	table.insert(tab, {
		Name = "Set as Generic spawn",
		Callback = function(val)
			self:SetTeam(0)
			self:SetSpawngroup("")
		end
	})

	table.insert(tab, {
		Name = "Set as Bird spawn",
		Callback = function(val)
			self:SetTeam(TEAM_UNASSIGNED)
			self:SetSpawngroup("")
		end
	})

	for k, v in pairs(TEAMS) do
		table.insert(tab, {
			Name = string.format("Set as %s spawn", v.Name),
			Callback = function()
				self:SetTeam(k)
				self:SetSpawngroup("")
			end
		})
	end

	return tab
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsInEditMode() then
			self:DrawModel()

			if self:GetSpawngroup() != "" then
				GAMEMODE:DrawWorldText(self:GetPos() + Vector(0, 0, 80), self:GetSpawngroup())
			end

			return
		end

		if not self:IsReady() then
			self:DrawModel()

			return
		end

		if GAMEMODE:GetSetting("ui_showspawns") then
			local alpha = math.ClampedRemap(self:GetPos():Distance(LocalPlayer():GetPos()), 500, 100, 0, 0.2)

			if alpha > 0 then
				render.SetBlend(alpha)
				self:DrawModel()
				render.SetBlend(1)
			end
		end
	end
end

if SERVER then
	function ENT:OnInitialLoad()
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end

	function ENT:IsSuitable(force, ply)
		if not self:IsReady() then
			return false
		end

		if force and self:GetTeam() == TEAM_UNASSIGNED then
			return true
		end

		local pos = self:GetPos()
		local tab = ents.FindInBox(pos + Vector(-16, -16, 0), pos + Vector(16, 16, 72))

		for _, v in pairs(tab) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v != ply then
				if force then
					v:Kill()
				else
					return false
				end
			end
		end

		return true
	end

	function ENT:GetCustomData()
		return {
			Spawngroup = self:GetSpawngroup(),
			Team = self:GetTeam()
		}
	end

	function ENT:LoadCustomData(data)
		self:SetSpawngroup(data.Spawngroup or "")
		self:SetTeam(data.Team or 0)
	end
end