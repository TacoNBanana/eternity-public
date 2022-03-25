local meta = FindMetaTable("Player")

function meta:IsInEditMode()
	if not self:IsAdmin() then
		return false
	end

	return self:EditMode()
end

function meta:IsAdmin()
	return self:AdminLevel() >= USERGROUP_ADMIN
end

function meta:IsSuperAdmin()
	return self:AdminLevel() >= USERGROUP_SUPERADMIN
end

function meta:IsDeveloper()
	return self:AdminLevel() == USERGROUP_DEV
end

function meta:IsInNoClip()
	return self:IsEFlagSet(EFL_NOCLIP_ACTIVE)
end

function GM:PlayerNoClip(ply, on)
	if ply:ShouldLockInput() then
		return false
	end

	local weapon = ply:GetActiveWeapon()

	if not on then
		ply:SetNoDraw(false)
		ply:SetNotSolid(false)

		if IsValid(weapon) then
			weapon:SetNoDraw(false)
		end

		if SERVER then
			ply:SetNoTarget(false)
		end

		return true
	elseif ply:IsAdmin() then
		ply:SetNoDraw(true)
		ply:SetNotSolid(true)

		if IsValid(weapon) then
			weapon:SetNoDraw(true)
		end

		if SERVER then
			ply:SetNoTarget(true)
		end

		return true
	end

	return false
end

if SERVER then
	hook.Add("PlayerAdminLevelChanged", "admin.PlayerAdminLevelChanged", function(ply, old, new)
		if new == USERGROUP_PLAYER then
			ply:SetUserGroup("user")
		elseif new == USERGROUP_ADMIN then
			ply:SetUserGroup("admin")
		elseif new == USERGROUP_SUPERADMIN or USERGROUP_DEV then
			ply:SetUserGroup("superadmin")
		end
	end)
end