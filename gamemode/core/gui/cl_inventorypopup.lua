local PANEL = {}
DEFINE_BASECLASS("eternity_basepanel")

function PANEL:Init()
	self:DockPadding(5, 5, 5, 5)

	self:SetAllowEscape(true)
	self:SetDrawTopBar(true)
	self:SetDraggable(true)

	self:MakePopup()
	self:Center()
end

function PANEL:Setup(inventories)
	local width = 0

	for _, v in pairs(inventories) do
		local inventory = self:Add("eternity_itemgrid")

		inventory:DockMargin(0, 0, 0, GAMEMODE:GetConfig("ItemIconMargin") * 2)
		inventory:Dock(TOP)

		inventory:Setup(GAMEMODE:GetInventory(v))

		width = math.max(width, inventory:GetWide())
	end

	self:SetWide(width + 10)
	self:SizeToChildren(false, true)

	self:SetPos(gui.MouseX() + 15, gui.MouseY() + 5)
end

vgui.Register("eternity_inventorypopup", PANEL, "eternity_basepanel")

GM:RegisterGUI("InventoryPopup", function(title, inventories)
	local patdown = IsValid(GAMEMODE:GetGUI("Patdown"))

	if not IsValid(GAMEMODE:GetGUI("PlayerMenu")) and not patdown then
		GAMEMODE:OpenGUI("PlayerMenu")
	end

	for _, inv in pairs(inventories) do
		inv = GAMEMODE:GetInventory(inv)

		for panel in pairs(inv.GridPanels) do
			if not IsValid(panel) then
				continue
			end

			panel = panel:GetParent()

			if panel:GetName() == "eternity_inventorypopup" then
				panel:MoveToFront()
				panel:SetPos(gui.MouseX() + 15, gui.MouseY() + 5)

				return
			end
		end
	end

	local instance = vgui.Create("eternity_inventorypopup")

	instance:SetTitle("Inventory: " .. title)
	instance:Setup(inventories)

	return instance
end)