AddCSLuaFile()

SWEP.PrintName 				= "Broom"
SWEP.Author 				= "TankNut"

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

SWEP.Slot 					= 2

SWEP.UseHands 				= false
SWEP.ViewModel 				= Model("models/weapons/c_arms.mdl")
SWEP.WorldModel 			= Model("models/props_c17/pushbroom.mdl")

SWEP.DrawCrosshair 			= false

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:PlayVCD(seq)
	local ply = self.Owner

	ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(seq), 0, true)

	if SERVER then
		netstream.Send("PlayVCD", {
			Ply = ply,
			Seq = seq
		})
	end
end

if CLIENT then
	netstream.Hook("PlayVCD", function(data)
		local ply = data.Ply

		if not IsValid(ply) or ply:IsDormant() or ply == LocalPlayer() then
			return
		end

		ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(data.Seq), 0, true)
	end)
end

function SWEP:PrimaryAttack()
	if IsFirstTimePredicted() then
		self:PlayVCD("g_sweep")
	end

	self:SetNextPrimaryFire(CurTime() + 2)
end

function SWEP:SecondaryAttack()
end

function SWEP:DrawWorldModel()
	local ply = self.Owner
	local att = ply:GetAttachment(ply:LookupAttachment("cleaver_attachment"))

	if att then
		self:SetRenderOrigin(att.Pos)
		self:SetRenderAngles(att.Ang)
	end

	self:DrawModel()
end

function SWEP:CalcMainActivity(ply, vel)
	if ply.CalcIdeal == ACT_WALK then
		ply.CalcSeqOverride = ply:LookupSequence("Walk_all_HoldBroom")
	end

	if ply.CalcIdeal == ACT_IDLE or ply.CalcIdeal == ACT_IDLE_ANGRY then
		ply.CalcSeqOverride = ply:LookupSequence("sweep_idle")
	end
end