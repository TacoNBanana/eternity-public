local meta = FindMetaTable("Player")

function GM:PlayerSpawn(ply)
	ply:DoSpawn()

	return true
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerCanHearPlayersVoice()
	return false -- Fuck that
end

function GM:PlayerSpray(ply)
	return true
end

function GM:PlayerShouldTaunt(ply, act)
	return ply:IsDeveloper()
end

function GM:PlayerSwitchFlashlight(ply, enable)
	ply.LastFlashlight = ply.LastFlashlight or CurTime()

	if ply.LastFlashlight <= CurTime() then
		ply.LastFlashlight = CurTime() + 0.2

		return true
	end

	return false
end

function meta:DoSpawn(loaded)
	self:Freeze(not self:HasCharacter())

	self:SetConsciousness(100)
	self:SetRestrained(false)

	self:HandleLoadout()
	self:HandlePlayerModel()
	self:HandleArmorLevel()
	self:HandleTeam()
	self:HandleMoveSpeed()
	self:HandleMisc()

	self:AllowFlashlight(true)
	self:SetCanZoom(false)

	self:ClearNPCRelationships()
	self:HandleNPCRelationships()

	if self:HasCharacter() then
		local species = self:GetActiveSpecies()

		self:SetHealth(species.BaseHealth)
		self:SetMaxHealth(species.BaseHealth)

		species:OnSpawn(self)

		for _, v in pairs(self:GetEquipment()) do
			v:OnSpawn(self, loaded)
		end
	end

	self:HandleSpawnpoint()
end

function meta:HandleLoadout()
	self:StripWeapons()

	if not self:HasCharacter() then
		return true
	end

	local species = self:GetActiveSpecies()

	species:Loadout(self)

	if self:ToolTrust() != TOOLTRUST_BANNED or self:IsAdmin() then
		self:Give("weapon_physgun")
		self:Give("gmod_tool")
	end

	if self:IsAdmin() then
		self:Give("eternity_zonemarker")
		self:Give("eternity_bombs")
	end

	self:SelectWeapon(species.WeaponLoadout[1])

	return true
end

function meta:HandleMisc()
	local filtered = false

	for _, v in pairs(self:GetEquipment()) do
		if v.Filtered then
			filtered = true

			break
		end
	end

	self:SetGasmask(filtered)
end

function meta:GetValidSpawns()
	local spawns = ents.FindByClass("ent_spawn")
	local tab = {}

	if not self:HasCharacter() then
		-- Bird spawns
		for _, v in pairs(spawns) do
			if v:GetTeam() == TEAM_UNASSIGNED then
				table.insert(tab, v)
			end
		end
	else
		local species = self:GetActiveSpecies()

		-- Spawngroups
		if not species.ForceTeamSpawn then
			local group = self:Spawngroup()

			if group != "" then
				for _, v in pairs(spawns) do
					if v:GetSpawngroup() == group then
						table.insert(tab, v)
					end
				end
			end
		end

		-- Team spawns
		if #tab < 1 then
			for _, v in pairs(spawns) do
				if v:GetTeam() == self:Team() then
					table.insert(tab, v)
				end
			end
		end
	end

	-- Generic spawns
	if #tab < 1 then
		for _, v in pairs(spawns) do
			if v:GetSpawngroup() == "" and v:GetTeam() == 0 then
				table.insert(tab, v)
			end
		end
	end

	return tab
end

function GM:GetSuitableSpawn(spawns, force, ply)
	for _, v in RandomPairs(spawns) do
		if IsValid(v) and v:IsSuitable(force, ply) then
			return v
		end
	end
end

function meta:HandleSpawnpoint()
	local spawns = self:GetValidSpawns()
	local spawn = GAMEMODE:GetSuitableSpawn(spawns, false, self)

	if not IsValid(spawn) then
		spawn = GAMEMODE:GetSuitableSpawn(spawns, true, self)
	end

	if not IsValid(spawn) then
		spawn = GAMEMODE:PlayerSelectSpawn(self)
	end

	self:SetDelayedPosition(spawn:GetPos(), Angle(0, spawn:GetAngles().y, 0))
end

function meta:HandleArmorLevel()
	local level = 0

	if self:HasCharacter() then
		level = self:GetActiveSpecies().ArmorLevel

		for _, v in pairs(self:GetEquipment()) do
			level = level + (v.ArmorLevel or 0)
		end
	end

	level = math.Clamp(level, 0, #GAMEMODE:GetConfig("ArmorLevels") - 1)

	self:SetArmorLevel(level)
end

function meta:HandleMoveSpeed()
	if not self:HasCharacter() then
		self:SetWalkSpeed(0)
		self:SetRunSpeed(0)
		self:SetJumpPower(0)
		self:SetCrouchedWalkSpeed(0)
	end

	local consciousness = self:Consciousness() / 100
	local walk, run, jump, crouch = self:GetActiveSpecies():GetSpeeds(self)

	self:SetWalkSpeed(walk)
	self:SetRunSpeed(math.Max(walk, run * self:GetArmorLevel().Speed * consciousness))
	self:SetJumpPower(jump)
	self:SetCrouchedWalkSpeed(crouch)
end

function meta:HandleTeam()
	if not self:HasCharacter() then
		self:SetTeam(TEAM_UNASSIGNED)

		return
	end

	local playerteam = self:GetActiveSpecies().Team

	for _, v in pairs(self:GetEquipment()) do
		if v.Team then
			playerteam = v.Team
		end
	end

	self:SetTeam(playerteam)
end

function meta:SetDelayedPosition(pos, ang)
	self.DelayedPos = pos or self:GetPos()
	self.DelayedAng = ang or self:GetAngles()
end

function meta:SetPhysgunColor()
	local vec = Vector(0.15, 0.81, 0.91)
	local dev = self:GetSetting("dev_physgun_mode")

	if dev != PHYSGUNMODE_DEFAULT then
		if dev == PHYSGUNMODE_CUSTOM then
			local col = self:GetSetting("dev_physgun_color")

			vec = Vector(col.r / 255, col.g / 255, col.b / 255)
		elseif dev == PHYSGUNMODE_RAINBOW_CLASSIC then
			for i = 1, 3 do
				vec[i] = math.abs(math.sin(CurTime() * 2.4 + (2 * i)))
			end
		elseif dev == PHYSGUNMODE_RAINBOW_NEW then
			local time = CurTime() * 50
			local col = HSVToColor(time % 360, 1, 1)

			vec = Vector(col.r / 255, col.g / 255, col.b / 255)
		end
	elseif self:GetSetting("donator_physgun_color") then
		vec = team.GetColor(self:Team()):ToVector()
	end

	self:SetWeaponColor(vec)
end

hook.Add("PostPlayerDeath", "player.PostPlayerDeath", function(ply)
	for _, v in pairs(ply:GetEquipment()) do
		v:OnDeath(ply)
	end

	ply:GetActiveSpecies():OnDeath(ply)
end)

hook.Add("PlayerArmorLevelChanged", "player.PlayerArmorLevelChanged", function(ply, old, new)
	ply:HandleMoveSpeed()
end)

hook.Add("PlayerConsciousnessChanged", "player.PlayerConsciousnessChanged", function(ply, old, new)
	ply:HandleMoveSpeed()
end)

hook.Add("PlayerButtonDown", "player.PlayerButtonDown", function(ply, button)
	ply.LastActivity = CurTime()
end)

hook.Add("PlayerThink", "player.PlayerThink", function(ply)
	local afk = GAMEMODE:GetConfig("AFKKicker")

	if afk.Enabled and (#player.GetAll() / game.MaxPlayers()) > afk.Threshold and not ply:IsAdmin() then
		ply.LastActivity = ply.LastActivity or CurTime()

		if CurTime() - ply.LastActivity > afk.Timer then
			GAMEMODE:WriteLog("security_inactivity", {
				Ply = GAMEMODE:LogPlayer(ply)
			})

			game.KickID(ply:UserID(), "Kicked for inactivity")
		end
	end

	if ply.DelayedPos then
		ply:SetPos(ply.DelayedPos)
		ply.DelayedPos = nil
	end

	if ply.DelayedAng then
		ply:SetEyeAngles(ply.DelayedAng)
		ply.DelayedAng = nil
	end

	ply:SetPhysgunColor()
end)

function GM:DoPlayerDeath(ply, attacker, dmg)
	if attacker:IsPlayer() and self:GetConfig("DropOnDeath") then
		local weapon = ply:GetActiveWeapon()

		if IsValid(weapon) and weapon.GetItem then
			local item = weapon:GetItem()

			if item and not item.NoDrop then
				local inventory = item:GetInventory()

				inventory:RemoveItem(item)

				item:SetWorldItem(ply:EyePos(), Angle())
			end
		end
	end

	if not IsValid(ply:GetRagdoll()) then
		ply:CreateRagdoll()
	end

	if IsValid(attacker) and attacker:IsPlayer() and attacker != ply then
		local weapon = dmg:GetInflictor()

		if not IsValid(weapon) then
			return
		end

		if weapon:IsPlayer() and IsValid(weapon:GetActiveWeapon()) then
			weapon = weapon:GetActiveWeapon()
		end

		self:WriteLog("sandbox_kill", {
			Ply = self:LogPlayer(attacker),
			Char = self:LogCharacter(attacker),
			VictimPly = self:LogPlayer(ply),
			VictimChar = self:LogCharacter(ply),
			Weapon = weapon:GetClass()
		})
	end
end

function GM:CanPlayerSuicide(ply)
	if not ply:HasCharacter() then
		return false
	end

	if ply:Restrained() then
		return false
	end

	return true
end

function GM:GetFallDamage(ply, speed)
	if ply:GetActiveSpecies().NoFallDamage then
		return 0
	end

	return self.BaseClass:GetFallDamage(ply, speed)
end