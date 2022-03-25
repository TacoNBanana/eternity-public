GM.GUI = GM.GUI or {}

function GM:RegisterGUI(name, func, single)
	self.GUI[name] = {Func = func, Single = single}
end

function GM:OpenGUI(name, ...)
	local ui = self.GUI[name]

	if ui.Single then
		if IsValid(ui.Instance) then
			ui.Instance:Remove()
		end

		ui.Instance = ui.Func(...)

		return ui.Instance
	else
		ui.Instances = ui.Instances or {}

		local panel = ui.Func(...)

		if ispanel(panel) and IsValid(panel) then
			table.insert(ui.Instances, panel)
		end

		return panel
	end
end

function GM:GetGUI(name)
	local ui = self.GUI[name]

	if ui.Single then
		return IsValid(ui.Instance) and ui.Instance or nil
	end

	return ui.Instances or {}
end

function GM:CloseGUI(name)
	local ui = self:GetGUI(name)

	if IsValid(ui) then
		ui:Remove()
	elseif istable(ui) then
		for _, v in pairs(ui) do
			v:Remove()
		end
	end
end

netstream.Hook("OpenGUI", function(data)
	GAMEMODE:OpenGUI(data.Name, unpack(data.Args))
end)

netstream.Hook("HideGameUI", function()
	if gui.IsGameUIVisible() then
		gui.HideGameUI()
	end
end)

local function DrawToolTip(tooltip, x, y, alpha)
	local colors = GAMEMODE:GetConfig("UIColors")
	local w, h = tooltip:GetSize()

	alpha = alpha and (alpha / 255) or 1

	surface.SetDrawColor(ColorAlpha(colors.FillDark, 230 * alpha))
	surface.DrawRect(x - 5, y - 5, w + 10, h + 10)

	surface.SetDrawColor(ColorAlpha(colors.Border, 230 * alpha))
	surface.DrawOutlinedRect(x - 5, y - 5, w + 10, h + 10)

	tooltip:Draw(x, y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255 * alpha)
end

hook.Add("PostRenderVGUI", "gui.PostRenderVGUI", function()
	local tab = dragndrop.GetDroppable()

	if gui.IsGameUIVisible() then
		return
	end

	if GAMEMODE.Tooltip and (not tab or GAMEMODE.TooltipOrigin != tab[1]) then
		local x = gui.MouseX() + 15
		local y = gui.MouseY() + 5

		DrawToolTip(GAMEMODE.Tooltip, x, y)
	end
end)

hook.Add("ShouldDrawLocalPlayer", "gui.ShouldDrawLocalPlayer", function(ply)
	if ply.ForceDraw then
		return true
	end
end)

local function inventoryDone(ply)
	for _, v in pairs(ply:Inventory()) do
		if not GAMEMODE:GetInventory(v) then
			return false
		end
	end

	return true
end

hook.Add("PlayerBindPress", "gui.PlayerBindPress", function(ply, bind, down)
	if ply:IsInCamera() then
		return
	end

	if down and string.find(bind, "showhelp") then
		GAMEMODE:OpenGUI("HelpMenu")

		return true
	end

	if down and string.find(bind, "gm_showteam") then
		if ply:Restrained() then
			GAMEMODE:SendChat("ERROR", "You cannot change characters while restrained!")

			return true
		end

		GAMEMODE:OpenGUI("CharSelect")

		return true
	end

	if down and string.find(bind, "showspare1") and inventoryDone(ply) then
		GAMEMODE:OpenGUI("PlayerMenu")

		return true
	end

	if down and string.find(bind, "showspare2") then
		if ply:IsAdmin() then
			GAMEMODE:OpenGUI("AdminMenu")
		end

		return true
	end
end)

hook.Add("PlayerCharIDChanged", "gui.PlayerCharIDChanged", function(ply, old, new)
	if ply != LocalPlayer() or not GAMEMODE.MOTD then
		return
	end

	local crc = util.CRC(GAMEMODE.MOTD)

	if crc != cookie.GetString("eternity_motd", "") then
		GAMEMODE:OpenGUI("MOTD")

		cookie.Set("eternity_motd", crc)
	end
end)