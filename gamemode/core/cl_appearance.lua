hook.Add("PlayerModelDataChanged", "appearance.PlayerModelDataChanged", function(ply, old, new)
	part.Clear(ply)

	for k, v in pairs(new) do
		if k != "_base" then
			part.Add(ply, k, v)
		end
	end

	if new._base then
		ply:ApplyModel(new._base)
	end
end)

hook.Add("CreateClientsideRagdoll", "appearance.CreateClientsideRagdoll", function(ent, ragdoll)
	if not ent:IsPlayer() then
		return
	end

	local data = ent:ModelData()

	if data._base then
		ragdoll:ApplyModel(data._base)
	end
end)