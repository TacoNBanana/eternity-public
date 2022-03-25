DEFINE_BASECLASS("eternity_base")

-- Handles drawing the viewmodel and any attached extras
function SWEP:PostDrawViewModel()
	if LocalPlayer() != self.Owner then
		return
	end

	if not IsValid(self.VM) then
		self:SetupModel()
	end

	self:HandleVMOffsets()
	self:ApplyVMOffsets()

	if not self.Scoped then
		self:DrawVM()
	end

	self:DrawAimpoint()
end

function SWEP:DrawWorldModel()
	local ply = self.Owner

	if self.FixWorldModel and IsValid(self.Owner) then
		local hand = ply:LookupBone("ValveBiped.Bip01_R_Hand")

		if hand then
			local pos, ang

			local mat = ply:GetBoneMatrix(hand)

			if mat then
				pos, ang = mat:GetTranslation(), mat:GetAngles()
			else
				pos, ang = ply:GetBonePosition(hand)
			end

			pos = pos + (ang:Forward() * self.FixWorldModel.pos.x) + (ang:Right() * self.FixWorldModel.pos.y) + (ang:Up() * self.FixWorldModel.pos.z)

			ang:RotateAroundAxis(ang:Up(), self.FixWorldModel.ang.p)
			ang:RotateAroundAxis(ang:Right(), self.FixWorldModel.ang.y)
			ang:RotateAroundAxis(ang:Forward(), self.FixWorldModel.ang.r)

			self:SetRenderOrigin(pos)
			self:SetRenderAngles(ang)

			self:SetModelScale(self.FixWorldModel.scale or 1, 0)
		end
	end

	self:SetupBones()
	self:DrawModel()
end