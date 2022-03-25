local pmeta = FindMetaTable("Player")
local emeta = FindMetaTable("Entity")

module("accessor", package.seeall)

if CLIENT then
	Ready = Ready or false
end

Data = {
	Player = {},
	Entity = {},
	Global = {}
}

Entities = Entities or {}

function Player(name, default, private)
	Data.Player[name] = true

	pmeta[name] = function(ply)
		if ply["_" .. name] == nil then
			return default
		end

		return ply["_" .. name]
	end

	pmeta["Set" .. name] = function(ply, val)
		local old = ply["_" .. name]
		local reset = val == default or val == nil

		if reset then
			ply["_" .. name] = nil

			hook.Run("Player" .. name .. "Changed", ply, old, default)
		else
			ply["_" .. name] = val

			hook.Run("Player" .. name .. "Changed", ply, old, val)
		end

		if SERVER then
			local target

			if private then
				if ply:IsBot() then
					return
				end

				target = ply
			end

			if GetConVar("debug_accessors"):GetBool() then
				log.Default(string.format("[Accessors] Setting %s on %s", name, ply))
			end

			local tab = {
				Ent = ply,
				Key = name
			}

			if not reset then
				tab.Val = val

				AddEntity(ply)
			end

			netstream.Send("SetEntityAccessor", {
				Ent = ply,
				Key = name,
				Val = val
			}, target)
		end
	end
end

function Entity(name, metatable, default)
	local meta = FindMetaTable(metatable)

	if not meta or (meta != emeta and meta.MetaBaseClass != emeta) then
		error("Metatable doesn't exist or isn't derived from Entity")
	end

	Data.Entity[name] = true

	meta[name] = function(ent)
		if ent["_" .. name] == nil then
			return default
		end

		return ent["_" .. name]
	end

	meta["Set" .. name] = function(ent, val)
		local old = ent["_" .. name]
		local reset = val == default or val == nil

		if reset then
			ent["_" .. name] = nil

			hook.Run(metatable .. name .. "Changed", ent, old, default)
		else
			ent["_" .. name] = val

			hook.Run(metatable .. name .. "Changed", ent, old, val)
		end

		if SERVER then
			if GetConVar("debug_accessors"):GetBool() then
				log.Default(string.format("[Accessors] Setting %s on %s", name, ent))
			end

			local tab = {
				Ent = ent,
				Key = name
			}

			if not reset then
				tab.Val = val

				AddEntity(ent)
			end

			netstream.Send("SetEntityAccessor", {
				Ent = ent,
				Key = name,
				Val = val
			}, target)
		end
	end
end

function Global(name, default)
	Data.Global[name] = true

	local gm = GAMEMODE or GM

	gm[name] = function(self)
		if self["_" .. name] == nil then
			return default
		end

		return self["_" .. name]
	end

	gm["Set" .. name] = function(self, val)
		local old = self["_" .. name]
		local reset = val == default or val == nil

		if reset then
			self["_" .. name] = nil

			hook.Run("Global" .. name .. "Changed", old, default)
		else
			self["_" .. name] = val

			hook.Run("Global" .. name .. "Changed", old, val)
		end

		if SERVER then
			if GetConVar("debug_accessors"):GetBool() then
				log.Default(string.format("[Accessors] Setting %s globally", name))
			end

			local tab = {
				Key = name
			}

			if not reset then
				tab.Val = val
			end

			netstream.Send("SetGlobalAccessor", tab)
		end
	end
end

if CLIENT then
	function Request(ent, force)
		if not Ready then
			return
		end

		local index = ent:EntIndex()

		if index == -1 then
			return
		end

		if not Entities[index] and not force then
			return
		end

		netstream.Send("RequestEntityAccessors", {
			Ent = ent
		})
	end

	function RequestAll(force)
		for _, v in pairs(ents.GetAll()) do
			Request(v, force)
		end
	end

	netstream.Hook("SetEntityAccessor", function(data)
		local ent = data.Ent

		if not IsValid(ent) or not Entities[ent:EntIndex()] then
			return
		end

		local func = "Set" .. data.Key

		if not ent[func] then
			return
		end

		ent[func](ent, data.Val)
	end)

	netstream.Hook("SetGlobalAccessor", function(data)
		local func = "Set" .. data.Key

		if not GAMEMODE[func] then
			return
		end

		GAMEMODE[func](GAMEMODE, data.Val)
	end)

	netstream.Hook("SetAccessorList", function(data)
		Entities = data

		for k in pairs(Entities) do
			local ent = ents.GetByIndex(k)

			if IsValid(ent) then
				Request(ent)
			end
		end
	end)

	netstream.Hook("AddAccessorEntity", function(data)
		Entities[data.Index] = true

		local ent = ents.GetByIndex(data.Index)

		if IsValid(ent) then
			Request(ent)
		end
	end)

	netstream.Hook("RemoveAccessorEntity", function(data)
		Entities[data.Index] = nil
	end)

	hook.Add("InitPostEntity", "accessor.InitPostEntity", function()
		Ready = true
		netstream.Send("RequestAccessorList")
	end)

	hook.Add("NetworkEntityCreated", "accessor.NetworkEntityCreated", function(ent)
		Request(ent)
	end)
end

if SERVER then
	function AddEntity(ent)
		local index = ent:EntIndex()

		if index == -1 then
			return
		end

		if Entities[index] then
			return
		end

		Entities[index] = true

		netstream.Send("AddAccessorEntity", {
			Index = index
		})
	end

	function RemoveEntity(ent)
		local index = ent:EntIndex()

		if index == -1 then
			return
		end

		if not Entities[index] then
			return
		end

		Entities[index] = nil

		netstream.Send("RemoveAccessorEntity", {
			Index = index
		})
	end

	netstream.Hook("RequestAccessorList", function(ply, data)
		netstream.Send("SetAccessorList", Entities, ply)
	end)

	netstream.Hook("RequestEntityAccessors", function(ply, data)
		local ent = data.Ent

		if not IsValid(ent) then
			return
		end

		if not Entities[ent:EntIndex()] then
			return
		end

		if GetConVar("debug_accessors"):GetBool() then
			log.Default(string.format("[Accessors] %s requested accessors for %s", ply, ent))
		end

		local tab

		if ent:IsPlayer() then
			tab = Data.Player
		else
			tab = Data.Entity
		end

		for name in pairs(tab) do
			local val = ent["_" .. name]

			if val != nil then
				netstream.Send("SetEntityAccessor", {
					Ent = ent,
					Key = name,
					Val = val
				}, ply)
			end
		end
	end)

	hook.Add("PlayerInitialSpawn", "accessor.PlayerInitialSpawn", function(ply)
		for name in pairs(Data.Global) do
			local val = GAMEMODE["_" .. name]

			if val != nil then
				netstream.Send("SetGlobalAccessor", {
					Key = name,
					Val = val
				}, ply)
			end
		end
	end)

	hook.Add("EntityRemoved", "accessor.EntityRemoved", function(ent)
		RemoveEntity(ent)
	end)
end