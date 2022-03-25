AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_OPAQUE

ENT.PrintName 		= "Ammo Cabinet"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/ishi/halo_rebirth/props/human/ammo_box.mdl")
ENT.Color 			= Color(0, 127, 31)

ENT.Cooldown 		= 300 -- 5 minutes

-- ["ammo group"] = {"item type", max amount}
ENT.AmmoTypes 		= {
	["102mm"] = {"ammo_102mm_spnkr", 12}, -- 2 stacks
	["127x40mm"] = {"ammo_127x40mm", 360}, -- 3 stacks
	["145x114mm"] = {"ammo_145x114mm", 120}, -- 3 stacks
	["40mm"] = {"ammo_40mm_hedp", 18}, -- 3 stacks
	["5x23mm"] = {"ammo_5x23mm", 4800}, -- 10 stacks
	["762x51mm"] = {"ammo_762x51mm", 3200}, -- 10 stacks
	["8ga"] = {"ammo_8ga_buckshot", 240} -- 4 stacks
}

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		self:SetUseType(SIMPLE_USE)
	end

	self:DrawShadow(false)

	GAMEMODE.AmmoBoxCache = GAMEMODE.AmmoBoxCache or {}
end

function ENT:OnCooldown(ply)
	local last = GAMEMODE.AmmoBoxCache[ply:CharID()]

	if last and last + self.Cooldown >= CurTime() then
		return true, (last + self.Cooldown) - CurTime()
	end

	return false
end

if CLIENT then
	function ENT:Think()
		self:SetBodyGroups(self:OnCooldown(LocalPlayer()) and "111" or "000")
	end

	function ENT:Draw()
		self:DrawModel()

		local edit = LocalPlayer():IsInEditMode()
		local ready = self:IsReady()

		if edit or not ready then
			local mins = self:OBBMins() - Vector(0.1, 0.1, 0.1)
			local maxs = self:OBBMaxs() + Vector(0.1, 0.1, 0.1)

			render.SetColorMaterial()
			render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, ColorAlpha(self.Color, 50), true)
		end
	end

	netstream.Hook("UsedAmmoBox", function(data)
		GAMEMODE.AmmoBoxCache[data.CharID] = data.Time
	end)
else
	function ENT:Use(ply)
		if not self:IsReady() then
			return
		end

		local cooldown, remaining = self:OnCooldown(ply)

		if cooldown then
			ply:SendChat("ERROR", "You cannot use this for another " .. string.NiceTime(remaining) .. "!")

			return
		end

		local weapon = ply:GetActiveWeapon()
		local data = self.AmmoTypes[weapon and weapon.AmmoGroup or ""]

		if not data then
			ply:SendChat("ERROR", "The cabinet doesn't have ammo for this type of weapon!")

			return
		end

		local existing = ply:GetItemCount(data[1], true)

		if existing >= data[2] then
			ply:SendChat("ERROR", "You're already carrying enough ammo!")

			return
		end

		GAMEMODE.AmmoBoxCache[ply:CharID()] = CurTime()

		self:EmitSound("BaseCombatCharacter.AmmoPickup")

		netstream.Send("UsedAmmoBox", {
			CharID = ply:CharID(),
			Time = CurTime()
		}, ply)

		coroutine.WrapFunc(function()
			local count = math.min(class.Get(data[1]).MaxStack, data[2] - existing)

			ply:GiveItem(data[1], count, true)
			ply:SendChat("NOTICE", "You take " .. count .. " rounds out of the cabinet.")
		end)
	end
end