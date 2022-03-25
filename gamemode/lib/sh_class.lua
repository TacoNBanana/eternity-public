module("class", package.seeall)

Classes = Classes or {}
Networked = Networked or {}

function Create(name)
	local base = nil

	if name then
		base = Get(name)
	end

	local class = {}
	local instance_meta = {
		__index = function(tab, key)
			local val = tab.Proxy[key]

			if val != nil then
				return val
			end

			val = class[key]

			if istable(val) then
				tab.Proxy[key] = table.Copy(val)

				return tab.Proxy[key]
			else
				return val
			end
		end,
		__newindex = function(tab, key, value)
			if string.Left(key, 2) == "__" then
				rawset(tab, key, value)

				return
			end

			tab:NewIndex(key, value)

			tab.Proxy[key] = value
		end,
		Class = class,
		BaseClass = base or Classes.RootClass
	}

	local class_meta = table.Copy(instance_meta)

	class_meta.__index = base or Classes.RootClass
	class_meta.__newindex = nil
	class_meta.__call = Classes.RootClass.Call
	class_meta.Class = class
	class_meta.InstanceMeta = instance_meta

	setmetatable(class, class_meta)

	return class
end

function Register(name, class)
	class.__classname = name
	Classes[name] = class

	log.Default(string.format("Registered class: %s", name))
end

function Exists(name)
	return Classes[name] and true or false
end

function Instance(name, ...)
	return Get(name):Create(...)
end

function Get(name)
	return Classes[name]
end

function GetNetworked(group, id)
	if not Networked[group] then
		return
	end

	return Networked[group][id]
end

local RootClass = {}

function RootClass.Call(parent, ...)
	return parent:Class():Create(...)
end

function RootClass:Create(...)
	local instance = setmetatable({Proxy = {}}, getmetatable(self).InstanceMeta)

	instance:OnCreated(...)

	return instance
end

function RootClass:GetClass()
	return getmetatable(self) and getmetatable(self).Class or nil
end

function RootClass:GetClassName()
	return self:GetClass() and self:GetClass().__classname or ""
end

function RootClass:GetBaseClass()
	return getmetatable(self) and getmetatable(self).BaseClass or nil
end

function RootClass:OnCreated()
end

function RootClass:IsTypeOf(target)
	local class = self:GetClass()

	if not isstring(target) then
		target = target:GetClassName()
	end

	while class do
		if class:GetClassName() == target then
			return true
		else
			class = getmetatable(class) and class:GetBaseClass() or nil
		end
	end

	return false
end

function RootClass:ParentCall(func, ...)
	self.__Depth = self.__Depth or 0
	self.__Depth = self.__Depth + 1

	local base = self
	local val = {}

	for i = 1, self.__Depth do
		base = base:GetBaseClass()
	end

	local inst = self[func]

	while base[func] == inst do
		base = base:GetBaseClass()
	end

	if base and base[func] then
		val = {base[func](self, unpack({...}))}
	end

	self.__Depth = self.__Depth - 1

	if self.__Depth == 0 then
		self.__Depth = nil
	end

	return unpack(val)
end

function RootClass:NewIndex(key, value)
end

Classes.RootClass = RootClass

local CLASS = Create()

CLASS.NetworkGroup 			= "Ungrouped"
CLASS.NetworkID 			= 0

CLASS.NetworkBlacklist 		= {}

function CLASS:Destroy()
	Networked[self.NetworkGroup][self.NetworkID] = nil

	if SERVER then
		self:DeleteOnClients()
	end
end

function CLASS:OnLoaded()
end

if CLIENT then
	function CLASS:OnUpdated(key, value)
	end
end

if SERVER then
	function CLASS:OnCreated()
		if not Networked[self.NetworkGroup] then
			Networked[self.NetworkGroup] = {}
		end

		self.NetworkID = table.insert(Networked[self.NetworkGroup], self)
		self:OnLoaded()
	end

	function CLASS:SetNetworked(bool)
		self.__Networked = self.__Networked or false

		if self.__Networked == bool then
			return
		end

		self.__Networked = bool

		if bool then
			self:CreateOnClients()
		else
			self:DeleteOnClients()
		end
	end

	function CLASS:GetNetworked()
		return self.__Networked or false
	end

	function CLASS:CreateOnClients(targets)
		local keyvalues = {}

		for _, k in pairs(table.GetKeys(self.Proxy)) do
			if self.NetworkBlacklist[k] then
				continue
			end

			keyvalues[k] = self.Proxy[k]
		end

		if GetConVar("debug_replicated"):GetBool() then
			log.Default(string.format("[Replicated] Creating on network: %s[%s][%s]", self:GetClassName(), self.NetworkGroup, self.NetworkID))
		end

		netstream.Send("CreateReplicated", {
			Class = self:GetClassName(),
			KeyValues = keyvalues
		}, targets)
	end

	function CLASS:DeleteOnClients()
		if GetConVar("debug_replicated"):GetBool() then
			log.Default(string.format("[Replicated] Deleting from network: %s[%s][%s]", self:GetClassName(), self.NetworkGroup, self.NetworkID))
		end

		netstream.Send("DestroyReplicated", {
			Group = self.NetworkGroup,
			ID = self.NetworkID
		})
	end

	function CLASS:NewIndex(key, value)
		if self:GetNetworked() and not self.NetworkBlacklist[key] then
			if GetConVar("debug_replicated"):GetBool() then
				log.Default(string.format("[Replicated] Setting %s on %s[%s][%s]", key, self:GetClassName(), self.NetworkGroup, self.NetworkID))
			end

			netstream.Send("UpdateReplicated", {
				Group = self.NetworkGroup,
				ID = self.NetworkID,
				Key = key,
				Val = value
			})
		end
	end

	netstream.Hook("RequestReplicated", function(ply)
		for _, group in pairs(Networked) do
			for _, v in pairs(group) do
				if not v:GetNetworked() then
					continue
				end

				v:CreateOnClients(ply)
			end
		end
	end, {})
end

Register("base_replicated", CLASS)

if CLIENT then
	hook.Add("InitPostEntity", "class.InitPostEntity", function()
		netstream.Send("RequestReplicated")
	end)

	netstream.Hook("CreateReplicated", function(data)
		local instance = Instance(data.Class)

		for k, v in pairs(data.KeyValues) do
			instance.Proxy[k] = v
		end

		if not Networked[instance.NetworkGroup] then
			Networked[instance.NetworkGroup] = {}
		end

		Networked[instance.NetworkGroup][instance.NetworkID] = instance

		instance:OnLoaded()
	end)

	netstream.Hook("UpdateReplicated", function(data)
		local instance = GetNetworked(data.Group, data.ID)

		if not instance then
			return
		end

		instance.Proxy[data.Key] = data.Val

		instance:OnUpdated(data.Key, data.Val)
	end)

	netstream.Hook("DestroyReplicated", function(data)
		local instance = GetNetworked(data.Group, data.ID)

		if not instance then
			return
		end

		instance:Destroy()
	end)
end