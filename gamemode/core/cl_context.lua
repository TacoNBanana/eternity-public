local meta = FindMetaTable("Player")

hook.Add("PlayerBindPress", "context.PlayerBindPress", function(ply, bind, down)
	local weapon = ply:GetActiveWeapon()

	if bind != "+menu_context" or IsValid(weapon) and weapon:GetClass() == "gmod_tool" then
		return
	end

	if down then
		ply.ContextMenu = EternityDermaMenu()

		ply:CreateSelfContext(ply.ContextMenu)
		ply:CreateVoiceContext(ply.ContextMenu)
		ply:CreateEntityContext(ply.ContextMenu)

		if ply.ContextMenu:ChildCount() > 0 and ply:IsAdmin() then
			ply.ContextMenu:AddSpacer()
		end

		ply:CreateAdminContext(ply.ContextMenu)

		if ply.ContextMenu:ChildCount() < 1 then
			ply.ContextMenu:Remove()

			return true
		end

		gui.EnableScreenClicker(true)

		ply.ContextMenu:Open()
	else
		if IsValid(ply.ContextMenu) then
			ply.ContextMenu:Remove()
		end

		gui.EnableScreenClicker(false)
	end

	return true
end)

function meta:GetContextEntity()
	local range = self:GetExamineRange()
	local origin = self:EyePos()

	local tab = ents.FindInSphere(origin, range)

	table.Filter(tab, function(key, val)
		return not val:IsDormant()
	end)

	table.sort(tab, function(a, b)
		return a:WorldSpaceCenter():DistToSqr(EyePos()) > b:WorldSpaceCenter():DistToSqr(EyePos())
	end)

	for _, v in pairs(tab) do
		if v:GetCollisionGroup() == COLLISION_GROUP_IN_VEHICLE then
			local hit = util.IntersectRayWithOBB(origin, self:EyeAngles():Forward() * range, v:GetPos(), v:GetAngles(), v:OBBMins(), v:OBBMaxs())

			if hit then
				return v
			end
		end
	end

	local ent = self:GetEyeTrace().Entity

	if not IsValid(ent) then
		return
	end

	if not ent:WithinInteractRange(self, range) then
		return
	end

	return ent
end

function meta:CreateSelfContext(pnl)
	for _, item in SortedPairs(self:GetEquipment()) do
		for _, v in pairs(item:GetContextOptions(LocalPlayer())) do
			pnl:AddOption(v.Name, function()
				if v.Client then
					coroutine.WrapFunc(function()
						local val = v.Client()

						if val then
							netstream.Send("RunItemContext", {
								ID = item.NetworkID,
								Name = v.Name,
								Value = val
							})
						end
					end)
				else
					netstream.Send("RunItemContext", {
						ID = item.NetworkID,
						Name = v.Name
					})
				end
			end)
		end
	end
end

function meta:CreateVoiceContext(pnl)
	local voicelines = self:GetActiveSpecies():GetVoicelines(LocalPlayer())

	if table.Count(voicelines) < 1 then
		return
	end

	local parent = pnl:AddSubMenu("Sounds")

	for k, v in SortedPairs(voicelines) do
		if istable(v) then
			local sub = parent:AddSubMenu(k)

			for name, snd in SortedPairs(v) do
				sub:AddOption(name, function()
					netstream.Send("PlayVoiceline", {
						Submenu = k,
						Snd = name
					})
				end)
			end
		else
			parent:AddOption(k, function()
				netstream.Send("PlayVoiceline", {
					Snd = k
				})
			end)
		end
	end
end

function meta:CreateEntityContext(pnl)
	local ent = self:GetContextEntity()

	if not IsValid(ent) then
		return
	end

	local interact = ent:WithinInteractRange(self) and not self:Restrained()

	for _, v in pairs(ent:GetOptions(self, interact)) do
		pnl:AddOption(v.Name, function()
			if v.Client then
				coroutine.WrapFunc(function()
					local val = v.Client()

					if val then
						netstream.Send("RunEntityFunction", {
							Ent = ent,
							Name = v.Name,
							Value = val
						})
					end
				end)
			else
				netstream.Send("RunEntityFunction", {
					Ent = ent,
					Name = v.Name
				})
			end
		end)
	end
end

function meta:CreateAdminContext(pnl)
	if not self:IsAdmin() then
		return
	end

	local sub = pnl:AddSubMenu("Admin")
	local categories = {}

	for _, v in pairs(self:GetAdminOptions()) do
		local parent = sub

		if v.Category then
			if not categories[v.Category] then
				categories[v.Category] = sub:AddSubMenu(v.Category)
			end

			parent = categories[v.Category]
		end

		parent:AddOption(v.Name, function()
			if v.Client then
				coroutine.WrapFunc(function()
					local val = v.Client()

					if val then
						netstream.Send("RunAdminFunction", {
							Name = v.Name,
							Value = val
						})
					end
				end)
			else
				netstream.Send("RunAdminFunction", {
					Name = v.Name
				})
			end
		end)
	end
end

function meta:CreateScoreboardContext(target)
	if not self:IsAdmin() then
		return
	end

	local dmenu = EternityDermaMenu()

	for _, v in pairs(GAMEMODE:GetConfig("ScoreboardCommands")) do
		dmenu:AddOption(v[1], function()
			gui.EnableScreenClicker(false)

			if not IsValid(target) then
				return
			end

			local cmd = isstring(v[2]) and v[2] or v[2](target)

			RunConsoleCommand(cmd, target:SteamID())
		end)
	end

	dmenu:Open()
end