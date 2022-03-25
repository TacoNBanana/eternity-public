local PANEL = {}

AccessorFunc(PANEL, "_SingleSlot", "SingleSlot")

function PANEL:Init()
	self.IconSize = GAMEMODE:GetConfig("ItemIconSize")
	self.IconMargin = GAMEMODE:GetConfig("ItemIconMargin")
end

function PANEL:GetInventory()
	return GAMEMODE:GetInventory(self.InventoryID)
end

function PANEL:GetOrigin(x, y)
	x = x - 1
	y = y - 1

	x = (x * self.IconSize) + (x * self.IconMargin)
	y = self:GetLabelSize() + (y * self.IconSize) + (y * self.IconMargin)

	return x, y
end

function PANEL:GetGrid(x, y)
	local max = self.IconSize + self.IconMargin

	local gridx = math.Round(x / max) + 1
	local gridy = math.Round(y / max) + 1

	return gridx, gridy
end

function PANEL:Setup(inventory)
	local readonly = not inventory:CanInteract(LocalPlayer())

	if not readonly then
		self:Receiver("ItemIcon", function(pnl, panels, dropped, index, x, y)
			local icon = panels[1]
			local item = icon:GetItem()
			local from = item:GetInventory()
			local to = pnl:GetInventory()

			x = x - icon.GrabX
			y = y - icon.GrabY - self.TallOffset

			x, y = pnl:GetGrid(x, y)

			if not x or not y then
				return
			end

			x = math.Clamp(x, 1, to.Width)
			y = math.Clamp(y, 1, to.Height)

			if dropped then
				local receiver = to:GetItem(x, y)

				if receiver then
					if not receiver:CanInteract(LocalPlayer()) then
						return
					end

					coroutine.WrapFunc(function()
						receiver:OnUse(LocalPlayer(), item)
					end)

					netstream.Send("UseItem", {
						ID = item.NetworkID,
						Target = receiver.NetworkID
					})
				end

				if not LocalPlayer():CanMoveItem(item, from, to) then
					return
				end

				local w, h = to:ResolveSize(item:GetSize())

				if to:CanFit(x, y, w, h, {[item.NetworkID] = true}) then
					icon:SetZPos(1000)
					icon:SetParent(pnl)
					icon:SetPos(pnl:GetOrigin(x, y))
					icon:SetSize(pnl:GetIconSize(item))

					netstream.Send("MoveItem", {
						ID = item.NetworkID,
						Inventory = to.NetworkID,
						Pos = {x, y}
					})
				elseif to:CanFit(x, y, h, w, {[item.NetworkID] = true}) then
					icon:SetZPos(1000)
					icon:SetParent(pnl)
					icon:SetPos(pnl:GetOrigin(x, y))

					local size1, size2 = pnl:GetIconSize(item)

					icon:SetSize(size2, size1)

					netstream.Send("MoveItem", {
						ID = item.NetworkID,
						Inventory = to.NetworkID,
						Pos = {x, y},
						Flip = true
					})
				end
			else
				self.PreviewItem = item
				self.PreviewX = x
				self.PreviewY = y
			end
		end)
	end

	self.Icons = {}
	self:Clear()

	surface.SetFont("eternity.labeltiny")
	self.TallOffset = select(2, surface.GetTextSize(inventory:GetGridName()))

	self.Label = self:Add("eternity_label")
	self.Label:SetTall(self.TallOffset)
	self.Label:DockMargin(2, 0, 0, self.IconMargin * 2)
	self.Label:Dock(TOP)
	self.Label:SetFont("eternity.labeltiny")
	self.Label:SetText(inventory:GetGridName())

	local color = ColorAlpha(GAMEMODE:GetConfig("UIColors").Border, 230)

	self:SetSingleSlot(inventory.SingleSlot)
	self:InvalidateParent(true)

	self.InventoryID = inventory.NetworkID

	inventory.GridPanels[self] = true

	for x = 1, inventory.Width do
		local line = self:Add("eternity_panel")

		line:SetWide(self.IconSize)
		line:DockMargin(0, 0, self.IconMargin, 0)
		line:Dock(LEFT)

		for y = 1, inventory.Height do
			local slot = line:Add("eternity_panel")

			slot:SetTall(self.IconSize)
			slot:DockMargin(0, 0, 0, self.IconMargin)
			slot:Dock(TOP)

			slot:SetDrawBorder(color)

			slot.PosX = x
			slot.PosY = y

			table.insert(self.Icons, slot)
		end
	end

	for id, origin in pairs(inventory.Items) do
		local item = GAMEMODE:GetItem(id)
		local x, y = self:GetOrigin(origin.x, origin.y)

		local panel = self:Add("eternity_itemicon")

		panel:SetPos(x, y)
		panel:SetSize(self:GetIconSize(item))

		panel:SetReadOnly(readonly)
		panel:Setup(item)
	end

	self:UpdateSize(inventory.Width, inventory.Height)
end

function PANEL:GetLabelSize()
	local margin = select(4, self.Label:GetDockMargin())

	return self.Label:GetTall() + margin
end

function PANEL:UpdateSize(w, h)
	w = (w * self.IconSize) + (w * self.IconMargin) - self.IconMargin
	h = self:GetLabelSize() + (h * self.IconSize) + (h * self.IconMargin) - self.IconMargin

	self:SetSize(w, h)
end

function PANEL:GetIconSize(item)
	local w, h = item:GetSize()

	if self._SingleSlot then
		w, h = 1, 1
	end

	w = (w * self.IconSize) + (w * self.IconMargin) - self.IconMargin
	h = (h * self.IconSize) + (h * self.IconMargin) - self.IconMargin

	return w, h
end

function PANEL:Think()
	local colors = GAMEMODE:GetConfig("UIColors")

	if not self.Icons then
		return
	end

	for _, v in pairs(self.Icons) do
		local color = colors.FillMedium

		if dragndrop.IsDragging() and self.PreviewItem then
			local x = self.PreviewX
			local y = self.PreviewY
			local item = self.PreviewItem

			local w, h = item:GetSize()

			if self._SingleSlot then
				w, h = 0, 0
			else
				w, h = w - 1, h - 1
			end

			if LocalPlayer():CanMoveItem(item, item:GetInventory(), self:GetInventory()) and math.InRange(v.PosX, x, x + w) and math.InRange(v.PosY, y, y + h) then
				color = colors.Primary
			end
		end

		v:SetDrawColor(ColorAlpha(color, 230))
	end

	self.PreviewItem = nil
end

vgui.Register("eternity_itemgrid", PANEL, "eternity_panel")