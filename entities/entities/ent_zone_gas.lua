AddCSLuaFile()
DEFINE_BASECLASS("ent_zone")

ENT.Base 			= "ent_zone"

ENT.PrintName 		= "Toxic Gas"
ENT.Category 		= "Eternity Zones"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Color 			= Color(127, 0, 0)
ENT.GasColor 		= Color(0, 127, 31)

function ENT:Enter(ply, transition)
	if CLIENT and ply == LocalPlayer() then
		if not transition then -- Don't reset fog timer if transitioning from another cloud
			ply.FogStart = CurTime()
		end

		hook.Add("SetupWorldFog", self, function()
			local time = CurTime() - ply.FogStart
			local frac = math.Clamp(time * 0.5, 0, 1)

			render.FogMode(MATERIAL_FOG_LINEAR)
			render.FogStart(-750)
			render.FogEnd(1000)
			render.FogMaxDensity(frac)
			render.FogColor(self.GasColor.r * 0.2, self.GasColor.g * 0.2, self.GasColor.b * 0.2)

			return true
		end)
	end

	if SERVER and not transition then
		if ply:GetActiveSpecies().GasImmune then
			ply:SendChat("NOTICE", "There's some kind of gas lingering in the air.")
		else
			if ply:Gasmask() then
				ply:SendChat("NOTICE", "There's some kind of gas lingering in the air. It's probably for the best to keep your mask on.")
			else
				ply:SendChat("NOTICE", "There's something in the air that's making your eyes water and your lungs burn! You can't breathe!")
			end
		end
	end
end

function ENT:Exit(ply, transition)
	if CLIENT and ply == LocalPlayer() then
		hook.Remove("SetupWorldFog", self) -- Always remove entry fog hook, replaced by new zone if transitioning

		if not transition then -- Only setup exit fog if we're not transitioning for good
			ply.FogEnd = CurTime() + math.min(2, CurTime() - ply.FogStart)

			hook.Add("SetupWorldFog", self, function()
				local time = ply.FogEnd - CurTime()
				local frac = math.Clamp(time * 0.5, 0, 1)

				if frac == 0 then
					hook.Remove("SetupWorldFog", self)
				end

				render.FogMode(MATERIAL_FOG_LINEAR)
				render.FogStart(-750)
				render.FogEnd(1000)
				render.FogMaxDensity(frac)
				render.FogColor(self.GasColor.r * 0.2, self.GasColor.g * 0.2, self.GasColor.b * 0.2)

				return true
			end)
		end
	end

	if SERVER and not transition then
		if ply:GetActiveSpecies().GasImmune then
			ply:SendChat("NOTICE", "The air seems clear here.")
		else
			if ply:Gasmask() then
				ply:SendChat("NOTICE", "The air seems clear here. It should be safe to take off your mask again.")
			else
				ply:SendChat("NOTICE", "Relief washes over you as you take a deep breath. You should be fine now.")
			end
		end
	end
end

if SERVER then
	function ENT:Think()
		if not self:IsReady() then
			return
		end

		self.NextHurt = self.NextHurt or CurTime()

		if self.NextHurt > CurTime() then
			return
		end

		for k in pairs(self.Active) do
			if not IsValid(k) then
				continue
			end

			if k:GetActiveSpecies().GasImmune then
				continue
			end

			if k:Gasmask() then
				continue
			end

			local dmg = DamageInfo()

			dmg:SetAttacker(self)
			dmg:SetDamage(10)
			dmg:SetDamageType(DMG_NERVEGAS)
			dmg:SetInflictor(k)

			k:TakeDamageInfo(dmg)
		end

		self.NextHurt = self.NextHurt + 1
	end
end