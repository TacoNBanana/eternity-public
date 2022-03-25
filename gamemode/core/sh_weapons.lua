local meta = FindMetaTable("Player")

function meta:ToggleHolster()
	if self:ShouldLockInput() then
		return
	end

	local weapon = self:GetActiveWeapon()

	if IsValid(weapon) and weapon.ToggleHolster then
		weapon:ToggleHolster()
	end
end

if SERVER then
	netstream.Hook("ToggleHolster", function(ply, data)
		ply:ToggleHolster()
	end)
end