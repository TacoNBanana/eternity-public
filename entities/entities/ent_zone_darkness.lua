AddCSLuaFile()
DEFINE_BASECLASS("ent_zone")

ENT.Base 			= "ent_zone"

ENT.PrintName 		= "Darkness"
ENT.Category 		= "Eternity Zones"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Color 			= Color(36, 36, 36)

function ENT:Enter(ply, transition)
	if CLIENT and ply == LocalPlayer() then
		if not transition then -- Don't reset fog timer if transitioning from another cloud
			ply.FogStart = CurTime()
		end

		hook.Add("PreDrawSkyBox", self, function()
			return true
		end)

		hook.Add("RenderScreenspaceEffects", self, function()
			local time = CurTime() - ply.FogStart
			local frac = math.Clamp(time * 2, 0, 1)

			DrawBloom(0.3, 1.4 * frac, 0, 0, 1, 0, 1, 1, 1)
		end)

		hook.Add("SetupWorldFog", self, function()
			local time = CurTime() - ply.FogStart
			local frac = math.Clamp(time * 2, 0, 0.999)

			render.FogMode(MATERIAL_FOG_LINEAR)
			render.FogStart(-4000)
			render.FogEnd(400)
			render.FogMaxDensity(frac)
			render.FogColor(0, 0, 0)

			return true
		end)
	end

	if SERVER and not transition then
		ply:SendChat("NOTICE", "It's pitch black in here and you can't see more than few feet in front of you.")
	end
end

function ENT:Exit(ply, transition)
	if CLIENT and ply == LocalPlayer() then
		hook.Remove("PreDrawSkyBox", self)
		hook.Remove("RenderScreenspaceEffects", self)
		hook.Remove("SetupWorldFog", self) -- Always remove entry fog hook, replaced by new zone if transitioning

		if not transition then -- Only setup exit fog if we're not transitioning for good
			ply.FogEnd = CurTime() + math.min(0.5, CurTime() - ply.FogStart)

			hook.Add("RenderScreenspaceEffects", self, function()
				local time = ply.FogEnd - CurTime()
				local frac = math.Clamp(time * 2, 0, 0.999)

				if frac == 0 then
					hook.Remove("RenderScreenspaceEffects", self)
				end

				DrawBloom(0.3, 1.4 * frac, 0, 0, 1, 0, 1, 1, 1)
			end)

			hook.Add("SetupWorldFog", self, function()
				local time = ply.FogEnd - CurTime()
				local frac = math.Clamp(time * 2, 0, 1)

				if frac == 0 then
					hook.Remove("SetupWorldFog", self)
				end

				render.FogMode(MATERIAL_FOG_LINEAR)
				render.FogStart(-4000)
				render.FogEnd(400)
				render.FogMaxDensity(frac)
				render.FogColor(0, 0, 0)

				return true
			end)
		end
	end

	if SERVER and not transition then
		ply:SendChat("NOTICE", "Your eyes take a moment to adjust to the light but at least you can see normally again.")
	end
end