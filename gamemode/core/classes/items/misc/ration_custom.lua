ITEM = class.Create("base_item")

ITEM.Name 				= "Empty ration packaging"
ITEM.Description 		= "An empty ration package, you could fit whatever you wanted in here."

ITEM.Model 				= Model("models/weapons/w_package.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.Inventories 		= {
	["Main"] = {2, 2}
}

ITEM.Sealed 			= false

function ITEM:GetName()
	if self.Sealed then
		return class.Get("ration").Name
	end

	return self.Name
end

function ITEM:GetDescription()
	if self.Sealed then
		return class.Get("ration").Description
	end

	return self.Description
end

function ITEM:CanInteractWithChild(ply)
	return not self.Sealed
end

function ITEM:GetOptions(ply)
	local tab = {}

	if self.Sealed then
		table.insert(tab, {
			Name = "Open",
			Callback = function()
				ply:SendChat("NOTICE", "You rip open the ration, revealing its contents.")

				self:GetInventory():RemoveItem(self)

				for _, v in pairs(self:GetChildInventory("Main"):GetItems()) do
					if not v:OnWorldUse(ply) then
						v:SetWorldItem(self:GetItemDropLocation(), Angle())
					end
				end

				GAMEMODE:DeleteItem(self)
			end
		})
	else
		if #self:GetChildInventory("Main"):GetItems() < 1 then
			table.insert(tab, {
				Name = "Pack",
				Callback = function()
					ply:SendChat("NOTICE", "You fold the packaging up tightly.")

					GAMEMODE:DeleteItem(self)

					ply:GiveItem("ration_packed")
				end
			})
		end

		table.insert(tab, {
			Name = "Seal",
			Callback = function()
				if #self:GetChildInventory("Main"):GetItems() < 1 then
					ply:SendChat("ERROR", "This package is empty!")

					return
				end

				ply:SendChat("NOTICE", "You seal the package and its contents.")

				self.Sealed = true
			end
		})
	end

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

return ITEM