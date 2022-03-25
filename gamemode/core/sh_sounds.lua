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

function GM:AddFireSound(name, snd, level, pitch)
	self:AddWeaponSound(name, snd, level, CHAN_WEAPON, pitch)
end

function GM:AddWeaponSound(name, snd, level, chan, pitch)
	snd = directional(snd)

	local tab = {
		name = name,
		channel = chan or CHAN_AUTO,
		level = level,
		sound = snd,
		pitch = pitch
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

GM:AddFireSound("plasma_impact", {
	"vuthakral/halo/weapons/plas_impact_reach0.wav",
	"vuthakral/halo/weapons/plas_impact_reach1.wav",
	"vuthakral/halo/weapons/plas_impact_reach2.wav",
	"vuthakral/halo/weapons/plas_impact_reach3.wav",
	"vuthakral/halo/weapons/plas_impact_reach4.wav"
}, 75)

GM:AddFireSound("weapon_dmr", {
	"vuthakral/halo/weapons/dmr/fire0.wav",
	"vuthakral/halo/weapons/dmr/fire1.wav",
	"vuthakral/halo/weapons/dmr/fire2.wav"
}, 140)

GM:AddFireSound("weapon_m319", {
	"vuthakral/halo/weapons/m139/fire0.wav",
	"vuthakral/halo/weapons/m139/fire1.wav",
	"vuthakral/halo/weapons/m139/fire2.wav",
	"vuthakral/halo/weapons/m139/fire3.wav",
	"vuthakral/halo/weapons/m139/fire4.wav",
	"vuthakral/halo/weapons/m139/fire5.wav",
	"vuthakral/halo/weapons/m139/fire6.wav",
	"vuthakral/halo/weapons/m139/fire7.wav",
	"vuthakral/halo/weapons/m139/fire8.wav",
	"vuthakral/halo/weapons/m139/fire9.wav"
}, 140, 100)

GM:AddFireSound("weapon_m45", {
	"vuthakral/halo/weapons/m90/fire0.wav",
	"vuthakral/halo/weapons/m90/fire1.wav",
	"vuthakral/halo/weapons/m90/fire2.wav"
}, 140)

GM:AddFireSound("weapon_m6c", "vuthakral/halo/weapons/m6c/fire.wav", 140)

GM:AddFireSound("weapon_m6s", {
	"vuthakral/halo/weapons/m6s/fire0.wav",
	"vuthakral/halo/weapons/m6s/fire1.wav",
	"vuthakral/halo/weapons/m6s/fire2.wav",
	"vuthakral/halo/weapons/m6s/fire3.wav"
}, 100)

GM:AddFireSound("weapon_m6g", "vuthakral/halo/weapons/m6d/fire.wav", 140) -- Yes I know it's the M6D sound shush

GM:AddFireSound("weapon_m7", {
	"vuthakral/halo/weapons/m7smg/fire1.wav",
	"vuthakral/halo/weapons/m7smg/fire2.wav",
	"vuthakral/halo/weapons/m7smg/fire3.wav",
	"vuthakral/halo/weapons/m7smg/fire4.wav",
	"vuthakral/halo/weapons/m7smg/fire5.wav",
	"vuthakral/halo/weapons/m7smg/fire7.wav",
	"vuthakral/halo/weapons/m7smg/fire8.wav",
	"vuthakral/halo/weapons/m7smg/fire9.wav",
	"vuthakral/halo/weapons/m7smg/fire10.wav",
	"vuthakral/halo/weapons/m7smg/fire11.wav",
	"vuthakral/halo/weapons/m7smg/fire12.wav",
	"vuthakral/halo/weapons/m7smg/fire13.wav",
	"vuthakral/halo/weapons/m7smg/fire14.wav",
	"vuthakral/halo/weapons/m7smg/fire15.wav",
	"vuthakral/halo/weapons/m7smg/fire16.wav",
	"vuthakral/halo/weapons/m7smg/fire17.wav"
}, 140)

GM:AddFireSound("weapon_m7s", {
	"vuthakral/halo/weapons/m7s/fire0.wav",
	"vuthakral/halo/weapons/m7s/fire1.wav",
	"vuthakral/halo/weapons/m7s/fire2.wav"
}, 100)

GM:AddFireSound("weapon_ma37", {
	"vuthakral/halo/weapons/ma37/fire0.wav",
	"vuthakral/halo/weapons/ma37/fire1.wav",
	"vuthakral/halo/weapons/ma37/fire2.wav"
}, 140)

GM:AddFireSound("weapon_plasmapistol", {
	"vuthakral/halo/weapons/pp/fire0.wav",
	"vuthakral/halo/weapons/pp/fire1.wav",
	"vuthakral/halo/weapons/pp/fire2.wav"
}, 140, 100)

GM:AddFireSound("weapon_plasmarifle", "vuthakral/halo/weapons/plasmarifle/plas_rifle_fire.wav", 140, 100)

GM:AddFireSound("weapon_needler", {
	"vuthakral/halo/weapons/needler/fire0.wav",
	"vuthakral/halo/weapons/needler/fire1.wav",
	"vuthakral/halo/weapons/needler/fire2.wav"
}, 140, 100)

GM:AddFireSound("needler_shatter", {
	"vuthakral/halo/weapons/needler/expl1.wav",
	"vuthakral/halo/weapons/needler/expl3.wav"
}, 75, 100)

GM:AddFireSound("needler_supercombine", "vuthakral/halo/weapons/needler/supercombine.wav", 140, 100)

GM:AddFireSound("weapon_spnkr", {
	"vuthakral/halo/weapons/spnkr/fire0.wav",
	"vuthakral/halo/weapons/spnkr/fire1.wav",
	"vuthakral/halo/weapons/spnkr/fire2.wav",
	"vuthakral/halo/weapons/spnkr/fire3.wav"
}, 140)

GM:AddFireSound("weapon_srs99am", {
	"vuthakral/halo/weapons/srs99d/fire0.wav",
	"vuthakral/halo/weapons/srs99d/fire1.wav",
	"vuthakral/halo/weapons/srs99d/fire2.wav",
	"vuthakral/halo/weapons/srs99d/fire3.wav"
}, 140)

if CLIENT then
	netstream.Hook("DistantExplosion", function(data)
		local pos = data.Pos
		local typeid = data.Type

		local fadenear, fadefar
		local nearsnd, farsnd

		if typeid == EXPLOSION_SPNKR then
			fadenear = 10000
			fadefar = 20000

			nearsnd = string.format("vuthakral/halo/weapons/spnkr/explode%s.wav", math.random(0, 5))
			farsnd = string.format("vuthakral/halo/weapons/spnkr/explode_dist%s.wav", math.random(0, 2))
		elseif typeid == EXPLOSION_40MM then
			fadenear = 8000

			nearsnd = string.format("vuthakral/halo/weapons/m139/explode%s.wav", math.random(0, 2))
		else
			return
		end

		local dist = LocalPlayer():EyePos():Distance(pos)

		if nearsnd and dist < fadenear then
			local vol = math.ClampedRemap(dist, 0, fadenear, 1, 0)

			LocalPlayer():EmitSound(nearsnd, 100, 100, vol)
		end

		if farsnd and dist < fadefar then
			local vol = math.ClampedRemap(dist, 0, fadefar, 1, 0)

			LocalPlayer():EmitSound(farsnd, 100, 100, vol)
		end
	end)
end