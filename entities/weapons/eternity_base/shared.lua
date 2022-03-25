AddCSLuaFile()

SWEP.Author 				= "TankNut"

SWEP.RenderGroup 			= RENDERGROUP_TRANSLUCENT

SWEP.Slot 					= 2

SWEP.UseHands 				= true

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.SwayIntensity 			= 1
SWEP.RunThreshold 			= 1.2

SWEP.ApproachSpeed 			= 10

SWEP.VMMovementScale 		= 0.4

SWEP.Recoil 				= 1

SWEP.VMBodyGroups 			= {}
SWEP.WMBodyGroups 			= {}

-- Replacing the table with just a single entry applies it as a normal material instead of a sub
-- Using true instead of a string hides the submaterial instead
SWEP.VMSubMaterials 		= {}
SWEP.WMSubMaterials 		= {}

--[[
Takes an animation name as key and either a single sequence or a table of sequence as values

SWEP.Animations = {
	reload = "ir_reload",
	fire = {"fire1", "fire2", "fire3"}
}

fire animation is usable in conjuction with SWEP.UseFireAnimation]]
SWEP.Animations = {}

--[[
Takes a sequence as key and a table of sound data as the value

SWEP.SoundScripts = {
	reload = {
		{time = 0.33, snd = soundscript.AddReload("TEKKA_AKM_MAGOUT", "weapons/ak47/ak47_clipout.wav")},
		{time = 1.13, snd = soundscript.AddReload("TEKKA_AKM_MAGIN", "weapons/ak47/ak47_clipin.wav")},
		{time = 1.7, snd = soundscript.AddReload("TEKKA_AKM_BOLT", "weapons/ak47/ak47_boltpull.wav")}
	}
}]]
SWEP.SoundScripts = {}

SWEP.HoldType 			= "ar2"
SWEP.HoldTypeLowered 	= "passive"

SWEP.DefaultOffset = {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 0, 0)
}

SWEP.LoweredOffset = {
	ang = Angle(-10, 35, 0),
	pos = Vector(0, 0, 0)
}

AddCSLuaFile("cl_model.lua")
AddCSLuaFile("cl_offsets.lua")

AddCSLuaFile("sh_animations.lua")

include("sh_animations.lua")

if CLIENT then
	include("cl_model.lua")
	include("cl_offsets.lua")
end

function SWEP:Initialize()
	self:SetupModel()

	if CLIENT then
		self:Deploy() -- Client doesn't call deploy the first time
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Holstered")

	self:NetworkVar("Float", 0, "NextModeSwitch")
end

function SWEP:Deploy()
	if not IsValid(self.Owner) then
		return
	end

	self:SetHolstered(true)
	self:SetHoldType(self.HoldTypeLowered)

	if CLIENT then
		self.BlendPos, self.BlendAng = Vector(self.LoweredOffset.pos), Angle(self.LoweredOffset.ang)
	end

	self:PlayAnimation("draw", 1, 0, true, self.VM, true)
end

function SWEP:SetupWM()
	if istable(self.WMSubMaterials) then
		for k, v in pairs(self.WMSubMaterials) do
			if not isnumber(k) then
				continue
			end

			if isstring(v) then
				self:SetSubMaterial(k, v)
			else
				self:SetSubMaterial(k, "engine/occlusionproxy")
			end
		end
	else
		self:SetMaterial(self.WMSubMaterials)
	end

	for k, v in pairs(self.WMBodyGroups) do
		if not isnumber(k) then
			continue
		end

		self:SetBodygroup(k, v)
	end
end

function SWEP:Think()
	if self:ShouldLower() then
		self:SetHoldType(self.HoldTypeLowered)
	else
		self:SetHoldType(self.HoldType)
	end

	self:SoundThink()
end

function SWEP:ShouldLower()
	local ply = self.Owner

	if self:GetHolstered() then
		return true
	end

	if ply:IsInNoClip() then
		return false
	end

	if not ply:OnGround() then
		return true
	end

	if self:IsSprinting() then
		return true
	end

	return false
end

function SWEP:IsSprinting()
	local ply = self.Owner
	local vel = ply:GetVelocity():Length()
	local walk = ply:GetWalkSpeed()

	if not ply:OnGround() then
		return false
	end

	if ply:KeyDown(IN_SPEED) and vel > (walk * self.RunThreshold) then
		return true
	end

	if vel > walk * 3 then
		return true
	end

	return false
end

function SWEP:ToggleHolster()
	if CurTime() < self:GetNextModeSwitch() then
		return
	end

	self:SetNextModeSwitch(CurTime() + 0.3)

	self:SetHolstered(not self:GetHolstered())
end

function SWEP:OnRemove()
	if CLIENT then
		self:RemoveManagedCSModels()
	end
end

function SWEP:OnReloaded()
	self:SetupModel()
	self:PlayAnimation("draw", 1, 1, true, self.VM, true)
end

function SWEP:SetupModel()
	self:SetupWM()

	if CLIENT and LocalPlayer() == self.Owner then
		local pos, ang

		if IsValid(self.VM) then
			pos = self.VM:GetPos()
			ang = self.VM:GetAngles()
		end

		self:SetupCustomVM(self.ViewModel)

		if pos and ang then
			self.VM:SetPos(pos)
			self.VM:SetAngles(ang)
		end
	end
end

function SWEP:GetInitial(key)
	local stored = weapons.GetStored(self:GetClass())
	local val = stored[key]

	if istable(val) then
		val = table.Copy(val)
	end

	return val
end