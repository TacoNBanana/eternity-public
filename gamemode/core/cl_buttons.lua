function GM:DrawButtons()
	local edit = LocalPlayer():IsInEditMode()

	local sorted = table.Copy(self.Buttons)

	table.Filter(sorted, function(key, val)
		return IsValid(val)
	end)

	table.sort(sorted, function(a, b)
		return a:GetPos():DistToSqr(LocalPlayer():EyePos()) > b:GetPos():DistToSqr(LocalPlayer():EyePos())
	end)

	for _, v in pairs(sorted) do
		if not IsValid(v) or v:IsDormant() then
			continue
		end

		if edit then
			local color = v:ButtonDisabled() and Color(255, 0, 0) or color_white

			render.SetColorMaterial()
			render.DrawBox(v:GetPos(), v:GetAngles(), v:OBBMins() - Vector(0.1, 0.1, 0.1), v:OBBMaxs() + Vector(0.1, 0.1, 0.1), ColorAlpha(color, 50), true)
		end

		local mid = v:WorldSpaceCenter()

		mid.z = v:GetPos().z + v:OBBMaxs().z + 2

		local visible = util.TraceLine({
			start = LocalPlayer():EyePos(),
			endpos = mid,
			mask = MASK_VISIBLE,
			filter = {LocalPlayer(), v}
		}).Fraction == 1

		if visible then
			GAMEMODE:DrawWorldText(mid, v:ButtonName(), true)
		end
	end
end

hook.Add("PostDrawTranslucentRenderables", "buttons.PostDrawTranslucentRenderables", function(depth, skybox)
	if skybox then
		return
	end

	if GAMEMODE:HUDEnabled("buttons", true) then
		GAMEMODE:DrawButtons()
	end
end)