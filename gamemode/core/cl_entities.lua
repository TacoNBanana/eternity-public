local meta = FindMetaTable("Entity")

function meta:GetVisible()
	if self.CachedTick != FrameNumber() then
		self.PixVis = self.PixVis or util.GetPixelVisibleHandle()

		self.CachedVisible = util.PixelVisible(self:LocalToWorld(self:OBBCenter()), self:BoundingRadius(), self.PixVis)
		self.CachedTick = FrameNumber()
	end

	return self.CachedVisible
end

hook.Add("CreateClientsideRagdoll", "entities.CreateClientsideRagdoll", function(ent, ragdoll)
	if IsValid(ent) and (ent:IsNPC() or ent:GetClass() == "raggib") then
		timer.Simple(GAMEMODE:GetConfig("RagdollTimeout"), function()
			if not IsValid(ragdoll) then
				return
			end

			ragdoll:SetSaveValue("m_bFadingOut", true)
		end)
	end
end)