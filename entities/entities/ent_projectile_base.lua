AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 					= "ent_base"

ENT.Author 					= "TankNut"

ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

ENT.AutomaticFrameAdvance	= true

ENT.Model 					= Model("models/weapons/w_missile_launch.mdl")

ENT.Velocity 				= 3000

ENT.UseGravity 				= false
ENT.GravityMultiplier 		= 0.3

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self.LastThink = CurTime()
	end

	self:SetStartPos(self:GetPos())
	self:SetVel(self:GetForward() * self.Velocity)
end

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "StartPos")
	self:NetworkVar("Vector", 1, "StopPos")
	self:NetworkVar("Vector", 2, "Vel")
end

if SERVER then
	function ENT:Process()
	end

	function ENT:Think()
		if self:GetStopPos() != vector_origin then
			return
		end

		local grav = self.UseGravity and physenv.GetGravity() * self.GravityMultiplier or Vector()
		local delta = CurTime() - self.LastThink

		self:SetVel(self:GetVel() + (grav * delta))
		self:Process(delta)

		local pos = self:GetPos() + self:GetVel() * delta

		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = pos,
			mask = MASK_SHOT,
			filter = {self:GetOwner(), self}
		})

		if tr.Fraction != 1 then
			self:OnHit(tr)

			return
		end

		self:SetPos(pos)
		self:SetAngles(self:GetVel():Angle())

		self.LastThink = CurTime()
		self:NextThink(CurTime())

		return true
	end

	function ENT:OnHit(tr)
		self:SetPos(tr.HitPos)
		self:SetStopPos(tr.HitPos)

		SafeRemoveEntityDelayed(self, 1)
	end
end