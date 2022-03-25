GM.HUDCache = {}

language.Add("npc_clawscanner", "Claw Scanner")
language.Add("npc_combine_camera", "Combine Camera")
language.Add("npc_helicopter", "Helicopter")
language.Add("npc_fisherman", "Fisherman")

local matBlurScreen = Material("pp/blurscreen")

function draw.BackgroundBlur(frac)
	DisableClipping(true)

	surface.SetMaterial(matBlurScreen)
	surface.SetDrawColor(255, 255, 255, 255)

	for i = 1, 3 do
		matBlurScreen:SetFloat("$blur", frac * 5 * (i / 3))
		matBlurScreen:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	DisableClipping(false)
end

function GM:IsFirstPerson()
	local lp = LocalPlayer()

	if lp:GetViewEntity() != lp then
		return false
	end

	return not ctp:IsEnabled()
end

hook.Add("HUDPaint", "hud.HUDPaint", function()
	if GAMEMODE:GetSetting("hud_enabled") then
		local colors = GAMEMODE:GetConfig("UIColors")
		local config = GAMEMODE:GetConfig("HUDData")
		local cache = GAMEMODE.HUDCache

		GAMEMODE:HandleHUDCache(config, cache)

		for _, v in pairs(GAMEMODE.HUDSections) do
			if not v.Setting or GAMEMODE:HUDEnabled(v.Setting, v.Editmode) then
				v.Callback(colors, config, cache)
			end
		end
	end

	local ply = LocalPlayer()
	local val = ply:Consciousness()
	local ragdoll = ply:GetRagdoll()
	local fraction = val / 75

	local colors = GAMEMODE:GetConfig("UIColors")

	if IsValid(ragdoll) or val == 0 then
		draw.BackgroundBlur(1)

		local text = ply:Alive() and "You've been knocked out." or "You've died."
		local w = ScrW() / 2
		local h = ScrH() / 2

		draw.DrawText(text, "eternity.labelgiant", w, ScrH() / 2, colors.TextNormal, 1)

		surface.SetDrawColor(ColorAlpha(colors.FillDark, 150))
		surface.DrawRect(w - 200, ScrH() / 2 + 40, 400, 40)

		surface.SetDrawColor(ColorAlpha(colors.Border, 100))
		surface.DrawOutlinedRect(w - 200, h + 40, 400, 40)

		surface.SetDrawColor(colors.Primary)
		surface.DrawRect(w - 200 + 1, h + 40 + 1, (400 - 2) * math.min(val / 100, 1), 40 - 2)

		local progress = (IsValid(ragdoll) and ragdoll:GetVelocity():Length() > 15) and "You're being moved." or string.format("%s%%", val)

		draw.DrawText(progress, "eternity.labelbig", w, h + 1 + 40 + draw.GetFontHeight("eternity.labelbig") / 2, colors.TextNormal, 1)
	elseif fraction < 1 then
		draw.BackgroundBlur(1 - fraction)
	end
end)

hook.Add("Think", "hud.Think", function()
	local setting = GAMEMODE:GetSetting("hud_thirdperson")

	if setting != ctp:IsEnabled() then
		ctp:Toggle()
	end
end)

GM.DisabledHUDElements = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = true,
	["CHudHistoryResource"] = true,
	["CHUDAutoAim"] = true,
	["CHudDamageIndicator"] = true
}

GM.HUDSections = {}

function GM:RegisterHUDSection(setting, callback, editmode)
	table.insert(self.HUDSections, {
		Setting = setting,
		Callback = callback,
		Editmode = editmode or false
	})
end

function GM:DrawHUDBox(text, x, y, horizontal, vertical, colors, config)
	local w, h = text:GetSize()
	local margin = config.Margin * 2

	surface.SetDrawColor(ColorAlpha(colors.FillDark, 200))
	surface.DrawRect(x - config.Margin, y - config.Margin, w + margin, h + margin)

	text:Draw(x, y, horizontal, vertical)
end

function GM:HandleHUDCache(config, cache)
	cache.HP = cache.HP or 1
	cache.LeftOffset = config.Offset
	cache.RightOffset = config.Offset

	local eye = EyePos()

	for _, v in pairs(player.GetAll()) do
		v.HUDDistance = v:GetPos():DistToSqr(eye)

		if v == LocalPlayer() then
			continue
		end

		v.HUDAlpha = v.HUDAlpha or 0

		if v:GetNoDraw() then
			v.HUDAlpha = 0
		end

		if GAMEMODE:GetSetting("hud_legacy") then
			if not v.HUDSeen then
				v.HUDAlpha = math.Clamp(v.HUDAlpha - FrameTime(), 0, 1)
			end

			v.HUDSeen = false
		else
			v.HUDFade = v.HUDFade or 0

			if v.HUDFade < CurTime() then
				v.HUDAlpha = math.Clamp(v.HUDAlpha - FrameTime(), 0, 1)
			end
		end
	end
end

function GM:HUDEnabled(part, editmode)
	if not LocalPlayer():HasCharacter() then
		return false
	end

	if LocalPlayer():IsInCamera() then
		return false
	end

	if not part then
		return true
	end

	if editmode and LocalPlayer():IsInEditMode() then
		return true
	end

	return self:GetSetting("hud_enabled") and self:GetSetting("hud_" .. part) or false
end

function GM:DrawWorldText(pos, text, noz)
	local ang = (pos - EyePos()):Angle()

	cam.Start3D2D(pos, Angle(0, ang.y - 90, 90), 0.25)
		if noz then
			render.DepthRange(0, 0)
		end

		render.PushFilterMag(TEXFILTER.NONE)
		render.PushFilterMin(TEXFILTER.NONE)
			surface.SetFont("BudgetLabel")

			local w, h = surface.GetTextSize(text)

			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(-w * 0.5, -h * 0.5)

			surface.DrawText(text)
		render.PopFilterMin()
		render.PopFilterMag()

		if noz then
			render.DepthRange(0, 1)
		end
	cam.End3D2D()
end

function GM:DrawWorldLabel(text, x, y, fraction, colors)
	local w, h = text:GetSize()

	if self:GetSetting("ui_worldlabels") then
		surface.SetDrawColor(ColorAlpha(colors.FillDark, 230 * fraction))
		surface.DrawRect(x - (w * 0.5) - 1, y - h, w + 2, h)
	end

	text:Draw(x, y - h, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 255 * fraction)
end

function GM:DrawScaleText(text, x, y, color, font, scale)
	render.PushFilterMag(TEXFILTER.NONE)
	render.PushFilterMin(TEXFILTER.NONE)

	surface.SetFont(font)

	local w, h = surface.GetTextSize(text)

	w = w * scale
	h = h * scale

	x = x - (w / 2)
	y = y - (h / 2)

	local mat = Matrix()

	mat:SetScale(Vector(1, 1, 1) * scale)
	mat:SetTranslation(Vector(x, y, 0))

	cam.PushModelMatrix(mat)
		surface.SetTextPos(3, 3)
		surface.SetTextColor(Color(0, 0, 0))
		surface.DrawText(text)

		surface.SetTextPos(0, 0)
		surface.SetTextColor(color)
		surface.DrawText(text)
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end

GM:RegisterHUDSection("sandbox", function(colors, config, cache)
	if LocalPlayer():InVehicle() then
		return
	end

	local weapon = LocalPlayer():GetActiveWeapon()

	if IsValid(weapon) and weapon:GetClass() == "weapon_physgun" then
		local str

		if LocalPlayer():IsAdmin() then
			str = string.format("<font=eternity.labelgiant><ol>Props: %s\nRagdolls: %s\nEffects: %s",
				LocalPlayer():GetCount("props"),
				LocalPlayer():GetCount("ragdolls"),
				LocalPlayer():GetCount("effects")
			)
		else
			str = string.format("<font=eternity.labelgiant><ol>Props: %s/%s\nRagdolls: %s/%s\nEffects: %s/%s",
				LocalPlayer():GetCount("props"), LocalPlayer():GetSandboxLimit("props"),
				LocalPlayer():GetCount("ragdolls"), LocalPlayer():GetSandboxLimit("ragdolls"),
				LocalPlayer():GetCount("effects"), LocalPlayer():GetSandboxLimit("effects")
			)
		end

		local text = markleft.Parse(str)

		local x = ScrW() - config.Offset - text:GetWidth()
		local y = ScrH() - config.Offset - text:GetHeight()

		GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, colors, config)
	end
end)

GM:RegisterHUDSection("ammo", function(colors, config, cache)
	if LocalPlayer():InVehicle() then
		return
	end

	local weapon = LocalPlayer():GetActiveWeapon()

	if IsValid(weapon) and weapon.Base == "eternity_firearm_base" then
		local str = weapon:GetFiremode():GetAmmoDisplay()

		if not str then
			return
		end

		local text = markleft.Parse(str)

		local x = ScrW() - config.Offset - text:GetWidth()
		local y = ScrH() - cache.RightOffset - text:GetHeight()

		GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, colors, config)

		cache.RightOffset = cache.RightOffset + text:GetHeight() + (config.Margin * 2)
	end
end)

GM:RegisterHUDSection("firemode", function(colors, config, cache)
	if LocalPlayer():InVehicle() then
		return
	end

	local weapon = LocalPlayer():GetActiveWeapon()

	if IsValid(weapon) and weapon.Base == "eternity_firearm_base" then
		local str = weapon:GetFiremode():GetFiremodeDisplay()

		if not str then
			return
		end

		local text = markleft.Parse(str)

		local x = ScrW() - config.Offset - text:GetWidth()
		local y = ScrH() - cache.RightOffset - text:GetHeight()

		GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, colors, config)
	end
end)

GM:RegisterHUDSection("infobox", function(colors, config, cache)
	local str = string.format("<font=eternity.labelgiant><ol>%s\n%s", LocalPlayer():RPName(), team.GetName(LocalPlayer():Team()))
	local text = markleft.Parse(str)

	text.Width = math.Max(text:GetWidth(), 220)

	local x = config.Offset
	local y = ScrH() - cache.LeftOffset - text:GetHeight()

	GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, colors, config)

	cache.LeftOffset = cache.LeftOffset + text:GetHeight() + (config.Margin * 2) + 5
end)

GM:RegisterHUDSection("healthbar", function(colors, config, cache)
	local style = GAMEMODE:GetSetting("hud_healthstyle")

	if style == HPTYPE_BAR then
		local percentage = math.Clamp(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0, 1)

		cache.HP = math.Approach(cache.HP, percentage, FrameTime())

		local w = 220
		local h = 14

		local y = ScrH() - cache.LeftOffset - h

		local margin = config.Margin * 2

		surface.SetDrawColor(ColorAlpha(colors.FillDark, 200))
		surface.DrawRect(config.Offset - config.Margin, y + config.Margin, w + margin, h)

		surface.SetDrawColor(colors.Primary)
		surface.DrawRect(config.Offset, y + margin, w * cache.HP, h - margin)
	elseif style == HPTYPE_HEARTBEAT then
		local w = 220
		local h = 50

		local y = ScrH() - cache.LeftOffset - h

		local margin = config.Margin * 2

		surface.SetDrawColor(ColorAlpha(colors.FillDark, 200))
		surface.DrawRect(config.Offset - config.Margin, y + config.Margin, w + margin, h)

		heartbeat.Draw(LocalPlayer(), config.Offset, y + margin, w, h - margin)
	end
end)

GM:RegisterHUDSection("items", function(colors, config, cache)
	if GAMEMODE:GetSetting("hud_itemstyle") == ITEMTYPE_GLOW then
		return
	end

	local items = ents.FindByClass("ent_item")

	table.sort(items, function(a, b)
		return a:GetPos():DistToSqr(EyePos()) > b:GetPos():DistToSqr(EyePos())
	end)

	for _, v in pairs(items) do
		if v:IsDormant() then
			continue
		end

		if not v.VisFraction or v.VisFraction <= 0 then
			continue
		end

		local item = v:GetItem()

		if item then
			local text = markleft.Parse(string.format("<font=eternity.player><ol><icolor=%s>%s", item.NetworkID, item:GetName()))
			local pos = v:WorldSpaceCenter():ToScreen()

			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)

			GAMEMODE:DrawWorldLabel(text, pos.x, pos.y + (text:GetHeight() * 0.5), v.VisFraction, colors)
		end
	end
end)

local modelblacklist = {
	["models/zombie/fast.mdl"] = true
}

GM:RegisterHUDSection(nil, function(colors, config, cache)
	if GAMEMODE:GetSetting("seeall_enabled") then
		return
	end

	local range = LocalPlayer():GetExamineRange(true)

	local configs = GAMEMODE:GetConfig("PlayerLabel")
	local players = player.GetAll()

	table.Filter(players, function(key, val)
		if val == LocalPlayer() then
			return false
		end

		if val:IsDormant() or val:GetNoDraw() then
			return false
		end

		return true
	end)

	if GAMEMODE:GetSetting("hud_legacy") then
		for _, v in pairs(players) do
			if v.HUDDistance <= (range * range) and LocalPlayer():CanSee(v) then
				v.HUDAlpha = math.Clamp(v.HUDAlpha + FrameTime(), 0, 1)
				v.HUDSeen = true
			end
		end
	else
		local tr = LocalPlayer():GetEyeTrace()
		local ent = tr.Entity

		if IsValid(ent) and ent:IsPlayer() and not ent:GetNoDraw() and ent.HUDDistance <= (range * range) then
			ent.HUDAlpha = math.Clamp(ent.HUDAlpha + FrameTime(), 0, 1)
			ent.HUDFade = CurTime() + FrameTime() + configs.Fade
		end
	end

	table.sort(players, function(a, b)
		return a.HUDDistance > b.HUDDistance
	end)

	for _, ply in pairs(players) do
		local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
		local pos

		if bone and not ply:IsInNoClip() and not modelblacklist[string.lower(ply:GetModel())] then
			pos = ply:GetBonePosition(bone) + Vector(0, 0, 9)
		else
			local _, maxs = ply:GetModelBounds()

			pos = ply:GetPos() + Vector(0, 0, maxs.z)
		end

		local screen = pos:ToScreen()

		screen.x = math.Round(screen.x)
		screen.y = math.Round(screen.y)

		if GAMEMODE:GetSetting("hud_typing") and ply:Typing() != 0 and ply.HUDDistance <= (range * range) and LocalPlayer():CanSee(ply) then
			local typing = markleft.Parse(string.format("<font=eternity.labelsmall><i><ol>%s", CHATINDICATORS[ply:Typing()]))

			GAMEMODE:DrawWorldLabel(typing, screen.x, screen.y, 1, colors)

			screen.y = screen.y - typing:GetHeight()
		end

		if ply.HUDAlpha <= 0 then
			continue
		end

		if GAMEMODE:GetSetting("hud_restrained") and ply:Restrained() then
			local restrained = markleft.Parse("<font=eternity.labelsmall><ol>They're tied up")

			GAMEMODE:DrawWorldLabel(restrained, screen.x, screen.y, ply.HUDAlpha, colors)

			screen.y = screen.y - restrained:GetHeight()
		end

		local desc = string.match(ply:Description(), "^[^\r\n]*")

		if GAMEMODE:GetSetting("hud_descriptions") and #desc > 0 then
			if #desc > configs.Desc then
				desc = string.sub(desc, 1, configs.Desc) .. "..."
			end

			desc = markleft.Parse(string.format("<font=eternity.player><ol>%s", desc))

			GAMEMODE:DrawWorldLabel(desc, screen.x, screen.y, ply.HUDAlpha, colors)

			screen.y = screen.y - desc:GetHeight()
		end

		if GAMEMODE:GetSetting("hud_playernames") then
			local name = markleft.Parse(string.format("<font=eternity.player><ol><tc=%s>%s", ply:UserID(), ply:RPName()))

			GAMEMODE:DrawWorldLabel(name, screen.x, screen.y, ply.HUDAlpha, colors)
		end
	end
end)

GM:RegisterHUDSection(nil, function(colors, config, cache)
	if not GAMEMODE:GetSetting("seeall_enabled") then
		return
	end

	if GAMEMODE:GetSetting("seeall_players") then
		local players = player.GetAll()

		table.sort(players, function(a, b)
			return a.HUDDistance > b.HUDDistance
		end)

		for _, v in pairs(players) do
			if v == LocalPlayer() then
				local should = LocalPlayer():ShouldDrawLocalPlayer()

				if not should or (should and ctp:IsEnabled()) then
					continue
				end
			end

			local bone = v:LookupBone("ValveBiped.Bip01_Head1")
			local pos

			if bone and not v:IsInNoClip() and not modelblacklist[string.lower(v:GetModel())] then
				pos = v:GetBonePosition(bone) + Vector(0, 0, 9)
			else
				local _, maxs = v:GetModelBounds()

				pos = v:GetPos() + Vector(0, 0, maxs.z)
			end

			local screen = pos:ToScreen()

			screen.x = math.Round(screen.x)
			screen.y = math.Round(screen.y)

			if GAMEMODE:GetSetting("seeall_players_hp") then
				local health = markleft.Parse(string.format("<font=eternity.player><ol><col=200,0,0>%s%%", v:Health()))

				GAMEMODE:DrawWorldLabel(health, screen.x, screen.y, 255, colors)

				screen.y = screen.y - health:GetHeight()
			end

			if GAMEMODE:GetSetting("hud_typing") and v:Typing() != 0 then
				local typing = markleft.Parse(string.format("<font=eternity.labelsmall><i><ol>%s", CHATINDICATORS[v:Typing()]))

				GAMEMODE:DrawWorldLabel(typing, screen.x, screen.y, 255, colors)

				screen.y = screen.y - typing:GetHeight()
			end

			if GAMEMODE:GetSetting("seeall_players_restrained") and v:Restrained() then
				local restrained = markleft.Parse("<font=eternity.labelsmall><ol>They're tied up")

				GAMEMODE:DrawWorldLabel(restrained, screen.x, screen.y, 255, colors)

				screen.y = screen.y - restrained:GetHeight()
			end

			if GAMEMODE:GetSetting("seeall_players_nick") then
				local nick = markleft.Parse(string.format("<font=eternity.player><ol><col=87,165,255>%s", v:Nick()))

				GAMEMODE:DrawWorldLabel(nick, screen.x, screen.y, 255, colors)

				screen.y = screen.y - nick:GetHeight()
			end

			if GAMEMODE:GetSetting("seeall_players_identity") and v:RPName() != v:RPName() then
				local color = team.GetColor(v:GetActiveSpecies().Team)
				local name = markleft.Parse(string.format("<font=eternity.player><ol><col=%s>%s", util.ColorToChat(color), v:RPName()))

				GAMEMODE:DrawWorldLabel(name, screen.x, screen.y, 255, colors)

				screen.y = screen.y - name:GetHeight()
			end

			local name = markleft.Parse(string.format("<font=eternity.player><ol><tc=%s>%s", v:UserID(), v:RPName()))

			GAMEMODE:DrawWorldLabel(name, screen.x, screen.y, 255, colors)
		end
	end

	if GAMEMODE:GetSetting("seeall_items") then
		local items = ents.FindByClass("ent_item")

		table.sort(items, function(a, b)
			return a:GetPos():DistToSqr(EyePos()) > b:GetPos():DistToSqr(EyePos())
		end)

		for _, v in pairs(items) do
			local item = v:GetItem()

			if item then
				local text = markleft.Parse(string.format("<font=eternity.player><ol><icolor=%s>%s", item.NetworkID, item:GetName()))
				local pos = v:WorldSpaceCenter():ToScreen()

				pos.x = math.Round(pos.x)
				pos.y = math.Round(pos.y)

				GAMEMODE:DrawWorldLabel(text, pos.x, pos.y + (text:GetHeight() * 0.5), 255, colors)
			end
		end
	end

	if GAMEMODE:GetSetting("seeall_npcs") then
		local npcs = ents.GetAll()

		npcs = table.Filter(npcs, function(key, val)
			return IsValid(val) and val:IsNPC()
		end)

		table.sort(npcs, function(a, b)
			return a:GetPos():DistToSqr(EyePos()) > b:GetPos():DistToSqr(EyePos())
		end)

		for _, v in pairs(npcs) do
			if v:Health() <= 0 then
				continue
			end

			local text = markleft.Parse(string.format("<font=eternity.player><ol><col=255,255,100>#%s", v:GetClass()))
			local pos = (v:EyePos() + Vector(0, 0, 5)):ToScreen()

			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)

			GAMEMODE:DrawWorldLabel(text, pos.x, pos.y, 255, colors)
		end
	end
end)

GM.PropCache = GM.PropCache or {}

hook.Add("EntitySteamIDChanged", "hud.EntitySteamIDChanged", function(ent, old, new)
	GAMEMODE.PropCache[ent] = true
end)

GM:RegisterHUDSection("propowner", function(colors, config, cache)
	local tab = {}
	local range = GAMEMODE:GetConfig("EntityRange")

	local weapon = LocalPlayer():GetActiveWeapon()

	if not IsValid(weapon) or (weapon:GetClass() != "weapon_physgun" and weapon:GetClass() != "gmod_tool") then
		return
	end

	for k in pairs(GAMEMODE.PropCache) do
		if not IsValid(k) then
			continue
		end

		if not k:SteamID() then
			continue
		end

		if k:WorldSpaceCenter():Distance(EyePos()) > range.Max or k:GetVisible() <= 0 then
			continue
		end

		table.insert(tab, k)
	end

	table.sort(tab, function(a, b)
		return a:WorldSpaceCenter():DistToSqr(EyePos()) > b:WorldSpaceCenter():DistToSqr(EyePos())
	end)

	local setting = GAMEMODE:GetSetting("hud_propmode")

	for _, v in pairs(tab) do
		local alpha = math.ClampedRemap(EyePos():Distance(v:WorldSpaceCenter()), range.Max, range.Min, 0, 1) * v:GetVisible()
		local pos = v:WorldSpaceCenter() + Vector(0, 0, 10)
		local screen = pos:ToScreen()

		screen.x = math.Round(screen.x)
		screen.y = math.Round(screen.y)

		if setting == PROPOWNER_STEAMID or setting == PROPOWNER_BOTH then
			local steamid = markleft.Parse(string.format("<font=eternity.labelsmall><ol><col=200,200,200>%s", v:SteamID()))

			GAMEMODE:DrawWorldLabel(steamid, screen.x, screen.y, alpha, colors)

			screen.y = screen.y - steamid:GetHeight()
		end

		if setting == PROPOWNER_NAME or setting == PROPOWNER_BOTH then
			local name = markleft.Parse(string.format("<font=eternity.player><ol><col=200,200,200>%s", v:PlayerName()))

			GAMEMODE:DrawWorldLabel(name, screen.x, screen.y, alpha, colors)
		end
	end
end)

GM:RegisterHUDSection("propdescs", function(colors, config, cache)
	local tab = {}
	local range = GAMEMODE:GetConfig("EntityRange")

	for k in pairs(GAMEMODE.PropCache) do
		if not IsValid(k) then
			continue
		end

		if not k:Description() then
			continue
		end

		if k:WorldSpaceCenter():Distance(EyePos()) > range.Max or k:GetVisible() <= 0 then
			continue
		end

		table.insert(tab, k)
	end

	table.sort(tab, function(a, b)
		return a:WorldSpaceCenter():DistToSqr(EyePos()) > b:WorldSpaceCenter():DistToSqr(EyePos())
	end)

	for _, v in pairs(tab) do
		local alpha = math.ClampedRemap(EyePos():Distance(v:WorldSpaceCenter()), range.Max, range.Min, 0, 1) * v:GetVisible()
		local pos = v:WorldSpaceCenter()
		local screen = pos:ToScreen()

		screen.x = math.Round(screen.x)
		screen.y = math.Round(screen.y)

		if v:Description() then
			local description = markleft.Parse(string.format("<font=eternity.player><ol>%s", v:Description()), ScrW() / 4)

			GAMEMODE:DrawWorldLabel(description, screen.x, screen.y, alpha, colors)
		end
	end
end)

GM:RegisterHUDSection("squad", function(colors, config, cache)
	local name = LocalPlayer():Squad()

	if name == "" then
		return
	end

	local str = "<font=eternity.labelgiant><ol>"
	local leader = GAMEMODE:GetSquadLeader(name)

	if IsValid(leader) then
		str = str .. "<col=0,255,0>" .. leader:RPName() .. "</col>"
	end

	local tab = GAMEMODE:GetSquadMembers(name)

	table.sort(tab, function(a, b)
		return a:RPName() < b:RPName()
	end)

	for _, v in pairs(tab) do
		if v == leader then
			continue
		end

		local lp = v == LocalPlayer()

		local col1 = lp and "<col=255,255,0>" or ""
		local col2 = lp and "</col>" or ""

		str = str .. "\n" .. col1 .. v:RPName() .. col2
	end

	local text = markleft.Parse(str)

	GAMEMODE:DrawHUDBox(text, config.Offset, config.Offset, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, colors, config)
end)

hook.Add("PostRenderVGUI", "hud.PostRenderVGUI", function()
	local data = GAMEMODE.Progress

	if not data then
		return
	end

	if CurTime() > data.EndTime then
		GAMEMODE.Progress = nil

		return
	end

	local colors = GAMEMODE:GetConfig("UIColors")

	local fraction = math.ClampedRemap(CurTime(), data.StartTime, data.EndTime, 0, 1)
	local w = 400
	local h = 40
	local x = (ScrW() / 2) - (w * 0.5)
	local y = (ScrH() / 2) + h

	surface.SetDrawColor(ColorAlpha(colors.FillDark, 200))
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(colors.Primary)
	surface.DrawRect(x + 1, y + 1, fraction * (w - 2), h - 2)

	local text = markleft.Parse(string.format("<font=eternity.labelbig><ol>%s", data.Text), w - 10)

	text:Draw(x + (w * 0.5), y + (h * 0.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 255)
end)

GM:RegisterHUDSection(nil, function(colors, config, cache)
	if not LocalPlayer():Restrained() then
		return
	end

	local text = markleft.Parse("<font=eternity.labelgiant><ol>You're tied up.")

	local x = ScrW() - config.Offset - text:GetWidth()
	local y = ScrH() - cache.RightOffset - text:GetHeight()

	GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, colors, config)

	cache.RightOffset = cache.RightOffset + text:GetHeight() + (config.Margin * 2)
end)

GM:RegisterHUDSection("vehicle", function(colors, config, cache)
	local ply = LocalPlayer()
	local apc = ply:APC()

	if not IsValid(apc) or not ply:InVehicle() then
		return
	end

	if ply != apc:GetDriver() and ply != apc:GetGunner() then
		if apc:GetHatchLocked() then
			draw.BackgroundBlur(1)
			draw.SimpleText("You are inside the APC. The hatch is locked.", "eternity.labelmassive", ScrW() / 2, ScrH() * 0.75, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		return
	end

	local str = string.format("<font=eternity.labelgiant><ol>Armor:   \t%04.2f%%\nEngine:     %s\nVelocity: \t%.0f mph\nHatch:    \t%s\nSiren:     \t%s",
		apc:GetAPCHealth() / apc.MaxHealth * 100,
		not apc:GetActive() and "Off" or apc:GetSlowMode() and "Low" or "High",
		apc:GetDriverSeat():GetVelocity():Length() * (15 / 352),
		apc:GetHatchLocked() and "Locked" or "Open",
		apc:GetSirenActive() and (apc:GetNextAlarm() != -1 and "Alarm!" or "On") or "Off")

	local text = markleft.Parse(str)

	local x = ScrW() - config.Offset - text:GetWidth()
	local y = ScrH() - config.Offset - text:GetHeight()

	GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, colors, config)

	local passengers = ""
	for _, v in pairs(apc.Passengers) do
		if not IsValid(v) then
			continue
		end

		passengers = string.format("%s\n\t\t%s", passengers, v:RPName())
	end

	local occupants = string.format("<font=eternity.labelgiant><ol>Driver: %s\nGunner: %s%s",
		IsValid(apc:GetDriver()) and apc:GetDriver():RPName() or "&lt;Empty&gt;",
		IsValid(apc:GetGunner()) and apc:GetGunner():RPName() or "&lt;Empty&gt;",
		#passengers > 0 and string.format("\nPassengers:%s", passengers) or "")

	text = markleft.Parse(occupants)

	x = ScrW() - config.Offset - text:GetWidth()
	y = config.Offset

	GAMEMODE:DrawHUDBox(text, x, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, colors, config)

	if ply == apc:GetGunner() then
		local driverSeat = apc:GetDriverSeat()
		local att = driverSeat:GetAttachment(driverSeat:LookupAttachment("muzzle"))

		local pos = att.Pos - 5 * att.Ang:Forward() - att.Ang:Up() * 6

		local p = util.TraceLine({
			start = pos,
			endpos = pos + att.Ang:Forward() * 16384,
			filter = {driverSeat},
			mask = MASK_SHOT
		}).HitPos:ToScreen()

		local spread = (apc.PrimarySpread * 360) * (90 / math.Clamp(GetConVar("fov_desired"):GetInt(), 75, 90))

		surface.SetDrawColor(0, 0, 0, 255 * 0.75) -- background

		surface.DrawRect(p.x - 13 - spread, p.y - 1, 12, 3) -- left
		surface.DrawRect(p.x + 3 + spread, p.y - 1, 12, 3) -- right
		surface.DrawRect(p.x - 1, p.y - 13 - spread, 3, 12) -- up
		surface.DrawRect(p.x - 1, p.y + 3 + spread, 3, 12) -- down

		surface.SetDrawColor(255, 255, 255, 255) -- Foreground

		surface.DrawRect(p.x - 12 - spread, p.y, 10, 1) -- left
		surface.DrawRect(p.x + 4 + spread, p.y, 10, 1) -- right
		surface.DrawRect(p.x, p.y - 12 - spread, 1, 10) -- up
		surface.DrawRect(p.x, p.y + 4 + spread, 1, 10) -- down
	end
end)

function GM:PreDrawHalos()
	local colors = {}

	local function add(ent, color)
		local str = tostring(color)

		if not colors[str] then
			colors[str] = {}
		end

		table.insert(colors[str], ent)
	end

	if self:GetSetting("seeall_enabled") then
		local setting = self:GetSetting("seeall_props")
		local weapon = LocalPlayer():GetActiveWeapon()

		if (setting == SEEALL_PROPS_PHYS and IsValid(weapon) and (weapon:GetClass() == "weapon_physgun" or weapon:GetClass() == "gmod_tool")) or setting == SEEALL_PROPS_ALWAYS then
			for k in pairs(self.PropCache) do
				if not IsValid(k) then
					continue
				end

				if not k:PermaProp() then
					continue
				end

				if k:GetClass() == "prop_effect" then
					add(k.AttachedEntity, Color(255, 0, 255))
				else
					add(k, Color(255, 0, 255))
				end
			end
		end
	end

	for color, tab in pairs(colors) do
		halo.Add(tab, string.ToColor(color), 1, 1, 1, true, false)
	end
end

function GM:HUDDrawTargetID()
end

function GM:HUDDrawPickupHistory()
end

function GM:DrawDeathNotice()
end

function GM:HUDShouldDraw(hud)
	if self.DisabledHUDElements[hud] then
		return false
	end

	if hud == "CHudCrosshair" and LocalPlayer():IsInCamera() then
		return false
	end

	if LocalPlayer().Restrained and LocalPlayer():Restrained() and hud == "CHudWeaponSelection" then
		return false
	end

	return true
end