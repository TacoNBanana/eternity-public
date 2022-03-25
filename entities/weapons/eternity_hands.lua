AddCSLuaFile()

SWEP.PrintName 				= "Hands"
SWEP.Author 				= "TankNut"

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

SWEP.Slot 					= 1
SWEP.SlotPos 				= 1

SWEP.UseHands 				= false
SWEP.ViewModel 				= Model("models/weapons/c_arms.mdl")
SWEP.WorldModel 			= ""

SWEP.DrawCrosshair 			= false

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.HoldType 				= "fist"
SWEP.HoldTypeLowered 		= "normal"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Holstered")

	self:NetworkVar("Float", 0, "NextModeSwitch")
end

function SWEP:Initialize()
	if CLIENT then
		self:Deploy()
	end
end

function SWEP:Deploy()
	self:SetHolstered(true)
end

function SWEP:Think()
	if self:ShouldLower() then
		self:SetHoldType(self.HoldTypeLowered)
	else
		self:SetHoldType(self.HoldType)
	end
end

function SWEP:ShouldLower()
	return self:GetHolstered()
end

function SWEP:ToggleHolster()
end

function SWEP:PrimaryAttack()
	if self:GetHolstered() then
		self:Knock()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	self.NextReload = self.NextReload or CurTime()

	if self.NextReload > CurTime() then
		return
	end

	self.NextReload = CurTime() + 2
	self:Ram()
end

function SWEP:GetHandTrace(range)
	local ply = self.Owner
	local eye = ply:EyePos()

	return util.TraceLine({
		start = eye,
		endpos = eye + (ply:GetAimVector() * (range or 50)),
		filter = ply
	})
end

function SWEP:Knock()
	local ent = self:GetHandTrace().Entity

	if not IsValid(ent) or not ent:IsDoor() then
		return
	end

	if SERVER then
		sound.Play("physics/wood/wood_crate_impact_hard2.wav", ent:WorldSpaceCenter(), 70, math.random(95, 105), 1)
	end

	self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:GetRamChance(ent)
	if not ent:DoorLocked() then
		return 100
	end

	if ent:CombineLock() then
		return 0
	end

	return 10 + (self.Owner:ArmorLevel() * 10)
end

function SWEP:Ram()
	local ply = self.Owner
	local tr = self:GetHandTrace(130)
	local ent = tr.Entity

	if ply:GetVelocity():Length() > 50 or ply:Crouching() or not ply:OnGround() or ply:Restrained() then
		return
	end

	if not IsValid(ent) or not ent:IsDoor() then
		return
	end

	if tr.Fraction < 0.2 then
		return
	end

	local classname = ent:GetClass()

	if classname != "prop_door_rotating" and classname != "func_door_rotating" then
		return
	end

	if ent:DoorType() == DOOR_COMBINE or ent:DoorType() == DOOR_IGNORED then
		return
	end

	ply:SetVelocity(tr.Normal * 1000)
	ply:ViewPunch(Angle(-10, 0, 0))

	if SERVER then
		ply:TakeCDamage(8)

		ent:EmitSound(string.format("physics/wood/wood_crate_impact_hard%s.wav", table.Random({"1", "4", "5"})))

		ent = ent:GetMainDoor()

		local chance = math.Clamp(ent:RamChance() + self:GetRamChance(ent), 0, 100)

		if chance < math.random(1, 100) then
			ent:SetRamChance(chance)

			return
		end

		ent:RamDoor(ply)
	end
end