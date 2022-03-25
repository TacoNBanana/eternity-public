AddCSLuaFile()
DEFINE_BASECLASS("eternity_melee_base")

SWEP.Base 				= "eternity_melee_base"

SWEP.PrintName 			= "Stunstick"
SWEP.Author 			= "TankNut"

SWEP.ViewModel 			= Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel 		= Model("models/weapons/w_stunbaton.mdl")

SWEP.HoldType 			= "melee"
SWEP.HoldTypeLowered 	= "normal"

SWEP.Delay 				= 0.7

SWEP.Animations = {
	idle = "idle01",
	hit = {"hitcenter1", "hitcenter2", "hitcenter3"},
	miss = {"misscenter1", "misscenter2"}
}

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Holstered")
	self:NetworkVar("Bool", 1, "Active")

	self:NetworkVar("Int", 0, "ItemID")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "NextIdle")
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	self:SetActive(false)
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) then
		self:ToggleActive()
	end
end

function SWEP:ToggleActive()
	local bool = not self:GetActive()

	self:SetActive(bool)

	if IsFirstTimePredicted() then
		self:EmitSound(bool and "Weapon_StunStick.Activate" or "Weapon_StunStick.Deactivate")
		self.Effect = bool and "StunstickImpact" or nil
	end
end

function SWEP:GetDamage()
	if self:GetActive() then
		return 5, DMG_SHOCK
	end

	return 20, DMG_CRUSH
end

function SWEP:GetCDamage()
	if self:GetActive() then
		return 40
	end

	return 0
end

function SWEP:DoHitSound()
	if self:GetActive() then
		self:EmitSound("Weapon_StunStick.Melee_Hit")
	else
		BaseClass.DoHitSound(self)
	end
end

function SWEP:DoMissSound()
	if self:GetActive() then
		self:EmitSound("Weapon_StunStick.Swing")
	else
		BaseClass.DoMissSound(self)
	end
end

local wm_glow = Material("effects/blueflare1")
local vm_glow = Material("sprites/light_glow02_add_noz")

if CLIENT then
	function SWEP:PostDrawViewModel()
		BaseClass.PostDrawViewModel(self)

		if self:GetActive() then
			local color = Color(255, 255, 255, 30)

			vm_glow:SetFloat("$alpha", color.a / 255)

			render.SetMaterial(vm_glow)

			local rear = self.VM:GetAttachment(self.VM:LookupAttachment("sparkrear"))

			if rear then
				local size = math.Rand(1, 2)

				render.DrawSprite(rear.Pos, size * 15, size * 15, color)
			end

			for i = 1, 9 do
				local a = self.VM:GetAttachment(self.VM:LookupAttachment("spark" .. i .. "a"))

				if a then
					local size = math.Rand(2.5, 5)

					render.DrawSprite(a.Pos, size, size, color)
				end

				local b = self.VM:GetAttachment(self.VM:LookupAttachment("spark" .. i .. "b"))

				if b then
					local size = math.Rand(2.5, 5)

					render.DrawSprite(b.Pos, size, size, color)
				end
			end
		end
	end

	function SWEP:DrawWorldModel()
		self:DrawModel()

		if self:GetActive() then
			local size = math.Rand(4, 6)
			local glow = math.Rand(0.6, 0.8) * 255

			local color = Color(glow, glow, glow)

			local att = self:GetAttachment(1)

			if att then
				local position = att.Pos

				render.SetMaterial(wm_glow)
				render.DrawSprite(position, size * 2, size * 2, color)
			end
		end
	end
end