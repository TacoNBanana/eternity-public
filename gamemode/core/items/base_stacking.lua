ITEM = class.Create("base_item")

ITEM.SingularName 		= ""
ITEM.PluralName 		= ""

ITEM.Model 				= Model("models/props_lab/box01a.mdl")

ITEM.Stack 				= 0
ITEM.MaxStack 			= 0

function ITEM:GetName()
	if #self.SingularName > 0 and self.Stack == 1 then
		return string.format(self.SingularName, self.Stack)
	elseif #self.PluralName > 0 then
		return string.format(self.PluralName, self.Stack)
	end

	return string.format("%s x%s", self.Name, self.Stack)
end

function ITEM:AdjustAmount(amt)
	local old = self.Stack

	self.Stack = math.Clamp(self.Stack + amt, 0, (self.MaxStack > 0) and self.MaxStack or math.huge)

	if SERVER and self.Stack == 0 then
		GAMEMODE:DeleteItem(self)
	end

	return math.abs(old - self.Stack)
end

function ITEM:GetIconText()
	return "<font=eternity.labeltiny>x" .. self.Stack
end

function ITEM:GetOptions(ply)
	local tab = {}

	if self.Stack > 1 then
		table.insert(tab, {
			Name = "Split",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "number", "Split stack", {
					Default = 1
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("number", {}, val) then
					return
				end

				local amt = self:AdjustAmount(-math.Clamp(tonumber(val), 1, self.Stack - 1))

				if amt <= 0 then
					return
				end

				local item = GAMEMODE:CreateItem(self:GetClassName())

				item:AdjustAmount(amt)

				if not item:OnWorldUse(ply) then
					item:SetWorldItem(ply:GetItemDropLocation(), Angle())
				end

				GAMEMODE:WriteLog("item_split", {
					Ply = GAMEMODE:LogPlayer(ply),
					Char = GAMEMODE:LogCharacter(ply),
					Item = GAMEMODE:LogItem(self),
					New = GAMEMODE:LogItem(item)
				})
			end
		})
	end

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

if SERVER then
	function ITEM:ProcessArguments(args)
		args = tonumber(args) or 1
		args = math.Clamp(args, 1, (self.MaxStack > 0) and self.MaxStack or math.huge)

		self:AdjustAmount(args)
	end
end

function ITEM:OnUse(ply, item)
	if item:GetClassName() != self:GetClassName() then
		return
	end

	local taken = self:AdjustAmount(item.Stack)

	if SERVER and taken == item.Stack then
		GAMEMODE:WriteLog("item_merge", {
			Ply = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(ply),
			Item = GAMEMODE:LogItem(self),
			From = GAMEMODE:LogItem(item)
		})
	end

	item:AdjustAmount(-taken)
end

return ITEM