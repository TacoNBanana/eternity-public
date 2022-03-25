local meta = FindMetaTable("Player")

GM.Species = GM.Species or {}

hook.Add("Initialize", "species.Initialize", function()
	GAMEMODE:LoadSpecies()
end)

hook.Add("OnReloaded", "species.OnReloaded", function()
	GAMEMODE:LoadSpecies()
end)

if SERVER then
	hook.Add("InitialCharacterSetup", "species.InitialCharacterSetup", function(ply)
		local species = ply:GetActiveSpecies()

		coroutine.WrapFunc(function()
			species:InitialSetup(ply)
		end)
	end)
end

function GM:LoadSpecies()
	for k, v in pairs(includes.Folder("species")) do
		local var = _G[string.upper(k)]

		if var then
			v.ID = var
			v.Enum = string.sub(k, 9)

			class.Register(k, v)

			GAMEMODE.Species[var] = class.Instance(k)
		end
	end
end

function GM:GetSpecies(id)
	return self.Species[id]
end

function meta:GetActiveSpecies()
	return GAMEMODE.Species[self:Species()]
end

function meta:GetAvailableSpecies()
	if self:IsSuperAdmin() then
		return GAMEMODE.Species
	end

	local tab = {}

	for k, v in pairs(GAMEMODE.Species) do
		if self:HasSpeciesWhitelist(k) then
			table.insert(tab, v)
		end
	end

	return tab
end

function meta:HasSpeciesWhitelist(id)
	if self:IsSuperAdmin() then
		return true
	end

	return tobool(bit.band(self:SpeciesWhitelist(), 2^(id - 1)))
end

function meta:GiveSpeciesWhitelist(id)
	if self:IsSuperAdmin() or self:HasSpeciesWhitelist(id) then
		return
	end

	self:SetSpeciesWhitelist(self:SpeciesWhitelist() + 2^(id - 1))
end

function meta:TakeSpeciesWhitelist(id)
	if self:IsSuperAdmin() or not self:HasSpeciesWhitelist(id) then
		return
	end

	self:SetSpeciesWhitelist(self:SpeciesWhitelist() - 2^(id - 1))
end

function GM:IsPropertyDisabled(species, accessor)
	return species.DisabledProperties[accessor] or false
end

function meta:IsPropertyDisabled(accessor)
	return GAMEMODE:IsPropertyDisabled(self:GetActiveSpecies(), accessor)
end

if CLIENT then
	hook.Add("PreDrawHUD", "species", function()
		LocalPlayer():GetActiveSpecies():PreDrawHUD()
	end)
end