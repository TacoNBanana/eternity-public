ITEM = class.Create("base_item")

ITEM.Name 				= "Compass"
ITEM.Description 		= "A simple compass, convenient for finding your way around."

ITEM.Model 				= Model("models/props_pipes/pipe01_connector01.mdl")
ITEM.Material 			= "phoenix_storms/Fender_chrome"

ITEM.EquipmentSlots 	= {EQUIPMENT_MISC}

ITEM.License 			= LICENSE_QM

if CLIENT then
	local cardinals = {
		"N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"
	}

	hook.Add("HUDPaint", "compass", function()
		local item = LocalPlayer():GetEquipment(EQUIPMENT_MISC)

		if not item or item:GetClassName() != "compass" then
			return
		end

		if not GAMEMODE:GetSetting("hud_enabled") then
			return
		end

		local ang = LocalPlayer():EyeAngles().y
		local originX, originY = ScrW() * 0.5, ScrH() * 0.05
		local w, h = math.Round(ScrW() * 0.3), math.Round(ScrH() * 0.02)
		local w2, h2 = w * 0.5, h * 0.5

		local spacing = (w * 5) / 360
		local num = w / spacing

		local mod = math.Round(-ang) % 360

		for i = mod, mod + num do
			local x = originX - w2 + (((i + ang) % 360) * spacing)
			local offset = math.Round(i - (num * 0.5)) % 360

			local val = math.abs(x - originX)
			local alpha = 1 - ((val + (val - w2)) / w2)

			local color = Color(255, 255, 255, math.Clamp(alpha, 0, 1) * 255)

			local tall = offset % 5 == 0
			local mult = tall and 1 or 0.5

			local height = h2 * mult

			surface.SetDrawColor(color)
			surface.DrawLine(x, originY - height, x, originY + height - 1)

			if offset % 15 != 0 then
				continue
			end

			local text = offset

			if offset % 45 == 0 then
				text = cardinals[(offset / 45) + 1]
			end

			draw.DrawText(text, "eternity.labelsmall", x, originY - h2 - 17, color, TEXT_ALIGN_CENTER)
		end

		surface.SetDrawColor(color_white)
		surface.DrawLine(originX, originY - h2, originX, originY + h2 - 1)

		draw.DrawText(mod, "eternity.labelsmall", originX, originY + h2 + 2, color_white, TEXT_ALIGN_CENTER)
	end)
end

return ITEM