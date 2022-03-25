local meta = FindMetaTable("Player")

GM.PlayerAccessors = {}

function GM:AddPlayerAccessor(name, default, private, storetype)
	self.PlayerAccessors[name] = {
		Default = default,
		Storetype = storetype,
	}

	accessor.Player(name, default, private)

	if SERVER then
		hook.Add("Player" .. name .. "Changed", "PlayerAccessorChanged", function(ply, old, new)
			ply:SavePlayerAccessor(name, new)
		end)
	end
end

accessor.Player("Characters", {}, true)
accessor.Player("PlayerLoaded", false, true)
accessor.Player("EditMode", false, true)
accessor.Player("Typing", 0)
accessor.Player("Camera", false)
accessor.Player("DonatorHidden", false)
accessor.Player("RagdollIndex", false)
accessor.Player("Consciousness", 100)
accessor.Player("Restrained", false)
accessor.Player("LastStash", NULL, true)
accessor.Player("ZoneMins", false, true)
accessor.Player("ZoneMaxs", false, true)
accessor.Player("Gasmask", false, true)
accessor.Player("APC", false, true)
accessor.Player("HullData", false)

GM:AddPlayerAccessor("SpeciesWhitelist", SPECIES_HUMAN, false, "INT")
GM:AddPlayerAccessor("SettingsStore", "[}", true, "TEXT")
GM:AddPlayerAccessor("ToolTrust", TOOLTRUST_BASIC, false, "INT")
GM:AddPlayerAccessor("AdminLevel", USERGROUP_PLAYER, false, "INT")
GM:AddPlayerAccessor("Badges", 0, false, "INT")
GM:AddPlayerAccessor("OOCMuted", 0, false, "BOOLEAN")
GM:AddPlayerAccessor("Donator", 0, false, "BOOLEAN")
GM:AddPlayerAccessor("DonationAmount", 0, false, "INT")

player_manager.AddValidHands("models/eternity/citizens/female_01.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/female_02.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/female_03.mdl", "models/weapons/c_arms_citizen.mdl", 1, "00000000")
player_manager.AddValidHands("models/eternity/citizens/female_04.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/female_05.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/female_06.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")

player_manager.AddValidHands("models/eternity/citizens/male_01.mdl", "models/weapons/c_arms_citizen.mdl", 1, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_02.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_03.mdl", "models/weapons/c_arms_citizen.mdl", 1, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_04.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_05.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_06.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_07.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_08.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")
player_manager.AddValidHands("models/eternity/citizens/male_09.mdl", "models/weapons/c_arms_citizen.mdl", 0, "00000000")

player_manager.AddValidHands("models/player/soldier_stripped.mdl", "models/weapons/c_arms_combine.mdl", 0, "00000000")

function meta:GetArmorLevel()
	return GAMEMODE:GetConfig("ArmorLevels")[self:ArmorLevel() + 1]
end

function meta:ShouldLockInput()
	if not self:HasCharacter() then
		return true
	end

	if self:Alive() and IsValid(self:GetRagdoll()) then
		return true
	end

	return false
end

function meta:GetZone(classname)
	self.ActiveZone = self.ActiveZone or {}

	return self.ActiveZone[classname]
end

function meta:InOutlands()
	return tobool(self:GetZone("ent_zone_outlands"))
end

function GM:ScalePlayerDamage(ply, hitgroup, dmg)
	if SERVER and ply:Armor() > 0 then
		ply:SetArmor(0)
	end

	local groups = GAMEMODE:GetConfig("HitGroupMultipliers")

	if groups[hitgroup] then
		dmg:ScaleDamage(groups[hitgroup])
	end

	dmg:ScaleDamage(ply:GetArmorLevel().Mult)
end

hook.Add("Think", "player.Think", function()
	for _, v in pairs(player.GetAll()) do
		hook.Run("PlayerThink", v)
	end
end)

hook.Add("StartCommand", "player.StartCommand", function(ply, cmd)
	if not ply:ShouldLockInput() then
		return
	end

	cmd:ClearMovement()
	cmd:ClearButtons()
end)

hook.Add("PlayerSwitchWeapon", "player.PlayerSwitchWeapon", function(ply, old, new)
	if ply:ShouldLockInput() then
		return true
	end

	new:SetNoDraw(ply:GetNoDraw())
end)