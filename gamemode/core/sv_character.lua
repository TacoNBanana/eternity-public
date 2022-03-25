local meta = FindMetaTable("Player")

function meta:CreateNewCharacter(data)
	data.SteamID = self:SteamID()

	local id = dbal.Insert("eternity", "$chars", data).LastInsert
	local characters = self:Characters()

	characters[id] = {RPName = data.RPName or "", Species = data.Species}

	self:SetCharacters(characters)

	return id
end

function meta:UnloadCharacter()
	self:UnloadInventory()

	hook.Run("UnloadCharacter", self)
end

function meta:LoadCharacter(id)
	local old

	if self:HasCharacter() then
		old = GAMEMODE:LogCharacter(self)

		self:UnloadCharacter()
	end

	local data = dbal.Query("eternity", "SELECT * FROM $chars WHERE id = ?", id)[1]

	self:SetCharID(id)

	self.SuppressCharacterChanges = true

	for k, v in pairs(data) do
		local accessor = GAMEMODE.CharacterAccessors[k]

		if accessor then
			if accessor.Storetype == "BOOLEAN" then
				v = tobool(v)
			end

			self["Set" .. k](self, v)
		end
	end

	self.SuppressCharacterChanges = false

	self:LoadInventory()
	self:DoSpawn(true)

	if not self:InitialSetup() then
		self:SetInitialSetup(true)

		hook.Run("InitialCharacterSetup", self)

		GAMEMODE:WriteLog("character_created", {
			Ply = GAMEMODE:LogPlayer(self),
			Species = self:Species(),
			Char = GAMEMODE:LogCharacter(self)
		})
	end

	hook.Run("PostLoadCharacter", self)

	GAMEMODE:WriteLog("character_loaded", {
		Ply = GAMEMODE:LogPlayer(self),
		Char = GAMEMODE:LogCharacter(self),
		From = old
	})
end

function meta:NoCharacter()
	self:SetCharID(-1)

	self.SuppressCharacterChanges = true

	for k in pairs(GAMEMODE.CharacterAccessors) do
		self["Set" .. k](self, nil)
	end

	self.SuppressCharacterChanges = false

	self:DoSpawn()
	self:OpenGUI("CharSelect")
end

function meta:DeleteCharacter(id)
	dbal.Update("eternity", "$chars", {Deleted = 1}, "id = ?", id)
	dbal.Query("eternity", "DELETE FROM $items WHERE StoreType = ? AND StoreID = ?", STORE_PLAYER, id)

	GAMEMODE:WriteLog("character_deleted", {
		Ply = GAMEMODE:LogPlayer(self),
		CharID = id
	})

	local characters = self:Characters()

	characters[id] = nil

	self:SetCharacters(characters)

	if self:CharID() == id then
		self:NoCharacter()
	end
end

netstream.Hook("SetDescription", function(ply, data)
	if not GAMEMODE:CheckInput("string", {
		Max = 2048
	}, data.Description) then
		return
	end

	GAMEMODE:WriteLog("character_setdesc", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Old = ply:Description(),
		New = data.Description
	})

	ply:SetDescription(data.Description)
end)

netstream.Hook("SetName", function(ply, data)
	if not GAMEMODE:CheckInput("string", {
		Max = 30
	}, data.Name) then
		return
	end

	local min = GAMEMODE:GetConfig("MinNameLength")

	if #data.Name < min then
		ply:SendChat("ERROR", string.format("Your name has to be longer than %s characters", min))

		return
	end

	if not GAMEMODE:CheckNameValidity(data.Name) then
		ply:SendChat("ERROR", "Your name contains invalid characters")

		return
	end

	GAMEMODE:WriteLog("character_setname", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Old = ply:RPName(),
		New = data.Name
	})

	ply:SetRPName(data.Name)
end)

hook.Add("PlayerDisconnected", "player.PlayerDisconnected", function(ply)
	ply:UnloadCharacter()
end)

hook.Add("PlayerRPNameChanged", "player.PlayerRPNameChanged", function(ply, old, new)
	if ply.SuppressCharacterChanges then
		return
	end

	local characters = ply:Characters()

	characters[ply:CharID()].RPName = new

	ply:SetCharacters(characters)
end)