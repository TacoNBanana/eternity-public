local npc = Color(213, 190, 115)

function GM:GetVISREntities(ent)
	if ent:IsNPC() and ent:Health() > 0 then
		local tab = {ent}
		local weapon = ent.GetActiveWeapon and ent:GetActiveWeapon() or false

		if IsValid(weapon) then
			table.insert(tab, weapon)
		end

		return tab, npc
	elseif ent:IsPlayer() and ent:Alive() then
		local ragdoll = ent:GetRagdoll()
		local color = GAMEMODE:GetTeamColor(ent)

		if IsValid(ragdoll) then
			return {ragdoll}, color
		end

		local vehicle = ent:GetVehicle()

		if IsValid(vehicle) then
			local lfs = vehicle.LFSBaseEnt
			local wac = vehicle.wac_seatswitcher
			local simfphys = vehicle.SPHYSBaseEnt
			local pod = ent:GetNetworkedEntity("odstpodin") -- Yes it's deprecated no it's not my problem to deal with

			local driver = not ent:GetNoDraw() and ent or nil

			if IsValid(lfs) and lfs:GetDriver() == ent then
				return {lfs, driver}, color
			elseif IsValid(wac) and wac:GetParent():getPassenger(1) == ent then
				local parent = wac:GetParent()

				return {parent, driver, parent:GetNWEntity("wac_air_rotor_main"), parent:GetNWEntity("rotor_rear")}, color
			elseif IsValid(simfphys) and simfphys:GetDriver() == ent then
				return {simfphys, driver}, color
			elseif IsValid(pod) then
				return table.Add({pod, driver}, pod:GetChildren()), color
			else
				return {vehicle, driver}, color
			end
		end

		if ent:GetNoDraw() then
			return false
		end

		local tab = {ent}
		local weapon = ent:GetActiveWeapon()

		if IsValid(weapon) then
			table.insert(tab, weapon)
		end

		return tab, color
	end

	return false
end

local overlay = CreateMaterial("ODSTOverlay", "UnlitGeneric", {
	["$basetexture"] = "models/vuthakral/halo/HUD/odst_overlay",
	["$vertexcolor"] = 1,
	["$translucent"] = 1,
	["$ignorez"] = 1
})

hook.Add("PreDrawHUD", "visr", function()
	if not LocalPlayer():VISR() or not GAMEMODE:IsFirstPerson() or not GAMEMODE:GetSetting("hud_overlay") then
		return
	end

	cam.Start2D()
		surface.SetMaterial(overlay)
		surface.SetDrawColor(255, 255, 0, 255)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	cam.End2D()
end)

hook.Add("RenderScreenspaceEffects", "visr", function()
	if not LocalPlayer():VISR() then
		return
	end

	DrawColorModify({
		["$pp_colour_addr"] = 0.1,
		["$pp_colour_addg"] = 0.1,
		["$pp_colour_addb"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_brightness"] = -0.1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	})

	DrawBloom(0.07, 0.5, 1, 1, 1, 1, 1, 1, 1)
end)

hook.Add("PreDrawOutlines", "hud", function()
	if not LocalPlayer():VISR() then
		return
	end

	local tab = {}

	table.Add(tab, player.GetAll())
	table.Add(tab, ents.FindByClass("npc_*"))

	for _, v in pairs(tab) do
		if not IsValid(v) then
			continue
		end

		if v:IsDormant() then
			continue
		end

		local entities, color = GAMEMODE:GetVISREntities(v)

		if not entities then
			continue
		end

		for _, ent in pairs(entities) do
			local parts = part.Get(ent)

			if parts then
				for _, data in pairs() do
					if IsValid(data.Ent) then
						table.insert(entities, data.Ent)
					end
				end
			end
		end

		outline.Add(entities, color, OUTLINE_MODE_VISIBLE)
	end
end)