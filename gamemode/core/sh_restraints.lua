hook.Add("PlayerSwitchWeapon", "restraints.PlayerSwitchWeapon", function(ply, old, new)
	if not ply:Restrained() then
		return
	end

	local species = ply:GetActiveSpecies()

	if ply:Restrained() and new:GetClass() != species.WeaponLoadout[1] then
		return true
	end
end)

if SERVER then
	hook.Add("PlayerRestrainedChanged", "restraints.PlayerRestrainedChanged", function(ply, old, new)
		if not new then
			return
		end

		local species = ply:GetActiveSpecies()

		ply:SelectWeapon(species.WeaponLoadout[1])
	end)

	hook.Add("PlayerUse", "restraints.PlayerUse", function(ply, ent)
		if ply:Restrained() then
			return false
		end
	end)
end