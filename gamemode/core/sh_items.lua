local meta = FindMetaTable("Player")

GM.ItemClasses = GM.ItemClasses or {}

hook.Add("Initialize", "items.Initialize", function()
	GAMEMODE:LoadItems()
end)

hook.Add("OnReloaded", "items.OnReloaded", function()
	GAMEMODE:LoadItems()
end)

function GM:LoadItems()
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_item")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_id.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_weapon.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_radio.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_stacking.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_ammo.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_consumable.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_armor.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_undersuit.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_clothing.lua")
	self:RegisterItem(includes.CurrentFolder(1) .. "items/base_throwable.lua")

	self:RegisterItemFolder("items/clothing")
	self:RegisterItemFolder("items/weapons")
	self:RegisterItemFolder("items/misc")
	self:RegisterItemFolder("items/ammo")
	self:RegisterItemFolder("items/ids")
	self:RegisterItemFolder("items/consumables")
	self:RegisterItemFolder("items/armor")
	self:RegisterItemFolder("items/throwable")
end

function GM:RegisterItem(path)
	local ret

	if string.Right(path, 4) != ".lua" then
		ret = includes.File(path .. "/sh_init.lua")
	else
		ret = includes.File(path)
	end

	path = string.Filename(path)

	class.Register(path, ret)

	if string.Left(path, 4) != "base" and not ret.BlockSpawn then
		self.ItemClasses[path] = true
	end

	ITEM = nil
end

function GM:RegisterItemFolder(path)
	local src = includes.CurrentFolder(2) .. path .. "/"
	local files = file.Find(src .. "*", "LUA")

	for _, v in SortedPairs(files) do
		self:RegisterItem(src .. v)
	end
end

function GM:GetItem(id)
	return class.GetNetworked("Items", id)
end

function meta:GetItemDropLocation()
	local tr = util.TraceLine({
		start = self:EyePos(),
		endpos = self:EyePos() + (self:GetAimVector() * 50),
		filter = self
	})

	return tr.HitPos + (tr.HitNormal * 10)
end