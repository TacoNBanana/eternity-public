local meta = FindMetaTable("Player")

function meta:ClearCamera(ui)
	self:SetCamera(false)

	if ui then
		self:OpenGUI("SurveillanceMenu")
	end
end

netstream.Hook("ActivateSurveillance", function(ply, data)
	local ent = data.Ent

	if not IsValid(ent) then
		return
	end

	if ent:IsPlayer() and not ent:IsCameraTarget(ply) then
		return
	end

	ply:SetCamera(ent)
end, {
	Ent = {Type = TYPE_ENTITY}
})

netstream.Hook("ResetSurveillance", function(ply, data)
	ply:ClearCamera(true)
end)

hook.Add("PlayerThink", "camera.PlayerThink", function(ply)
	local camera = ply:Camera()

	if not IsValid(camera) then
		return
	end

	if camera:IsPlayer() and not camera:IsCameraTarget(ply) then
		ply:ClearCamera(true)

		return
	end
end)

hook.Add("SetupPlayerVisibility", "camera.SetupPlayerVisibility", function(ply, viewent)
	local camera = ply:Camera()

	if not IsValid(camera) then
		return
	end

	AddOriginToPVS(camera:GetCameraPos())
end)

hook.Add("EntityTakeDamage", "camera.EntityTakeDamage", function(ent, dmg)
	if ent:IsPlayer() and ent:IsInCamera() then
		ent:ClearCamera(false)

		return
	end
end)