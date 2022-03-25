local meta = FindMetaTable("Player")

function GM:HasPermission(permissions, perm)
	return tobool(bit.band(permissions, 2^(perm - 1)))
end

function meta:HasPermission(perm)
	local id = self:GetEquipment(EQUIPMENT_ID)

	if not id or id.Invalid then
		return false
	end

	if id.Permissions == -1 then
		return true
	end

	return GAMEMODE:HasPermission(id.Permissions, perm)
end

function GM:GenerateCID(seed)
	if seed then
		math.randomseed(seed)
	end

	local str = ""

	for i = 1, 5 do
		str = str .. math.random(0, 9)
	end

	return str
end