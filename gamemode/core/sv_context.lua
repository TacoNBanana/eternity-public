netstream.Hook("RunEntityFunction", function(ply, data)
	local ent = data.Ent
	local name = data.Name
	local val = data.Value

	if not IsValid(ent) then
		return
	end

	local interact = ent:WithinInteractRange(ply) and not ply:Restrained()

	for _, v in pairs(ent:GetOptions(ply, interact)) do
		if v.Name == tostring(name) then
			v.Callback(val)
		end
	end
end, {
	Ent = {Type = TYPE_ENTITY},
	Name = {Type = TYPE_STRING},
	Value = {Type = true, Optional = true}
})

netstream.Hook("RunAdminFunction", function(ply, data)
	local name = data.Name
	local val = data.Value

	for _, v in pairs(ply:GetAdminOptions()) do
		if v.Name == tostring(name) then
			v.Callback(val)
		end
	end
end, {
	Name = {Type = TYPE_STRING},
	Value = {Type = true, Optional = true}
})

netstream.Hook("PlayVoiceline", function(ply, data)
	local voicelines = ply:GetActiveSpecies():GetVoicelines(ply)

	if data.Submenu then
		voicelines = voicelines[data.Submenu]
	end

	if not voicelines then
		return
	end

	local snd = voicelines[data.Snd]

	if snd then
		ply:EmitSound(snd)
	end
end, {
	Submenu = {Type = TYPE_STRING, Optional = true},
	Snd = {Type = TYPE_STRING}
})