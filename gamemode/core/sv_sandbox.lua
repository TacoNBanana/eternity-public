local meta = FindMetaTable("Player")

net.Receive("ArmDupe", function(len, ply)
	Msg(Format("ArmDupe called by %s!\n", ply:Name()))
end)

function GM:PlayerGiveSWEP(ply, class, tab)
	if ply:IsSuperAdmin() then
		GAMEMODE:WriteLog("sandbox_spawn_weapon", {
			Ply = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(ply),
			Class = class
		})

		return true
	end

	return false
end

function GM:PlayerSpawnSWEP(ply, class, tab)
	if ply:IsSuperAdmin() then
		GAMEMODE:WriteLog("sandbox_spawn_weapon", {
			Ply = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(ply),
			Class = class
		})

		return true
	end

	return false
end

function GM:CheckBlacklist(index, str)
	local blacklist = GAMEMODE:GetConfig("SandboxBlacklist")[index]

	for _, v in pairs(blacklist) do
		if string.find(str, v, 1, true) then
			return false
		end
	end

	return true
end

function meta:CanSpawn()
	if not self:Alive() then
		return false
	end

	return true
end

function meta:CanSpawnProp(index, mdl)
	if not self:CanSpawn() then
		return false
	end

	if not self:IsAdmin() then
		mdl = string.gsub(string.lower(mdl), "\\", "/")

		if self:ToolTrust() == TOOLTRUST_BANNED then
			return false
		end

		if not GAMEMODE:CheckBlacklist("Props", mdl) then
			return false
		end

		if not self:CheckLimits(index) then
			return false
		end

		if self.NextPropSpawn and self.NextPropSpawn > CurTime() then
			return false
		end
	end

	return true
end

function GM:PlayerSpawnProp(ply, mdl)
	return ply:CanSpawnProp("props", mdl)
end

function GM:PlayerSpawnRagdoll(ply, mdl)
	return ply:CanSpawnProp("ragdolls", mdl)
end

function GM:PlayerSpawnEffect(ply, mdl)
	return ply:CanSpawnProp("effects", mdl)
end

hook.Add("PlayerSpawnedProp", "sandbox.PlayerSpawnedProp", function(ply, mdl, ent)
	if not ply:IsAdmin() then
		local trust = ply:ToolTrust()

		if ent:BoundingRadius() > GAMEMODE:GetConfig("PropRadius")[trust] then
			ent:Remove()

			return
		end

		if trust != TOOLTRUST_ADVANCED then
			ply.NextPropSpawn = CurTime() + 1

			ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end
	end

	ent:SetSteamID(ply:SteamID())
	ent:SetPlayerName(ply:RPName())

	GAMEMODE:WriteLog("sandbox_spawn_generic", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Mdl = mdl
	})
end)

hook.Add("PlayerSpawnedRagdoll", "sandbox.PlayerSpawnedRagdoll", function(ply, mdl, ent)
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)

	if not ply:IsAdmin() and ply:ToolTrust() != TOOLTRUST_ADVANCED then
		ply.NextPropSpawn = CurTime() + 1
	end

	ent:SetSteamID(ply:SteamID())
	ent:SetPlayerName(ply:RPName())

	GAMEMODE:WriteLog("sandbox_spawn_generic", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Mdl = mdl
	})
end)

hook.Add("PlayerSpawnedEffect", "sandbox.PlayerSpawnedEffect", function(ply, mdl, ent)
	if not ply:IsAdmin() and ply:ToolTrust() != TOOLTRUST_ADVANCED then
		ply.NextPropSpawn = CurTime() + 1
	end

	ent:SetSteamID(ply:SteamID())
	ent:SetPlayerName(ply:RPName())

	GAMEMODE:WriteLog("sandbox_spawn_generic", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Mdl = mdl
	})
end)

function GM:PlayerSpawnSENT(ply, class)
	if not ply:IsAdmin() then
		if not ply:HasPermission(PERMISSION_VEHICLES_AIR) then
			return false
		end

		if not table.HasValue(GAMEMODE:GetConfig("PermissionWhitelist")[PERMISSION_VEHICLES_AIR], class) then
			return false
		end
	end

	if not ply:CanSpawn() then
		return false
	end

	if not GAMEMODE:CheckBlacklist("Entities", class) then
		return false
	end

	GAMEMODE:WriteLog("sandbox_spawn_entity", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Class = class
	})

	return true
end

function GM:PlayerSpawnVehicle(ply, model, name, tab)
	if not ply:IsAdmin() then
		if not ply:HasPermission(PERMISSION_VEHICLES_GROUND) then
			return false
		end

		if not table.HasValue(GAMEMODE:GetConfig("PermissionWhitelist")[PERMISSION_VEHICLES_GROUND], name) then
			return false
		end
	end

	if not ply:CanSpawn() then
		return false
	end

	GAMEMODE:WriteLog("sandbox_spawn_vehicle", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Class = name
	})

	return true
end

function GM:PlayerSpawnNPC(ply, class, weapon)
	if not ply:IsAdmin() then
		return false
	end

	if not ply:CanSpawn() then
		return false
	end

	GAMEMODE:WriteLog("sandbox_spawn_npc", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Class = class
	})

	return true
end

function GM:CanPlayerUnfreeze(ply, ent, phys)
	if ent:IsProtectedEntity() or (ent.CanPhys and not ent:CanPhys(ply)) then
		return false
	end

	return self.BaseClass:CanPlayerUnfreeze(ply, ent, phys)
end

hook.Add("PlayerInitialSpawn", "sandbox.PlayerInitialSpawn", function(ply)
	timer.Remove(string.format("%s.cleanup", ply:SteamID()))
end)

hook.Add("PlayerDisconnected", "sandbox.PlayerDisconnected", function(ply)
	local tab = undo.GetTable()[ply:UniqueID()]
	local uid = ply:UniqueID()

	if not tab then
		return
	end

	local steamid = ply:SteamID()

	timer.Create(string.format("%s.cleanup", steamid), GAMEMODE:GetConfig("CleanupTimer"), 1, function()
		for _, v in pairs(undo.GetTable()[uid]) do
			for _, ent in pairs(v.Entities) do
				if not IsValid(ent) or ent:PermaProp() then
					continue
				end

				ent:Remove()
			end
		end
	end)
end)

function GM:SavePermaProps()
	local str = ""

	local function save(ent)
		local data = {}
		local mdl = ent

		data.Class = ent:GetClass()

		if data.Class == "prop_effect" then
			mdl = ent.AttachedEntity
		end

		data.Model = mdl:GetModel()
		data.Skin = mdl:GetSkin()

		data.Pos = ent:GetPos()
		data.Ang = ent:GetAngles()

		data.CollisionGroup = ent:GetCollisionGroup()

		data.RenderMode = mdl:GetRenderMode()
		data.RenderFX = mdl:GetRenderFX()

		data.Color = mdl:GetColor()

		local mat = mdl:GetMaterial()

		if #mat > 0 then
			data.Material = mat
		else
			local tab = {}

			for i = 0, 31 do
				local submat = mdl:GetSubMaterial(i)

				if #submat > 0 then
					tab[i] = submat
				end
			end

			if table.Count(tab) > 0 then
				data.SubMaterials = tab
			end
		end

		data.SteamID = ent:SteamID()
		data.PlayerName = ent:PlayerName()
		data.Description = ent:Description()

		str = string.format("%s%s\n", str, pon.encode(data))
	end

	for _, v in pairs(ents.FindByClass("prop_physics")) do
		if not v:PermaProp() then
			continue
		end

		save(v)
	end

	for _, v in pairs(ents.FindByClass("prop_effect")) do
		if not v:PermaProp() then
			continue
		end

		save(v)
	end

	file.Write(string.format("eternity/permaprops/%s.txt", game.GetMap()), str)
end

function GM:LoadPermaProps()
	local str = file.Read(string.format("eternity/permaprops/%s.txt", game.GetMap()), "DATA")

	if not str then
		return
	end

	for _, v in pairs(string.Explode("\n", str)) do
		if #v < 1 then
			continue
		end

		local data = pon.decode(v)
		local ent = ents.Create(data.Class)

		ent:SetModel(data.Model)
		ent:SetSkin(data.Skin)

		ent:SetPos(data.Pos)
		ent:SetAngles(data.Ang)

		ent:Spawn()
		ent:Activate()

		local mdl = data.Class == "prop_effect" and ent.AttachedEntity or ent

		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:Sleep()
		end

		ent:SetCollisionGroup(data.CollisionGroup)

		mdl:SetRenderMode(data.RenderMode)
		mdl:SetRenderFX(data.RenderFX)

		mdl:SetColor(data.Color)

		if data.Material then
			mdl:SetMaterial(data.Material)
		elseif data.SubMaterials then
			for index, mat in pairs(data.SubMaterials) do
				mdl:SetSubMaterial(index, mat)
			end
		end

		ent:SetSteamID(data.SteamID)
		ent:SetPlayerName(data.PlayerName or "N/A")
		ent:SetDescription(data.Description)

		ent:SetPermaProp(true)
	end
end

hook.Add("InitPostEntity", "sandbox.InitPostEntity", function()
	GAMEMODE:LoadPermaProps()
end)