local fireSounds = {
	level = 97,
	volume = 1,
	pitch = {92, 112}
}

local function directional(snd)
	if istable(snd) then
		for k, v in pairs(snd) do
			snd[k] = ")" .. v
		end
	else
		snd = ")" .. snd
	end

	return snd
end

function GM:AddSound(partial, options)
	local tab = table.Copy(partial)

	table.Merge(tab, options)
	sound.Add(tab)

	if istable(tab.sound) then
		for _, v in pairs(tab.sound) do
			util.PrecacheSound(v)
		end
	else
		util.PrecacheSound(tab.sound)
	end
end

function GM:AddFireSound(name, snd, level)
	self:AddWeaponSound(name, snd, level, CHAN_WEAPON)
end

function GM:AddWeaponSound(name, snd, level, chan)
	snd = directional(snd)

	local tab = {
		name = name,
		channel = chan or CHAN_AUTO,
		level = level,
		sound = snd
	}

	self:AddSound(fireSounds, tab)
end

GM:AddFireSound("bullet_impact", {
	"eternity/impact/gun_impact_1.wav",
	"eternity/impact/gun_impact_2.wav",
	"eternity/impact/gun_impact_3.wav",
	"eternity/impact/gun_impact_4.wav",
	"eternity/impact/gun_impact_5.wav",
	"eternity/impact/gun_impact_6.wav",
	"eternity/impact/gun_impact_7.wav",
	"eternity/impact/gun_impact_8.wav",
	"eternity/impact/gun_impact_9.wav",
	"eternity/impact/gun_impact_10.wav",
	"eternity/impact/gun_impact_11.wav",
	"eternity/impact/gun_impact_12.wav",
	"eternity/impact/gun_impact_13.wav",
	"eternity/impact/gun_impact_14.wav"
}, 75)

GM:AddFireSound("weapon_mp7", "eternity/weapons/weapon_mp7.wav", 140)
GM:AddFireSound("weapon_shotgun", "weapons/shotgun/shotgun_fire7.wav", 140)
GM:AddFireSound("weapon_usp", "weapons/tfa_ins2/usp_match/usp_unsil-1.wav", 140)
GM:AddFireSound("weapon_makarov_pm", "weapons/tfa_ins2/pm/pm_fire.wav", 140)
GM:AddFireSound("weapon_makarov_pmm", "weapons/tfa_ins2/pm/pmm_fire.wav", 140)
GM:AddFireSound("weapon_makarov_pb", "weapons/tfa_ins2/pm/pb_fire.wav", 100)
GM:AddFireSound("weapon_m9", {
	"weapons/tfa_ins2/m9/fire_1.wav",
	"weapons/tfa_ins2/m9/fire_2.wav",
	"weapons/tfa_ins2/m9/fire_3.wav"
}, 140)
GM:AddFireSound("weapon_akm", "weapons/tfa_ins2/akz/ak47_fp.wav", 140)
GM:AddFireSound("weapon_mossberg", {
	"weapons/tfa_ins2/m590o/fire-1.wav",
	"weapons/tfa_ins2/m590o/fire-2.wav",
	"weapons/tfa_ins2/m590o/fire-3.wav"
}, 140)
GM:AddFireSound("weapon_groza", "weapons/tfa_ins2/groza/normal.wav", 140)
GM:AddFireSound("weapon_ak47", {
	"weapons/tfa_cod/mwr/ak47/ak47_fire1.wav",
	"weapons/tfa_cod/mwr/ak47/ak47_fire2.wav",
	"weapons/tfa_cod/mwr/ak47/ak47_fire3.wav",
	"weapons/tfa_cod/mwr/ak47/ak47_fire4.wav"
}, 140)
GM:AddFireSound("weapon_sks", "weapons/tfa_ins2/sks/sks_fire01.wav", 140)

GM:AddWeaponSound("TFA_INS2.USP_M.Empty", "weapons/tfa_ins2/usp_match/usp_match_empty.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.Boltback", "weapons/tfa_ins2/usp_match/usp_match_boltback.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.Boltrelease", "weapons/tfa_ins2/usp_match/usp_match_boltrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.Magrelease", "weapons/tfa_ins2/usp_match/usp_match_magrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.Magout", "weapons/tfa_ins2/usp_match/usp_match_magout.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.Magin", "weapons/tfa_ins2/usp_match/usp_match_magin.wav", 80)
GM:AddWeaponSound("TFA_INS2.USP_M.MagHit", "weapons/tfa_ins2/usp_match/usp_match_maghit.wav", 80)

GM:AddWeaponSound("Weapon_PM.Boltback", "weapons/tfa_ins2/pm/pm_boltback.wav", 80)
GM:AddWeaponSound("Weapon_PM.Boltrelease", "weapons/tfa_ins2/pm/pm_boltrelease.wav", 80)
GM:AddWeaponSound("Weapon_PM.Magout", "weapons/tfa_ins2/pm/pm_magout.wav", 80)
GM:AddWeaponSound("Weapon_PM.Magin", "weapons/tfa_ins2/pm/pm_magin.wav", 80)
GM:AddWeaponSound("Weapon_PM.MagHit", "weapons/tfa_ins2/pm/pm_maghit.wav", 80)

GM:AddWeaponSound("TFA_INS2.M9.Boltback", "weapons/tfa_ins2/m9/handling/m9_boltback.wav", 80)
GM:AddWeaponSound("TFA_INS2.M9.Boltrelease", "weapons/tfa_ins2/m9/handling/m9_boltrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.M9.Magrelease", "weapons/tfa_ins2/m9/handling/m9_magrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.M9.Magout", "weapons/tfa_ins2/m9/handling/m9_magout.wav", 80)
GM:AddWeaponSound("TFA_INS2.M9.Magin", "weapons/tfa_ins2/m9/handling/m9_magin.wav", 80)
GM:AddWeaponSound("TFA_INS2.M9.MagHit", "weapons/tfa_ins2/m9/handling/m9_maghit.wav", 80)

GM:AddWeaponSound("TFA_INS2_AKZ.MagRelease", "weapons/tfa_ins2/akz/ak47_magrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2_AKZ.Magout", "weapons/tfa_ins2/akz/ak47_magout.wav", 80)
GM:AddWeaponSound("TFA_INS2_AKZ.Rattle", "weapons/tfa_ins2/akz/ak47_rattle.wav", 80)
GM:AddWeaponSound("TFA_INS2_AKZ.Magin", "weapons/tfa_ins2/akz/ak47_magin.wav", 80)
GM:AddWeaponSound("TFA_INS2_AKZ.Boltback", "weapons/tfa_ins2/akz/ak47_boltback.wav", 80)
GM:AddWeaponSound("TFA_INS2_AKZ.Boltrelease", "weapons/tfa_ins2/akz/ak47_boltrelease.wav", 80)

GM:AddWeaponSound("TFA_INS2_M590_OLLI.Boltback", "/weapons/tfa_ins2/m590o/PumpBack.wav", 80)
GM:AddWeaponSound("TFA_INS2_M590_OLLI.Boltrelease", "/weapons/tfa_ins2/m590o/PumpForward.wav", 80)
GM:AddWeaponSound("TFA_INS2_M590_OLLI.ShellInsert", {
	"/weapons/tfa_ins2/m590o/InsertShell-1.wav",
	"/weapons/tfa_ins2/m590o/InsertShell-2.wav",
	"/weapons/tfa_ins2/m590o/InsertShell-3.wav",
	"/weapons/tfa_ins2/m590o/InsertShell-4.wav",
	"/weapons/tfa_ins2/m590o/InsertShell-5.wav"
}, 80)
GM:AddWeaponSound("TFA_INS2_M590_OLLI.ShellInsertSingle", {
	"/weapons/tfa_ins2/m590o/m590_single_shell_insert_1.wav",
	"/weapons/tfa_ins2/m590o/m590_single_shell_insert_2.wav",
	"/weapons/tfa_ins2/m590o/m590_single_shell_insert_3.wav"
}, 80)

GM:AddWeaponSound("TFA_INS2.GROZA.Boltback", "weapons/tfa_ins2/groza/aks_boltback.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.Boltrelease", "weapons/tfa_ins2/groza/aks_boltrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.Empty", "weapons/tfa_ins2/groza/aks_empty.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.MagRelease", "weapons/tfa_ins2/groza/aks_magrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.Magin", "weapons/tfa_ins2/groza/aks_magin.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.Magout", "weapons/tfa_ins2/groza/aks_magout.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.MagoutRattle", "weapons/tfa_ins2/groza/aks_magout_rattle.wav", 80)
GM:AddWeaponSound("TFA_INS2.GROZA.ROF", {"weapons/tfa_ins2/groza/aks_fireselect_1.wav", "weapons/tfa_ins2/groza/aks_fireselect_2.wav"}, 80)
GM:AddWeaponSound("TFA_INS2.GROZA.Rattle", "weapons/tfa_ins2/groza/aks_rattle.wav", 80)

GM:AddWeaponSound("TFA_MWR_AK47.Chamber", "weapons/tfa_cod/mwr/ak47/wpfoly_ak47_reload_chamber_v4.wav", 80)
GM:AddWeaponSound("TFA_MWR_AK47.ClipIn", "weapons/tfa_cod/mwr/ak47/wpfoly_ak47_reload_clipin_v4.wav", 80)
GM:AddWeaponSound("TFA_MWR_AK47.ClipOut", "weapons/tfa_cod/mwr/ak47/wpfoly_ak47_reload_clipout_v5.wav", 80)

GM:AddWeaponSound("TFA_INS2.SKS.Empty", "weapons/tfa_ins2/sks/sks_empty.wav", 80)
GM:AddWeaponSound("TFA_INS2.SKS.Magrelease", "weapons/tfa_ins2/sks/sks_magrelease.wav", 80)
GM:AddWeaponSound("TFA_INS2.SKS.Magin", "weapons/tfa_ins2/sks/sks_magazine_in.wav", 80)
GM:AddWeaponSound("TFA_INS2.SKS.Magout", "weapons/tfa_ins2/sks/sks_magazine_out.wav", 80)
GM:AddWeaponSound("TFA_INS2.SKS.Boltback", "weapons/tfa_ins2/sks/sks_boltpull.wav", 80)
GM:AddWeaponSound("TFA_INS2.SKS.Boltrelease", "weapons/tfa_ins2/sks/sks_boltrelease.wav", 80)