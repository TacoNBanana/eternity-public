function ITEM:GetWorldItem()
	return Entity(self.EntityID) or NULL
end

if SERVER then
	function ITEM:SetWorldItem(pos, ang, loaded)
		local item = self:GetWorldItem()

		if not IsValid(item) then
			self:SetNetworked(true)

			item = ents.Create("ent_item")

			item:SetModel(self.Model)
			item:SetSkin(self.Skin)

			for k, v in pairs(self.Bodygroups) do
				if isnumber(k) then
					item:SetBodygroup(k, v)
				end
			end

			local mins, maxs = item:OBBMins(), item:OBBMaxs()

			item:SetRenderMode(RENDERMODE_TRANSALPHA)
			item:SetModelScale(self.Scale)

			item:Spawn()
			item:Activate()

			if #self.Material > 0 then
				item:SetMaterial(self.Material)
			end

			item:SetColor(self.Color)

			local phys = item:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetMass(phys:GetMass() * self.Scale)
			end

			item:SetCollisionBounds(mins, maxs)
		end

		item:SetPos(pos)
		item:SetAngles(ang)
		item:SetItemID(self.NetworkID)

		self.EntityID = item:EntIndex()

		if loaded then
			local phys = item:GetPhysicsObject()
			if IsValid(phys) then
				item:GetPhysicsObject():EnableMotion(false)
			end
		else
			self:SaveLocation()
		end

		return item
	end

	function ITEM:RemoveWorldItem()
		local item = self:GetWorldItem()

		if IsValid(item) then
			item:SetItemID(-1)
			item:Remove()
		end

		self.EntityID = -1
	end

	function ITEM:OnWorldUse(ply)
		local inventory = ply:GetInventory("Main")

		local ok, flipped, x, y = inventory:FindItemFit(self)

		if not ok then
			return false
		end

		if flipped then
			self.Flipped = not self.Flipped
		end

		self:RemoveWorldItem()

		inventory:AddItem(self, x, y)

		GAMEMODE:WriteLog("item_pickup", {
			Ply = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(ply),
			Item = GAMEMODE:LogItem(self)
		})

		return true
	end
end