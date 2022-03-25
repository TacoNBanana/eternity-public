AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

ENT.Model 			= Model("models/hunter/blocks/cube05x05x05.mdl")
ENT.Color 			= Color(255, 255, 255)

ENT.Players 		= {}
ENT.Active 			= {}

function ENT:SpawnFunction(ply, tr, class)
	local mins = ply:ZoneMins()
	local maxs = ply:ZoneMaxs()

	if not mins or not maxs then
		ply:SendChat("ERROR", "You don't have a zone configured!")

		return
	end

	local weapon = ply:GetActiveWeapon()

	if not IsValid(weapon) or weapon:GetClass() != "eternity_zonemarker" then
		ply:SendChat("ERROR", "You have to have your zone marker out to create a zone!")

		return
	end

	local ent = BaseClass.SpawnFunction(self, ply, tr, class)

	if not IsValid(ent) then
		return
	end

	ent:SetPos(ply:EyePos())
	ent:SetAngles(Angle())

	ent:SetZoneMins(mins)
	ent:SetZoneMaxs(maxs)

	ply:SetZoneMins(false)
	ply:SetZoneMaxs(false)
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_BBOX)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetMaterial("models/shiny")

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")

	self:NetworkVar("Vector", 0, "ZoneMins")
	self:NetworkVar("Vector", 1, "ZoneMaxs")
end

function ENT:OnRemove()
	for k in pairs(self.Active) do
		if IsValid(k) then
			k.ForceZoneUpdate = true
		end
	end
end

if CLIENT then
	function ENT:Draw()
		local edit = LocalPlayer():IsInEditMode()
		local ready = self:IsReady()

		if edit or not ready then
			self:DrawModel()

			local mins = self:OBBMins() - Vector(0.1, 0.1, 0.1)
			local maxs = self:OBBMaxs() + Vector(0.1, 0.1, 0.1)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, ColorAlpha(self.Color, 50), true)

			local weapon = LocalPlayer():GetActiveWeapon()

			if edit and IsValid(weapon) and weapon:GetClass() == "eternity_zonemarker" then
				mins = self:GetZoneMins()
				maxs = self:GetZoneMaxs()

				local center = LerpVector(0.5, mins, maxs)

				mins = mins - center
				maxs = maxs - center

				render.SetColorMaterial()
				render.DrawBox(center, Angle(), mins, maxs, ColorAlpha(self.Color, 50))
				render.DrawWireframeBox(center, Angle(), mins, maxs, ColorAlpha(self.Color, 50))
				render.DrawLine(self:WorldSpaceCenter(), center, self.Color)
			end
		end

		if edit and ready then
			GAMEMODE:DrawWorldText(self:WorldSpaceCenter(), string.format("%s (%s)", self.PrintName, self:GetZOrder()), true)
		end
	end
end

function ENT:AffectsPlayer(ply)
	if ply:IsInNoClip() then
		return false
	end

	return true
end

function ENT:PlayerInside(ply)
	return tobool(self.Players[ply])
end

function ENT:PlayerActive(ply)
	return tobool(self.Active[ply])
end

function ENT:Enter(ply, transition)
end

function ENT:Exit(ply, transition)
end

function ENT:GetZOrder()
	return self:GetEntityID()
end

hook.Add("PlayerThink", "zones.PlayerThink", function(ply)
	if ply.LastZonePos and ply.LastZonePos:DistToSqr(ply:GetPos()) <= 400 and not ply.ForceZoneUpdate then -- 20^2
		return
	end

	ply.ForceZoneUpdate = false
	ply.LastZonePos = ply:GetPos()

	ply.ZoneStack = ply.ZoneStack or {}
	ply.ActiveZone = ply.ActiveZone or {}

	local entering = {}
	local exiting = {}

	local pos = ply:WorldSpaceCenter()

	for _, v in pairs(ents.FindByClass("ent_zone*")) do
		if not v.IsReady or not v:IsReady() then
			continue
		end

		local classname = v:GetClass()
		local inside = v:PlayerInside(ply)

		if pos:WithinAABox(v:GetZoneMins(), v:GetZoneMaxs()) and v:AffectsPlayer(ply) then
			if not inside then
				entering[classname] = entering[classname] or {}

				table.insert(entering[classname], v)

				v.Players[ply] = true
			end
		else
			if inside then
				exiting[classname] = exiting[classname] or {}
				exiting[classname][v] = true

				v.Players[ply] = nil
			end
		end
	end

	for classname, tab in pairs(entering) do
		ply.ZoneStack[classname] = ply.ZoneStack[classname] or {}

		table.sort(tab, function(a, b)
			return a:GetZOrder() < b:GetZOrder()
		end)

		for _, v in pairs(tab) do
			table.insert(ply.ZoneStack[classname], v)
		end
	end

	for classname, tab in pairs(ply.ZoneStack) do
		if #tab < 1 then
			continue
		end

		local exit = exiting[classname]

		table.Filter(tab, function(key, val)
			if not IsValid(val) then
				return false
			end

			if exit and exit[val] then
				return false
			end

			return true
		end)

		local active = ply.ActiveZone[classname]
		local target = tab[#tab]

		if active != target then
			if IsValid(active) then
				active.Active[ply] = nil
				active:Exit(ply, target != nil)
			end

			if IsValid(target) then
				target.Active[ply] = true
				target:Enter(ply, active != nil)
			end

			ply.ActiveZone[classname] = target
		end
	end
end)

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:OnInitialLoad()
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end

	function ENT:GetCustomData()
		return {
			ZoneMins = self:GetZoneMins(),
			ZoneMaxs = self:GetZoneMaxs()
		}
	end

	function ENT:LoadCustomData(data)
		self:SetZoneMins(data.ZoneMins)
		self:SetZoneMaxs(data.ZoneMaxs)
	end
end