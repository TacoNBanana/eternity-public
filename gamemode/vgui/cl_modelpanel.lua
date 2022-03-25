local PANEL = {}
DEFINE_BASECLASS("DModelPanel")

AccessorFunc(PANEL, "_AllowManipulation", "AllowManipulation")

function PANEL:Init()
	self.Zoom = 0

	self.CamPosTargets = {Vector(100, 100, 50), Vector(50, 50, 64)}
	self.LookAtTargets = {Vector(0, 0, 36), Vector(0, 0, 64)}
	self.FOVTargets = {20, 11}

	self.Offset = Vector()

	self.Dragging = false
	self.DragStart = 0
end

function PANEL:SetEntity(ent)
	BaseClass.SetEntity(self, ent)

	ent.PanelLayoutDone = false
end

function PANEL:SetModel(mdl)
	local cycle = 0

	if IsValid(self.Entity) then
		cycle = self.Entity:GetCycle()
	end

	BaseClass.SetModel(self, mdl)

	for k, v in pairs(GAMEMODE:GetConfig("IdleAnimations")) do
		if string.find(string.lower(mdl), k) then
			if v.Sequence then
				self.Entity:SetSequence(self.Entity:LookupSequence(v.Sequence))
			end

			if v.Offset then
				self.Offset = v.Offset
			end

			break
		end
	end

	self.Entity:SetCycle(cycle)
end

function PANEL:SetSkin(num)
	self.Entity:SetSkin(num)
end

function PANEL:LayoutEntity(ent)
	if self.bAnimated then
		self:RunAnimation()
	end

	local pos, look, fov = self:GetTargets()

	if not ent.PanelLayoutDone then
		ent.PanelLayoutDone = true

		self:SetCamPos(pos)
		self:SetLookAt(look)
		self:SetFOV(fov)

		ent:SetAngles(Angle(0, 20, 0))
	end

	if not self._AllowManipulation then
		return
	end

	self:SetCamPos(math.ApproachVectorSpeed(self:GetCamPos(), pos, 10))
	self:SetLookAt(math.ApproachVectorSpeed(self:GetLookAt(), look, 10))
	self:SetFOV(math.ApproachSpeed(self:GetFOV(), fov, 10))

	local ang = Angle(0, 20, 0)

	if self.Dragging then
		local diff = gui.MouseX() - self.DragStart

		ang = Angle(0, 20 + diff, 0)
	end

	local att = ent:GetAttachment(ent:LookupAttachment("eyes"))
	local height = att.Pos.z or 64
	local dir = att.Ang:Forward() or ent:GetForward()

	ent:SetAngles(math.ApproachAngleSpeed(ent:GetAngles(), ang, 30))
	ent:SetEyeTarget(Vector(0, 0, height) + dir * 50)
end

function PANEL:GetTargets()
	local pos = LerpVector(self.Zoom, self.CamPosTargets[1], self.CamPosTargets[2])
	local look = LerpVector(self.Zoom, self.LookAtTargets[1], self.LookAtTargets[2])
	local fov = Lerp(self.Zoom, self.FOVTargets[1], self.FOVTargets[2])

	return self.Entity:GetPos() + pos, self.Entity:GetPos() + look, fov
end

function PANEL:OnMouseWheeled(delta)
	if delta > 0 then
		self.Zoom = math.Approach(self.Zoom, 1, 0.2)
	else
		self.Zoom = math.Approach(self.Zoom, 0, 0.2)
	end
end

function PANEL:OnMousePressed(mouse)
	if self._AllowManipulation and mouse == MOUSE_LEFT then
		self:MouseCapture(true)

		self.Dragging = true
		self.DragStart = gui.MouseX()
	end
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self.Dragging = false

	local ang = self.Entity:GetAngles()

	ang:Normalize()

	self.Entity:SetAngles(ang)
end

vgui.Register("eternity_modelpanel", PANEL, "DModelPanel")