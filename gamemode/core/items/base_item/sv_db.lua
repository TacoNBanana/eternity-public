function ITEM:SaveData()
	dbal.Update("eternity", "$items", {CustomData = pon.encode(self.Overrides)}, "id = ?", self.NetworkID, stub)
end

function ITEM:SaveLocation()
	local inventory = self:GetInventory()
	local item = self:GetWorldItem()

	if inventory then
		local data = {
			StoreType = inventory.GridType,
			StoreID = inventory.GridID,
			StoreName = inventory.GridName,
			StorePos = pon.encode(inventory.Items[self.NetworkID])
		}

		if inventory.GridType == STORE_ITEM then
			data.ParentID = inventory.GridID
		else
			data.ParentID = NULL
		end

		dbal.Update("eternity", "$items", data, "id = ?", self.NetworkID, stub)
	elseif IsValid(item) then
		local vec = item:GetPos()
		local ang = item:GetAngles()

		local data = {
			StoreType = STORE_WORLD,
			StoreID = 0,
			StoreName = game.GetMap(),
			StorePos = pon.encode({
				vx = math.Round(vec.x, 2),
				vy = math.Round(vec.y, 2),
				vz = math.Round(vec.z, 2),
				ap = math.Round(ang.p, 2),
				ay = math.Round(ang.y, 2),
				ar = math.Round(ang.r, 2)
			})
		}

		dbal.Update("eternity", "$items", data, "id = ?", self.NetworkID, stub)
	end
end