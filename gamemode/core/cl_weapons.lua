local holsterDown = false

local meta = FindMetaTable("Weapon")

function meta:IsEternity()
	if self.Base then
		return tobool(string.find(self.Base, "eternity"))
	end

	return false
end

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