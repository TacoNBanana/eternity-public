local meta = FindMetaTable("Entity")

local funcs = {
	["prop_door_rotating"] = function(self)
		return self:GetSaveTable().m_eDoorState != 0
	end,
	["func_door_rotating"] = function(self)
		return self:GetSaveTable().m_toggle_state == 0
	end,
	["func_door"] = function(self)
		return self:GetSaveTable().m_toggle_state == 0
	end
}

function meta:IsDoorOpen()
	return funcs[self:GetClass()](self)
end

function meta:ToggleDoor()
	if self:IsDoorOpen() then
		self:CloseDoor()
	else
		self:OpenDoor()
	end
end

function meta:ToggleDoorLock()
	local ent = self:GetMainDoor()

	ent:SetDoorLock(not ent:DoorLocked())
end

function meta:GetMainDoor()
	local ent = self:GetSaveTable().m_hMaster

	return IsValid(ent) and ent or self
end

function meta:SetDoorLock(locked)
	if self:DoorType() != DOOR_BUYABLE and self:DoorGroup() != "" then
		for _, v in pairs(self:GetGroupedDoors()) do
			v:SetDoorLocked(locked)
		end

		return
	end

	self:SetDoorLocked(locked)
end

function meta:OpenDoor()
	if self:DoorType() != DOOR_BUYABLE and self:DoorGroup() != "" then
		for _, v in pairs(self:GetGroupedDoors()) do
			v:Fire("Open")
		end
	else
		self:Fire("Open")
	end
end

function meta:CloseDoor()
	if self:DoorType() != DOOR_BUYABLE and self:DoorGroup() != "" then
		for _, v in pairs(self:GetGroupedDoors()) do
			v:Fire("Close")
		end
	else
		self:Fire("Close")
	end
end

function meta:OwnDoor(ply)
	self:SetDoorOwner(ply:CharID())
end

function meta:UnownDoor()
	self:SetDoorOwner(-1)
	self:SetDoorCustomName("")
end

function meta:PlayDoorSound(lock)
	local snd

	if self:CombineLock() then
		snd = table.Random({
			"buttons/combine_button1.wav",
			"buttons/combine_button2.wav",
			"buttons/combine_button3.wav",
			"buttons/combine_button5.wav",
			"buttons/combine_button7.wav"
		})
	else
		snd = lock and "doors/door_locked2.wav" or "doors/door_latch3.wav"
	end

	sound.Play(snd, self:WorldSpaceCenter(), 75, math.random(90, 110), 1)
end

function meta:RamDoor(src)
	self:EmitSound(string.format("physics/wood/wood_crate_break%s.wav", math.random(1, 5)))
	self:SetRamChance(0)
	self:SetDoorLock(false)

	local name = src:GetName()
	local speed = self:GetKeyValues().speed

	src:SetName("doorram" .. src:EntIndex())

	self:SetKeyValue("speed", 500)
	self:SetKeyValue("opendir", "0")

	self:Fire("openawayfrom", "doorram" .. src:EntIndex(), 0.01)

	timer.Simple(0.3, function()
		if IsValid(self) then
			self:SetKeyValue("speed", speed)
		end

		if IsValid(src) then
			src:SetName(name)
		end
	end)
end

function GM:QueueDoorSave()
	timer.Create("DoorSave", 20, 1, function()
		GAMEMODE:SaveDoorData()
	end)
end

function GM:LoadDoorData()
	local tab = GAMEMODE:GetMapData("DoorData")

	for _, v in pairs(self.Doors) do
		if not IsValid(v) then
			continue
		end

		local data = tab[v:MapCreationID()]

		if data then
			v:SetDoorType(data.DoorType)

			if data.DoorGroup then
				v:SetDoorGroup(data.DoorGroup)
			end

			if data.DoorName then
				v:SetDoorName(data.DoorName)
			end

			if data.DoorSubtitle then
				v:SetDoorSubtitle(data.DoorSubtitle)
			end

			if data.CombineLock then
				v:SetCombineLock(true)
				v:SetCombineLockSide(data.CombineLockSide)
				v:SetDoorLocked(data.DoorLocked)
			end
		end
	end

	self.DoorsLoaded = true
end

function GM:SaveDoorData()
	local data = {}
	local groups = {}

	for _, v in pairs(self.Doors) do
		if not IsValid(v) then
			continue
		end

		local id = v:MapCreationID()

		if id == -1 or v:DoorType() == DOOR_NOCONFIG then
			continue
		end

		local tab = {
			DoorType = v:DoorType()
		}

		local name = v:DoorName()

		if name != "" then
			tab.DoorName = name
		end

		if DoorType != DOOR_BUYABLE then
			local sub = v:DoorSubtitle()

			if name != "" and sub != "" then
				tab.DoorSubtitle = sub
			end
		end

		local group = v:DoorGroup()

		if group != "" then
			local count = groups[group]

			groups[group] = isnumber(count) and count + 1 or 1

			tab.DoorGroup = group
		end

		if v:CombineLock() then
			tab.CombineLock = true
			tab.CombineLockSide = v:CombineLockSide()
			tab.DoorLocked = v:DoorLocked()
		end

		data[id] = tab
	end

	-- Filter out door groups with only one member because there's no reason to save them
	for _, v in pairs(data) do
		if v.DoorGroup and groups[v.DoorGroup] == 1 then
			v.DoorGroup = nil
		end
	end

	self:SaveMapData("DoorData", data)
end

hook.Add("InitPostEntity", "doors.InitPostEntity", function()
	coroutine.WrapFunc(function()
		GAMEMODE:LoadDoorData()
	end)
end)

hook.Add("PlayerUse", "doors.PlayerUse", function(ply, ent)
	if IsValid(ent) and ent:IsDoor() and ent:GetClass() != "prop_door_rotating" then
		return false
	end
end)

hook.Add("KeyPress", "doors.KeyPress", function(ply, key)
	if key == IN_USE then
		local ent = hook.Run("FindUseEntity", ply)

		if not IsValid(ent) or not ent:IsDoor() then
			return
		end

		if ent:GetClass() == "prop_door_rotating" then
			return
		end

		local door = ent:DoorType()

		if door == DOOR_PUBLIC or door == DOOR_BUYABLE then
			ent:ToggleDoor()
		elseif door == DOOR_COMBINE then
			if ply:HasPermission(PERMISSION_DOORS_BASIC) and not ent:DoorLocked() then
				ent:ToggleDoor()
			else
				ent.NextSound = ent.NextSound or CurTime()

				if ent.NextSound <= CurTime() then
					ent:EmitSound("buttons/combine_button_locked.wav")
					ent.NextSound = CurTime() + 1
				end
			end
		end
	end
end)

hook.Add("UnloadCharacter", "doors.UnloadCharacter", function(ply)
	for _, v in pairs(ply:GetOwnedDoors()) do
		v:UnownDoor()
	end
end)

hook.Add("AcceptInput", "doors.AcceptInput", function(ent, name, _, source)
	if not ent:IsDoor() or not IsValid(source) then
		return
	end

	if name == "Lock" or name == "Unlock" then
		ent:SetDoorLocked(name == "Lock")

		return true
	end
end)

hook.Add("EntityDoorLockedChanged", "doors.EntityDoorLockedChanged", function(ent, old, new)
	if not ent:IsDoor() then
		return
	end

	if old == new then
		return
	end

	ent:Fire(new and "Lock" or "Unlock")

	if ent:DoorType() != DOOR_IGNORED then
		ent:PlayDoorSound(new)
	end

	if ent:CombineLock() and GAMEMODE.DoorsLoaded then
		GAMEMODE:QueueDoorSave()
	end
end)

hook.Add("EntityCombineLockChanged", "doors.EntityCombineLockChanged", function(ent, old, new)
	if not ent:IsDoor() or not GAMEMODE.DoorsLoaded then
		return
	end

	if old == new then
		return
	end

	GAMEMODE:QueueDoorSave()
end)