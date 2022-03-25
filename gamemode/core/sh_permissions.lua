local meta = FindMetaTable("Player")

function GM:HasPermission(permissions, perm)
	return tobool(bit.band(permissions, 2^(perm - 1)))
end

function meta:HasPermission(perm)
	return GAMEMODE:HasPermission(self:Permissions(), perm)
end

if SERVER then
	function meta:GivePermission(perm)
		if self:HasPermission(perm) then
			return
		end

		self:SetPermissions(self:Permissions() + 2^(perm - 1))
	end

	function meta:TakePermission(perm)
		if not self:HasPermission(perm) then
			return
		end

		self:SetPermissions(self:Permissions() - 2^(perm - 1))
	end
end