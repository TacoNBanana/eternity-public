local holsterDown = false

local meta = FindMetaTable("Weapon")

function meta:IsEternity()
	if self.Base then
		return tobool(string.find(self.Base, "eternity"))
	end

	return false
end

matproxy.Add({
	name = "drc_CurHeat",
	init = function(self, mat, values)
		self.Target = values.resultvar
	end,
	bind = function(self, mat, ent)
		if not IsValid(ent) then
			return
		end

		local parent = ent.ParentWeapon

		if IsValid(parent) and parent:IsWeapon() then
			ent = parent
		end

		if not IsValid(ent) or not ent:IsWeapon() or not ent.GetHeat then
			mat:SetVector(self.Target, Vector(1, 1, 1))

			return
		end

		local cool = ent.CoolColor or Vector(0, 1, 0)
		local hot = ent.HotColor or Vector(1, 0, 0)

		mat:SetVector(self.Target, LerpVector(ent:GetHeat() * 0.01, cool, hot))
	end
})

matproxy.Add({
	name = "drc_CurHeat2",
	init = function(self, mat, values)
		self.Target = values.resultvar
	end,
	bind = function(self, mat, ent)
		if not IsValid(ent) then
			return
		end

		local parent = ent.ParentWeapon

		if IsValid(parent) and parent:IsWeapon() then
			ent = parent
		end

		if not IsValid(ent) or not ent:IsWeapon() or not ent.GetHeat then
			mat:SetVector(self.Target, Vector(1, 1, 1))

			return
		end

		local cool = ent.CoolColor or Vector(0, 1, 0)
		local hot = ent.HotColor or Vector(1, 0, 0)

		mat:SetVector(self.Target, LerpVector(ent:GetHeat() * 0.01, cool, hot))
	end
})

local binds = {"invnext", "invprev", "jump"}

netstream.Hook("ImpactSound", function(data)
	if GAMEMODE:GetSetting("sounds_bullets") then
		sound.Play(data.Plasma and "plasma_impact" or "bullet_impact", data.HitPos, 120, 100, 1)
	end
end)

hook.Add("PlayerBindPress", "CL.Weapon.PlayerBindPress", function(ply, bind, down)
	if not down then
		return
	end

	local weapon = ply:GetActiveWeapon()

	if IsValid(weapon) and weapon:IsEternity() and weapon.AimingDownSights and weapon:AimingDownSights() then
		for _, v in pairs(binds) do
			if string.find(bind, v) then
				return true
			end
		end
	end
end)

hook.Add("PreDrawPlayerHands", "CL.Weapon.PreDrawPlayerHands", function(_, _, _, weapon)
	return weapon:IsEternity()
end)

hook.Add("Think", "weapons.Think", function()
	for _, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then
			continue
		end

		local weapon = v:GetActiveWeapon()

		if IsValid(weapon) and weapon:IsEternity() then
			weapon:Think()
		end
	end

	local weapon = LocalPlayer():GetActiveWeapon()
	local vm = LocalPlayer():GetViewModel()

	if not IsValid(weapon) then
		return
	end

	if IsValid(vm) then
		if weapon.Base and string.find(weapon.Base, "eternity") then
			vm:SetMaterial("engine/occlusionproxy")
		else
			vm:SetMaterial()
		end
	end

	if LocalPlayer():IsInCamera() then
		return
	end

	if vgui.CursorVisible() then
		holsterDown = false
	else
		if input.IsKeyDown(KEY_B) and not holsterDown then
			holsterDown = true

			netstream.Send("ToggleHolster")
			LocalPlayer():ToggleHolster()
		elseif not input.IsKeyDown(KEY_B) and holsterDown then
			holsterDown = false
		end
	end
end)