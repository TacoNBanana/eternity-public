local CLASS = class.Create("base_species")

CLASS.Name 					= "Human"
CLASS.Team 					= TEAM_CITIZEN

CLASS.BaseHealth 			= 100

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/tnb/techcom/male_01.mdl"),
	Model("models/tnb/techcom/male_02.mdl"),
	Model("models/tnb/techcom/male_03.mdl"),
	Model("models/tnb/techcom/male_04.mdl"),
	Model("models/tnb/techcom/male_05.mdl"),
	Model("models/tnb/techcom/male_06.mdl"),
	Model("models/tnb/techcom/male_07.mdl"),
	Model("models/tnb/techcom/male_08.mdl"),
	Model("models/tnb/techcom/male_09.mdl"),
	Model("models/tnb/techcom/female_01.mdl"),
	Model("models/tnb/techcom/female_02.mdl"),
	Model("models/tnb/techcom/female_03.mdl"),
	Model("models/tnb/techcom/female_04.mdl"),
	Model("models/tnb/techcom/female_05.mdl"),
	Model("models/tnb/techcom/female_38.mdl"),
	Model("models/tnb/techcom/female_53.mdl")
}

CLASS.DisabledProperties 	= {}

CLASS.AllowStash 			= true

CLASS.EquipmentSlots 		= {EQUIPMENT_HEAD, EQUIPMENT_TORSO, EQUIPMENT_BACK, EQUIPMENT_LEGS, EQUIPMENT_GLOVES}
CLASS.WeaponSlots 			= {EQUIPMENT_ID, EQUIPMENT_RADIO, EQUIPMENT_PRIMARY, EQUIPMENT_SECONDARY, EQUIPMENT_MISC}

CLASS.DeathSounds 			= {
	[GENDER_MALE] = {
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	},
	[GENDER_FEMALE] = {
		"vo/npc/female01/pain01.wav",
		"vo/npc/female01/pain02.wav",
		"vo/npc/female01/pain03.wav",
		"vo/npc/female01/pain04.wav",
		"vo/npc/female01/pain05.wav",
		"vo/npc/female01/pain06.wav",
		"vo/npc/female01/pain07.wav",
		"vo/npc/female01/pain08.wav",
		"vo/npc/female01/pain09.wav"
	}
}

if CLIENT then
	function CLASS:ProcessPreview(ent, pnl)
		part.Clear(ent)

		local gender = GAMEMODE:GetGenderString(ent:GetModel())
		local config = GAMEMODE:GetConfig("ClothingDefaults")

		part.Add(ent, "torso", {Model = string.format(config.Torso, gender)})
		part.Add(ent, "legs", {Model = string.format(config.Legs, gender)})

		ent:SetBodygroup(2, 1)
		ent:SetNoDraw(true)

		pnl.PreDrawModel = function()
			ent:DrawModel()

			local parts = part.Get(ent)

			if parts then
				for _, v in pairs(parts) do
					if IsValid(v.Ent) then
						v.Ent:DrawModel()
					end
				end
			end

			return false
		end
	end
end

if SERVER then
	function CLASS:HandleDeathSounds(ply)
		local tab = self.DeathSounds[ply:GetGender()]

		if tab and #tab > 0 then
			local snd = table.Random(tab)

			ply:EmitSound(snd, 75, 100, 0.5)
		end
	end

	function CLASS:InitialSetup(ply)
		ply:GiveMoney(300)
	end

	function CLASS:GetModelData(ply)
		local config = GAMEMODE:GetConfig("ClothingDefaults")
		local gender = GAMEMODE:GetGenderString(ply:CharModel())

		local data = {
			_base = {
				Model = ply:CharModel(),
				Skin = ply:CharSkin(),
				Bodygroups = {
					hands = 1
				}
			},
			torso = {
				Model = string.format(config.Torso, gender)
			},
			legs = {
				Model = string.format(config.Legs, gender)
			}
		}

		return data
	end
end

return CLASS