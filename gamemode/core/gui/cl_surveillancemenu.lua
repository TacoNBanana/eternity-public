local PANEL = {}

function PANEL:Init()
	self:SetSize(300, 400)
	self:DockPadding(10, 10, 10, 10)

	self:SetAllowEscape(true)

	self:SetDrawTopBar(true)
	self:SetTitle("Surveillance")

	local bottom1 = self:Add("eternity_panel")

	bottom1:DockMargin(0, 5, 0, 0)
	bottom1:Dock(BOTTOM)
	bottom1:SetTall(22)

	self.Refresh = bottom1:Add("eternity_button")
	self.Refresh:Dock(LEFT)
	self.Refresh:SetWide(100)
	self.Refresh:SetText("Refresh")

	self.Refresh.DoClick = function()
		self:Populate()
	end

	self.View = bottom1:Add("eternity_button")
	self.View:Dock(RIGHT)
	self.View:SetWide(100)
	self.View:SetText("View")

	self.View.DoClick = function()
		netstream.Send("ActivateSurveillance", {
			Ent = self.Target
		})

		self:Remove()
	end

	self.View:SetDisabled(true)

	self.List = self:Add("eternity_listview")
	self.List:Dock(FILL)

	self.List:SetMultiSelect(false)

	self.List:AddColumn("Type"):SetFixedWidth(75)
	self.List:AddColumn("Identifier")

	self.List.OnRowSelected = function(pnl, index, row)
		self.Target = row.Ent

		self.View:SetDisabled(false)
	end

	self.List.DoDoubleClick = function(pnl, index, row)
		self.Target = row.Ent

		self.View:SetDisabled(false)
		self.View:DoClick()
	end

	self:MakePopup()
	self:Center()

	self:Populate()
end

function PANEL:Populate()
	self.View:SetDisabled(true)
	self.List:Clear()

	local units = {}
	local cameras = {}
	local npcs = {}

	for _, v in pairs(player.GetAll()) do
		if not v:IsCameraTarget(LocalPlayer()) then
			continue
		end

		units[v:CameraName()] = v
	end

	for _, v in pairs(ents.FindByClass("ent_camera")) do
		if not v:IsReady() then
			continue
		end

		cameras[v:CameraName()] = v
	end

	for _, v in pairs(ents.FindByClass("npc_combine_camera")) do
		npcs[v:CameraName()] = v
	end

	for k, v in SortedPairs(units) do
		self.List:AddLine("Unit", k).Ent = v
	end

	for k, v in SortedPairs(cameras) do
		self.List:AddLine("Passive", k).Ent = v
	end

	for k, v in SortedPairs(npcs) do
		self.List:AddLine("Active", k).Ent = v
	end
end

vgui.Register("eternity_surveillancemenu", PANEL, "eternity_basepanel")

GM:RegisterGUI("SurveillanceMenu", function()
	return vgui.Create("eternity_surveillancemenu")
end, true)