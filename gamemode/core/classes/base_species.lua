local CLASS = class.Create()

CLASS.ID 					= -1

CLASS.Name 					= ""
CLASS.Team 					= TEAM_UNASSIGNED -- Scoreboard team

CLASS.ForceTeamSpawn 		= false -- If set to true, prevents this species from setting their spawnpoint

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {}
CLASS.PlayerModels 			= {} -- Only used for character creation

CLASS.DisabledProperties 	= {} -- Supported: RPName, Description. If #CLASS.PlayerModels <= 1 and no other properties are available, character creation will be skipped

CLASS.InventorySize 		= {6, 4}
CLASS.AllowStash 			= false -- Allows species to use a stash
CLASS.NoFallDamage 			= false
CLASS.GasImmune 			= false -- Immune to ent_zone_gas

CLASS.EquipmentSlots 		= {} -- Used with EQUIPMENT_ slots, positioned on the right side in the character's inventory
CLASS.WeaponSlots 			= {} -- Ditto but for the left side

CLASS.ArmorLevel 			= ARMOR_NONE -- Built-in armor, stacks with equipment

CLASS.MoveSpeed 			= {
	Walk = 80,
	Run = 220,
	Jump = 210,
	Crouch = 80
}

CLASS.DeathSounds 			= {} -- See CLASS:HandleDeathSounds()
CLASS.Voicelines 			= {} -- See CLASS:GetVoicelines()

function CLASS:Loadout(ply)
	for _, v in pairs(self.WeaponLoadout) do
		ply:Give(v)
	end
end

function CLASS:GetVoicelines(ply)
	return self.Voicelines
end

if CLIENT then
	function CLASS:ProcessPreview(ent, pnl) -- Used to set up the character creation preview
	end

	function CLASS:PreDrawHUD()
	end
else
	function CLASS:OnSpawn(ply)
	end

	function CLASS:OnDeath(ply)
		self:HandleDeathSounds(ply)
	end

	function CLASS:OverwriteFootsteps(ply, step, walking) -- Used to overwrite footstep sounds
	end

	function CLASS:HandleDeathSounds(ply)
		if #self.DeathSounds > 0 then
			local snd = table.Random(self.DeathSounds)

			ply:EmitSound(snd, 75, 100, 0.5)
		end
	end

	function CLASS:InitialSetup(ply) -- Called once when the character is loaded for the first time, ever
	end

	function CLASS:GetModelData(ply)
		return {
			_base = {
				Model = ply:CharModel(),
				Skin = ply:CharSkin()
			}
		}
	end

	function CLASS:SetupHands(ply, ent)
		local mdl = ply:Gender() == GENDER_MALE and "models/ishi/halo_rebirth/player/odst/male/odst_m_arms.mdl" or "models/ishi/halo_rebirth/player/odst/female/odst_f_arms.mdl"

		ent:SetModel(mdl)
		ent:SetSkin(0)
		ent:SetBodyGroups("00000000")
	end

	function CLASS:GetSpeeds(ply)
		return self.MoveSpeed.Walk, self.MoveSpeed.Run, self.MoveSpeed.Jump, self.MoveSpeed.Crouch
	end
end

class.Register("base_species", CLASS)