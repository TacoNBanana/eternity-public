local pmeta = FindMetaTable("Player")
local emeta = FindMetaTable("Entity")

GM.Doors = GM.Doors or {}

local doortypes = {
	["prop_door_rotating"] = true,
	["func_door_rotating"] = true,
	["func_door"] = true
}

accessor.Entity("DoorType", "Entity", DOOR_NOCONFIG)
accessor.Entity("DoorGroup", "Entity", "")

accessor.Entity("DoorName", "Entity", "")
accessor.Entity("DoorSubtitle", "Entity", "")

accessor.Entity("RamChance", "Entity", 0)

accessor.Entity("DoorOwner", "Entity", -1)
accessor.Entity("DoorCustomName", "Entity", "")

accessor.Entity("DoorLocked", "Entity", false)
accessor.Entity("CombineLock", "Entity", false)
accessor.Entity("CombineLockSide", "Entity", false)

function emeta:IsDoor()
	return doortypes[self:GetClass()] and true or false
end

function emeta:IsOwned()
	return self:DoorOwner() != -1
end

function emeta:IsOwner(ply)
	return ply:CharID() == self:DoorOwner()
end

function emeta:GetGroupedDoors()
	if self:DoorGroup() == "" then
		return {self}
	end

	local tab = {}

	for _, v in pairs(GAMEMODE.Doors) do
		if v:DoorGroup() == self:DoorGroup() then
			table.insert(tab, v)
		end
	end

	return tab
end

function pmeta:GetOwnedDoors()
	local tab = {}

	if not self:HasCharacter() then
		return tab
	end

	for _, v in pairs(GAMEMODE.Doors) do
		if v:IsOwner(self) then
			table.insert(tab, v)
		end
	end

	return tab
end

function emeta:GetDoorOptions(ply, interact)
	local tab = {}

	if not interact then
		return tab
	end

	if (self:CombineLock() and ply:HasPermission(PERMISSION_DOORS_EXTERNAL)) or (self:DoorType() == DOOR_BUYABLE and self:IsOwner(ply)) or ply:IsAdmin() then
		table.insert(tab, {
			Name = self:DoorLocked() and "Unlock" or "Lock",
			Callback = function()
				self:ToggleDoorLock()
			end
		})
	end

	if self:DoorType() == DOOR_BUYABLE then
		local editable = self:DoorName() != ""
		local canbuy = table.Count(ply:GetOwnedDoors()) <= 0

		if self:IsOwned() and editable then
			if self:IsOwner(ply) then
				table.insert(tab, {
					Name = "Set Name",
					Client = function()
						return GAMEMODE:OpenGUI("Input", "string", "Set Name", {
							Default = self:DoorCustomName(),
							Max = 30
						})
					end,
					Callback = function(val)
						if not GAMEMODE:CheckInput("string", {
							Max = 30
						}, val) then
							return
						end

						self:SetDoorCustomName(val)
					end
				})
			end

			if (self:IsOwner(ply) or ply:IsAdmin()) then
				table.insert(tab, {
					Name = "Sell Door",
					Callback = function(val)
						for _, v in pairs(self:GetGroupedDoors()) do
							v:UnownDoor()

							if v:DoorLocked() then
								v:SetDoorLock(false)
							end
						end
					end
				})
			end
		elseif not self:IsOwned() and canbuy and editable then
			table.insert(tab, {
				Name = "Buy Door",
				Callback = function(val)
					for _, v in pairs(self:GetGroupedDoors()) do
						v:OwnDoor(ply)
					end
				end
			})
		end
	end

	if self:CombineLock() and ply:HasPermission(PERMISSION_MAINTENANCE, true) then
		table.insert(tab, {
			Name = "Remove Lock",
			Callback = function(val)
				if self:DoorLocked() then
					self:SetDoorLock(false)
				end

				self:SetCombineLock(false)

				ply:GiveItem("combinelock")
			end
		})
	end

	if ply:IsInEditMode() then
		table.insert(tab, {
			Name = "Set Title",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Title", {
					Default = self:DoorName(),
					Max = 30
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = 30
				}, val) then
					return
				end

				self:SetDoorName(val)

				GAMEMODE:QueueDoorSave()
			end
		})

		table.insert(tab, {
			Name = "Set Subtitle",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Subtitle", {
					Default = self:DoorSubtitle(),
					Max = 30
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = 30
				}, val) then
					return
				end

				self:SetDoorSubtitle(val)

				GAMEMODE:QueueDoorSave()
			end
		})

		table.insert(tab, {
			Name = "Set Group",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Group", {
					Default = self:DoorGroup(),
					Max = 30
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = 30
				}, val) then
					return
				end

				self:SetDoorGroup(val)

				GAMEMODE:QueueDoorSave()
			end
		})

		for k, v in ipairs(DOORS) do
			table.insert(tab, {
				Name = string.format("Mark as %s", v),
				Callback = function()
					self:SetDoorType(k)

					GAMEMODE:QueueDoorSave()
				end
			})
		end
	end

	return tab
end

hook.Add("OnEntityCreated", "doors.OnEntityCreated", function(ent)
	if not IsValid(ent) or not ent:IsDoor() then
		return
	end

	table.insert(GAMEMODE.Doors, ent)

	if SERVER then
		ent:SetDoorLocked(ent:GetSaveTable().m_bLocked)
	end
end)