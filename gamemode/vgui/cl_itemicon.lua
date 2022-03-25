local PANEL = {}
DEFINE_BASECLASS("DModelPanel")

AccessorFunc(PANEL, "_ReadOnly", "ReadOnly", FORCE_BOOL)

function PANEL:OnRemove()
	if GAMEMODE.TooltipOrigin == self then
		GAMEMODE.Tooltip = nil
	end
end

function PANEL:Setup(item)
	self.ItemID = item.NetworkID

	item.Icons[self] = true

	self:SetModel(item.Model)
	self:SetSkin(item.Skin)

	for k, v in pairs(item.Bodygroups) do
		if isnumber(k) then
			self.Entity:SetBodygroup(k, v)
		end
	end

	if #item.Material > 0 then
		self.Entity:SetMaterial(item.Material)
	end

	local color = item.Color

	if not IsColor(color) then
		color = Color(color.r, color.g, color.b)
	end

	self:SetColor(color)

	if not self._ReadOnly then
		self:Droppable("ItemIcon")
	end
end

function PANEL:GetItem()
	return GAMEMODE:GetItem(self.ItemID)
end

function PANEL:SetSkin(num)
	self.Entity:SetSkin(num)
end

function PANEL:LayoutEntity(ent)
	local tab = PositionSpawnIcon(ent, ent:GetPos())

	self:SetCamPos(tab.origin)
	self:SetLookAng(tab.angles)
	self:SetFOV(tab.fov)
end

function PANEL:PaintAt(x, y, w, h)
	x = x + (self:GetWide() * 0.5) - 8 - self.GrabX
	y = y + (self:GetTall() * 0.5) - 8 - self.GrabY

	return BaseClass.PaintAt(self, x, y, w, h)
end

function PANEL:OnDepressed()
	self.GrabX, self.GrabY = self:ScreenToLocal(gui.MousePos())
end

function PANEL:DoDoubleClick()
	local item = self:GetItem()

	if table.Count(item.Inventories) > 0 and item:CanInteractWithChild(LocalPlayer()) then
		GAMEMODE:OpenGUI("InventoryPopup", item:GetName(), item.Inventories)

		return
	end

	if not self._ReadOnly and #item.EquipmentSlots > 0 then
		local from = item:GetInventory()
		local targets = {}

		if item:IsEquipped() then
			targets = {LocalPlayer():GetInventory("Main")}
		else
			for _, v in pairs(item.EquipmentSlots) do
				local inv = LocalPlayer():GetInventory(v)

				if inv then
					table.insert(targets, inv)
				end
			end
		end

		for _, v in pairs(targets) do
			if not LocalPlayer():CanMoveItem(item, from, v) then
				continue
			end

			local w, h = item:GetSize()
			local flip = false

			local ok, x, y = v:FindFit(w, h)

			if not ok then
				ok, x, y = v:FindFit(h, w)
				flip = true

				if not ok then
					continue
				end
			end

			netstream.Send("MoveItem", {
				ID = item.NetworkID,
				Inventory = v.NetworkID,
				Pos = {x, y},
				Flip = flip
			})
			return
		end
	end
end

function PANEL:DoRightClick()
	if self._ReadOnly then
		return
	end

	self:GetItem():CreateOptions(LocalPlayer())
end

function PANEL:OnCursorEntered()
	GAMEMODE.TooltipOrigin = self
	GAMEMODE.Tooltip = self:GetItem():GetToolTip()
end

function PANEL:OnCursorExited()
	GAMEMODE.TooltipOrigin = nil
	GAMEMODE.Tooltip = nil
end

function PANEL:Paint(w, h)
	local tab = dragndrop.GetDroppable("ItemIcon")

	if tab and tab[1] == self and not self.PaintingDragging then
		return
	end

	local colors = GAMEMODE:GetConfig("UIColors")
	local fill = ((self:IsHovered() and not dragndrop.IsDragging()) or self.PaintingDragging) and colors.Primary or colors.FillDark

	surface.SetDrawColor(ColorAlpha(fill, 230))
	surface.DrawRect(0, 0, w, h)

	render.ClearDepth()

	BaseClass.Paint(self, w, h)

	local col = self:GetItem():GetOutlineColor()

	if col == true then
		local time = CurTime() * 50

		col = HSVToColor(time % 360, 1, 1)
	end

	local overlay = self:GetItem():GetIconText()

	if overlay then
		local obj = markleft.Parse(overlay, w)

		obj:Draw(3, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255)
	end

	surface.SetDrawColor(ColorAlpha(col, 230))
	surface.DrawRect(w - 10, h - 10, 8, 8)

	surface.SetDrawColor(ColorAlpha(colors.Border, 230))
	surface.DrawOutlinedRect(w - 10, h - 10, 8, 8)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:DrawModel()
	local left = 0
	local right = self:GetWide()
	local top = 0
	local bottom = self:GetTall()

	if self.PaintingDragging then
		local x, y = self:GetPos()

		left = x
		right = x + right
		top = y
		bottom = y + bottom
	end

	local current = self
	local previous = current

	while IsValid(current:GetParent()) do
		current = current:GetParent()

		local x, y = previous:GetPos()

		left = math.max(x, left + x)
		right = math.min(x + previous:GetWide(), right + x)
		top = math.max(y, top + y)
		bottom = math.min(y + previous:GetTall(), bottom + y)

		previous = current
	end

	render.SetScissorRect(left, top, right, bottom, true)

	if self:PreDrawModel(self.Entity) then
		self.Entity:DrawModel()
		self:PostDrawModel(self.Entity)
	end

	render.SetScissorRect(0, 0, 0, 0, false)
end

vgui.Register("eternity_itemicon", PANEL, "DModelPanel")