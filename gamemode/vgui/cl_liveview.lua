local PANEL = {}
DEFINE_BASECLASS("eternity_modelpanel")

function PANEL:Init()
	self.TargetCamPos = Vector(100, 0, 45)
	self.TargetLookAt = Vector(0, 0, 31)
end

function PANEL:LayoutEntity(ent)
	local pos, look = self:GetTargets()

	if not ent.PanelLayoutDone then
		ent.PanelLayoutDone = true
	end

	self:SetCamPos(pos)
	self:SetLookAt(look)
end

function PANEL:GetTargets()
	local pos = Vector(self.TargetCamPos)
	local look = Vector(self.TargetLookAt)

	local ang = Angle(0, self.Entity:EyeAngles().y, 0)

	pos:Rotate(ang)
	look:Rotate(ang)

	return self.Entity:GetPos() + pos, self.Entity:GetPos() + look
end

function PANEL:PreDrawModel()
	if self.Entity:IsInNoClip() then
		return true
	end

	render.ClearDepth()

	self.Entity.ForceDraw = true
	self.Entity:DrawModel()

	local parts = part.Get(self.Entity)

	if parts then
		for _, v in pairs(parts) do
			if IsValid(v.Ent) then
				v.Ent:DrawModel()
			end
		end
	end

	local weapon = self.Entity:GetActiveWeapon()

	if IsValid(weapon) then
		if weapon.DrawWorldModel then
			weapon:DrawWorldModel()
		else
			weapon:DrawModel()
		end
	end

	self.Entity.ForceDraw = nil

	return false
end

vgui.Register("eternity_liveview", PANEL, "eternity_modelpanel")