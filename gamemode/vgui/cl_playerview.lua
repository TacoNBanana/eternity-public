local PANEL = {}
DEFINE_BASECLASS("eternity_modelpanel")

function PANEL:Init()
	self.TargetCamPos = Vector(60, -20, 64)
	self.TargetLookAt = Vector(0, 0, 64)
end

function PANEL:SetPlayer(ply)
	local data = ply:ModelData()

	if not data or not data._base then
		self:SetModel("models/Kleiner.mdl")

		return
	end

	self:SetModel(data._base.Model)

	local icon = self.Entity

	icon.GetPlayerColor = function() return ply:GetPlayerColor() end
	icon:ApplyModel(data._base, true)

	for k, v in pairs(data) do
		if k != "_base" then
			part.Add(icon, k, v)
		end
	end
end

function PANEL:LayoutEntity(ent)
	self:RunAnimation()

	local pos, look = self:GetTargets()

	if not ent.PanelLayoutDone then
		ent.PanelLayoutDone = true
	end

	self:SetCamPos(pos)
	self:SetLookAt(look)
	self:SetFOV(20)

	local height = 64
	local dir = ent:GetForward()

	local att = ent:GetAttachment(ent:LookupAttachment("eyes"))

	if att then
		height = att.Pos.z
		dir = att.Ang:Forward()
	end

	ent:SetEyeTarget(Vector(0, 0, height) + dir * 50)
end

function PANEL:GetTargets()
	local pos = Vector(self.TargetCamPos)
	local look = Vector(self.TargetLookAt)

	local ang = Angle(0, self.Entity:EyeAngles().y, 0)

	pos:Rotate(ang)
	look:Rotate(ang)

	pos = pos + self.Offset
	look = look + self.Offset

	return self.Entity:GetPos() + pos, self.Entity:GetPos() + look
end

function PANEL:PreDrawModel()
	local ent = self.Entity

	render.ClearDepth()

	ent.ForceDraw = true
	ent:DrawModel()

	local parts = part.Get(self.Entity)

	if parts then
		for _, v in pairs(parts) do
			if IsValid(v.Ent) then
				v.Ent:DrawModel()
			end
		end
	end

	ent.ForceDraw = nil

	return false
end

vgui.Register("eternity_playerview", PANEL, "eternity_modelpanel")