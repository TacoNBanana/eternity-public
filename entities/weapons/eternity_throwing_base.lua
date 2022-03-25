AddCSLuaFile()
DEFINE_BASECLASS("eternity_base")

SWEP.Base 				= "eternity_base"

SWEP.DrawCrosshair 		= false

SWEP.HoldType 			= "grenade"
SWEP.HoldTypeLowered 	= "normal"

SWEP.DefaultOffset 		= {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 0, 0)
}

SWEP.LoweredOffset 		= {
	ang = Angle(0, 0, 0),
	pos = Vector(0, 0, 0)
}

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Holstered")

	self:NetworkVar("Int", 0, "ThrowMode")
	self:NetworkVar("Int", 1, "ItemID")

	self:NetworkVar("Float", 0, "NextModeSwitch")
	self:NetworkVar("Float", 1, "FinishReload")
	self:NetworkVar("Float", 2, "FinishThrow")
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	self:PlayAnimation("draw", -1, 1, true, self.VM, true)
end

function SWEP:CanFire()
	if self:ShouldLower() then
		return false
	end

	if self:IsReloading() then
		return false
	end

	if self:IsThrowing() then
		return false
	end

	return true
end

function SWEP:IsReloading()
	return self:GetFinishReload() != 0
end

function SWEP:IsThrowing()
	return self:GetFinishThrow() != 0
end

function SWEP:ShouldLower()
	return self:GetHolstered()
end

function SWEP:PrimaryAttack()
	if not self:CanFire() then
		return
	end

	local duration = self:PlayAnimation("drawbackhigh")

	self:SetThrowMode(THROW_NORMAL)
	self:SetFinishThrow(CurTime() + duration)
end

function SWEP:SecondaryAttack()
	if not self:CanFire() then
		return
	end

	local duration = self:PlayAnimation("drawbacklow")

	if self.Owner:Crouching() then
		self:SetThrowMode(THROW_ROLL)
	else
		self:SetThrowMode(THROW_LOB)
	end

	self:SetFinishThrow(CurTime() + duration)
end

function SWEP:Think()
	BaseClass.Think(self)

	if self:IsThrowing() and self:GetFinishThrow() <= CurTime() then
		self:SetFinishThrow(0)
		self:Throw()
	elseif self:IsReloading() and self:GetFinishReload() <= CurTime() then
		self:SetFinishReload(0)
		self:FinishReload()
	end
end

function SWEP:GetItem()
	return GAMEMODE:GetItem(self:GetItemID())
end

function SWEP:Throw()
	local ply = self.Owner

	ply:SetAnimation(PLAYER_ATTACK1)

	local mode = self:GetThrowMode()

	if SERVER then
		self:ThrowEntity(mode)
	end

	local duration = 0

	if mode == THROW_NORMAL then
		duration = self:PlayAnimation("throw")
	elseif mode == THROW_ROLL then
		duration = self:PlayAnimation("roll")
	elseif mode == THROW_LOB then
		duration = self:PlayAnimation("lob")
	end

	self:SetFinishReload(CurTime() + duration)
end

function SWEP:FinishReload()
	if SERVER then
		local item = self:GetItem()

		if item then
			item:AdjustAmount(-1)
		end
	end

	if not IsValid(self.Owner) then
		return
	end

	local duration = self:PlayAnimation("draw")

	self:SetNextPrimaryFire(CurTime() + duration)
	self:SetNextSecondaryFire(CurTime() + duration)
end

function SWEP:GetThrowPosition(pos)
	local tr = util.TraceHull({
		start = self.Owner:EyePos(),
		endpos = pos,
		mins = Vector(-4, -4, -4),
		maxs = Vector(4, 4, 4),
		filter = self.Owner
	})

	return tr.Hit and tr.HitPos or pos
end

function SWEP:ThrowEntity(mode)
	local ply = self.Owner
	local ent = self:CreateEntity()

	if not IsValid(ent) then
		return
	end

	local phys = ent:GetPhysicsObject()

	if not IsValid(phys) then
		return
	end

	if mode == THROW_NORMAL then
		local pos = ply:EyePos() + (ply:GetForward() * 18) + (ply:GetRight() * 8)

		ent:SetPos(self:GetThrowPosition(pos))

		phys:SetVelocity(ply:GetVelocity() + ply:GetForward() * 1200)
		phys:AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0))
	elseif mode == THROW_ROLL then
		local pos = ply:GetPos() + Vector(0, 0, 4)
		local facing = ply:GetAimVector()

		facing.z = 0
		facing = facing:GetNormalized()

		local tr = util.TraceLine({
			start = pos,
			endpos = pos + Vector(0, 0, -16),
			filter = ply
		})

		if tr.Fraction != 1 then
			local tan = facing:Cross(tr.Normal)

			facing = tr.Normal:Cross(tan)
		end

		pos = pos + (facing * 18)

		ent:SetPos(self:GetThrowPosition(pos))
		ent:SetAngles(Angle(0, ply:GetAngles().y, -90))

		phys:SetVelocity(ply:GetVelocity() + ply:GetForward() * 700)
		phys:AddAngleVelocity(Vector(0, 0, 720))
	elseif mode == THROW_LOB then
		local pos = ply:EyePos() + (ply:GetForward() * 18) + (ply:GetRight() * 8)

		ent:SetPos(self:GetThrowPosition(pos))

		phys:SetVelocity(ply:GetVelocity() + (ply:GetForward() * 350) + Vector(0, 0, 50))
		phys:AddAngleVelocity(Vector(200, math.random(-600, 600), 0))
	end
end

function SWEP:CreateEntity()
end

function SWEP:ToggleHolster()
	if CurTime() < self:GetNextModeSwitch() then
		return
	end

	if self:IsThrowing() or self:IsReloading() then
		return
	end

	local bool = not self:GetHolstered()

	self:SetHolstered(bool)

	local duration = 0

	if bool then
		duration = self:PlayAnimation("draw", -1, 0, true, self.VM, true)
	else
		duration = self:PlayAnimation("draw", 1, 0, true, self.VM, true)
	end

	self:SetNextModeSwitch(CurTime() + duration)
	self:SetNextPrimaryFire(CurTime() + duration)
	self:SetNextSecondaryFire(CurTime() + duration)
end