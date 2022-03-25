local PANEL = {}
DEFINE_BASECLASS("eternity_basepanel")

function PANEL:Init()
	self:SetSize(800, 500)
	self:DockPadding(5, 5, 5, 5)

	self:SetAllowEscape(true)
	self:SetDrawTopBar(true)

	self:MakePopup()
	self:Center()
end

local function AddSlots(ply, parent, slots)
	for _, v in pairs(slots) do
		local inv = parent:Add("eternity_itemgrid")

		inv:DockMargin(0, 0, 0, GAMEMODE:GetConfig("ItemIconMargin") * 2)
		inv:Dock(TOP)

		inv:Setup(ply:GetInventory(v))
	end
end

function PANEL:Setup(ply)
	self.Ply = ply
	self.Pos = ply:GetPos()

	self:SetTitle(string.format("Patdown: %s", ply:RPName()))

	self.Inventory = self:Add("eternity_itemgrid")
	self.Inventory:SetPos(5, 29)
	self.Inventory:Setup(ply:GetInventory("Main"))

	self.Equipment = self:Add("eternity_panel")

	self.Equipment:Dock(RIGHT)
	self.Equipment:SetWide(GAMEMODE:GetConfig("ItemIconSize"))

	AddSlots(ply, self.Equipment, ply:GetActiveSpecies().EquipmentSlots)

	self.Preview = self:Add("eternity_liveview")
	self.Preview:Dock(RIGHT)
	self.Preview:SetWide(200)
	self.Preview:SetEntity(ply)
	self.Preview:SetFOV(25)

	self.Weapons = self:Add("eternity_panel")
	self.Weapons:Dock(RIGHT)
	self.Weapons:SetWide(GAMEMODE:GetConfig("ItemIconSize"))

	AddSlots(ply, self.Weapons, ply:GetActiveSpecies().WeaponSlots)
end

function PANEL:Think()
	BaseClass.Think(self)

	if not IsValid(self.Ply) or (not LocalPlayer():IsAdmin() and self.Ply:GetPos():Distance(self.Pos) > 2) then
		for _, v in pairs(GAMEMODE:GetGUI("InventoryPopup")) do
			v:Remove()
		end

		self:Remove()
	end
end

vgui.Register("eternity_patdown", PANEL, "eternity_basepanel")

GM:RegisterGUI("Patdown", function(ply)
	local instance = vgui.Create("eternity_patdown")

	instance:Setup(ply)

	return instance
end, true)