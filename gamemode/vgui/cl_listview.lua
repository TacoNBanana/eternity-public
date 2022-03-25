local PANEL = {}

function PANEL:Init()
	self.pnlCanvas:Remove()

	self.pnlCanvas = self:Add("eternity_panel")

	self.VBar:Remove()

	self.VBar = self:Add("eternity_vscrollbar")
	self.VBar:SetZPos(20)
end

function PANEL:AddColumn(name, pos)
	local column = nil

	if self.m_bSortable then
		column = self:Add("eternity_listview_column")
	else
		column = self:Add("eternity_listview_column_plain")
	end

	column:SetName(name)
	column:SetZPos(10)

	if pos then
		table.insert(self.Columns, pos, column)

		for i = 1, #self.Columns do
			self.Columns[i]:SetColumnID(i)
		end
	else
		column:SetColumnID(table.insert(self.Columns, column))
	end

	self:InvalidateLayout()

	return column
end

function PANEL:AddLine(...)
	self:SetDirty(true)
	self:InvalidateLayout()

	local line = self.pnlCanvas:Add("eternity_listview_line")
	local id = table.insert(self.Lines, line)

	line:SetListView(self)
	line:SetID(id)

	for k, v in pairs(self.Columns) do
		line:SetColumnText(k, "")
	end

	for k, v in pairs({...}) do
		line:SetColumnText(k, v)
	end

	-- Make appear at the bottom of the sorted list
	local sort = table.insert(self.Sorted, line)

	if sort % 2 == 1 then
		line:SetAltLine(true)
	end

	return line
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	surface.SetDrawColor(colors.FillDark)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(colors.Border, 100))
	surface.DrawOutlinedRect(0, 0, w, h)
end

derma.DefineControl("eternity_listview", "", PANEL, "DListView")

PANEL = {}

function PANEL:Init()
	self.Header:Remove()

	self.Header = self:Add("eternity_button")
	self.Header.DoClick = function() self:DoClick() end
	self.Header.DoRightClick = function() self:DoRightClick() end
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	surface.SetDrawColor(colors.FillDark)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(colors.Border, 100))
	surface.DrawOutlinedRect(0, 0, w, h)
end

derma.DefineControl("eternity_listview_column", "", table.Copy(PANEL), "DListView_Column")

function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

derma.DefineControl("eternity_listview_column_plain", "", PANEL, "DListView_Column")

PANEL = {}

function PANEL:SetColumnText(i, str)
	local column = self.Columns[i]

	if ispanel(str) then
		if IsValid(column) then
			column:Remove()
		end

		str:SetParent(self)

		self.Columns[i] = str
		self.Columns[i].Value = str

		return
	end

	if not IsValid(column) then
		self.Columns[i] = self:Add("eternity_label")

		column = self.Columns[i]

		column:SetMouseInputEnabled(false)
		column:SetTextInset(5, 0)
	end

	column:SetText(str)
	column.Value = str

	return column
end

function PANEL:Paint(w, h)
	local colors = GAMEMODE:GetConfig("UIColors")

	if self:IsSelected() then
		surface.SetDrawColor(colors.Primary)
	elseif self.Hovered then
		surface.SetDrawColor(colors.FillLight)
	elseif self.m_bAlt then
		surface.SetDrawColor(colors.FillMedium)
	end

	surface.DrawRect(0, 0, w, h)
end

derma.DefineControl("eternity_listview_line", "", PANEL, "DListView_Line")

PANEL = {}

