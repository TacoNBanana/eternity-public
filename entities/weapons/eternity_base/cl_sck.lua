--[[
List of element types:
- SCK_MODEL
- SCK_SPRITE
- SCK_QUAD
- SCK_LASER

Element parameters:
- mdl (string)
- sprite (string)
- Hidden (bool)
- Pos (vec)
- Ang (ang)
- Size (vec)
- SubMaterials (tab)
- Material (string)
- UpdateMaterials (bool)
- Bodygroups (tab)
- UpdateBodygroups (bool)
- Fullbright (bool)
- Color (color)
- Dot (num)
- Line (num)

VBoneMods parameters:
- Scale (vec)
- Pos (vec)
- Ang (ang)
]]

SWEP.LaserLine = Material("effects/laser_citadel1.vmt")
SWEP.LaserGlow = Material("effects/blueflare1.vmt")

function SWEP:SetupSCK()
	self.WElements = table.FullCopy(self.WElements)

	self:InitSCKElements(self.WElements)

	self.WRenderOrder = nil

	if LocalPlayer() != self.Owner then
		return
	end

	self.VElements = table.FullCopy(self.VElements)
	self.VMBoneMods = table.FullCopy(self.VMBoneMods)

	self:InitSCKElements(self.VElements)

	self.VRenderOrder = nil

	self:ResetSCKBonePositions()
end

function SWEP:CleanupSCKEntities()
	for _, v in pairs(self.VElements) do
		if IsValid(v.Entity) then
			v.Entity:Remove()
		end
	end

	for _, v in pairs(self.WElements) do
		if IsValid(v.Entity) then
			v.Entity:Remove()
		end
	end
end

function SWEP:InitSCKElements(elements)
	if not elements then
		return
	end

	local parent = self

	if elements == self.VElements then
		parent = self.VM
	end

	for _, v in pairs(elements) do
		v.Scale = v.Scale or Vector(1, 1, 1)
		v.Pos = v.Pos or Vector()
		v.Ang = v.Ang or Angle()

		if v.Type == SCK_MODEL and (not IsValid(v.Entity) or v._mdl != v.mdl) then
			if v.Entity and IsValid(v.Entity) then
				v.Entity:Remove()
			end

			local ent = self:CreateManagedCSModel(v.mdl, RENDERGROUP_VIEWMODEL)

			if IsValid(ent) then
				ent:SetPos(parent:GetPos())
				ent:SetAngles(parent:GetAngles())
				ent:SetNoDraw(true)

				v.Entity = ent
				v._mdl = v.mdl

				if v.Bonemerge then
					ent:AddEffects(EF_BONEMERGE)
					ent:AddEffects(EF_BONEMERGE_FASTCULL)
					ent:SetMoveType(MOVETYPE_NONE)
				end
			else
				v.Entity = nil
			end
		elseif v.Type == SCK_SPRITE and (not v.Material or v._sprite != v.sprite) then
			local name = v.sprite .. util.UID()
			local params = {
				["$basetexture"] = v.sprite
			}

			if v.params then
				for i, j in pairs(v.params) do
					params[i] = j
				end
			end

			v.Material = CreateMaterial(name, "UnlitGeneric", params)
			v._sprite = v.sprite
		end
	end
end

function SWEP:UpdateSCKBonePositions()
	if not self.VM:GetBoneCount() then
		return
	end

	for k, v in pairs(self.VMBoneMods) do
		local bone = self.VM:LookupBone(k)

		if not bone then
			continue
		end

		local scale = v.Scale * Vector(1, 1, 1)
		local pos = v.Pos
		local ang = v.Ang

		if self.VM:GetManipulateBoneScale(bone) != scale then
			self.VM:ManipulateBoneScale(bone, scale)
		end

		if self.VM:GetManipulateBonePosition(bone) != pos then
			self.VM:ManipulateBonePosition(bone, pos)
		end

		if self.VM:GetManipulateBoneAngles(bone) != ang then
			self.VM:ManipulateBoneAngles(bone, ang)
		end
	end
end

function SWEP:ResetSCKBonePositions()
	local count = self.VM:GetBoneCount()

	if not count then
		return
	end

	for i = 0, count - 1 do
		self.VM:ManipulateBoneScale(i, Vector(1, 1, 1))
		self.VM:ManipulateBoneAngles(i, Angle())
		self.VM:ManipulateBonePosition(i, Vector())
	end
end

function SWEP:DrawVMSCK()
	self:UpdateSCKBonePositions()

	if not self.VRenderOrder then
		self.VRenderOrder = {}

		for k, v in pairs(self.VElements) do
			if not istable(v) or not v.Type then
				continue
			end

			if v.Type == SCK_MODEL then
				table.insert(self.VRenderOrder, 1, k)
			else
				table.insert(self.VRenderOrder, k)
			end
		end
	end

	for _, v in pairs(self.VRenderOrder) do
		local abort = self:DrawVMSCKElement(v)

		if abort then -- Something went wrong, reset the render order and try again
			self.VRenderOrder = nil

			break
		end
	end
end

function SWEP:DrawVMSCKElement(index)
	local v = self.VElements[index]

	if not v then -- Renderorder isn't valid anymore, the fuck happened?
		return true -- Abort
	end

	if v.Hidden then
		return
	end

	local pos, ang = self:GetSCKOrientation(self.VElements, v, self.VM)

	if not pos or not ang then
		return
	end

	v.Pos = v.Pos or Vector()
	v.Ang = v.Ang or Angle()

	pos = pos + (ang:Forward() * v.Pos.x)
	pos = pos + (ang:Right() * v.Pos.y)
	pos = pos + (ang:Up() * v.Pos.z)

	ang:RotateAroundAxis(ang:Up(), v.Ang.y)
	ang:RotateAroundAxis(ang:Right(), v.Ang.p)
	ang:RotateAroundAxis(ang:Forward(), v.Ang.r)

	if v.Type == SCK_MODEL and IsValid(v.Entity) then
		local ent = v.Entity

		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetParent(self.VM)

		if v.Hidden then
			return
		end

		local matrix = Matrix()

		if v.Size then
			matrix:Scale(v.Size)
		end

		if v.Bonemerge then
			local bone = self.VM:LookupBone(v.Bone)

			matrix:SetTranslation(self.VM:GetBonePosition(bone))
		end

		ent:EnableMatrix("RenderMultiply", matrix)

		if v.SubMaterials then
			for i, j in pairs(v.SubMaterials) do
				if ent:GetSubMaterial(i) == j then
					continue
				end

				if isstring(j) then
					ent:SetSubMaterial(i, j)
				else
					ent:SetSubMaterial(i, "console/background01_widescreen")
				end
			end
		elseif v.Material then
			ent:SetMaterial(v.Material)
		end

		if v.Skin and ent:GetSkin() != v.Skin then
			ent:SetSkin(v.Skin)
		end

		if v.Bodygroups then
			for i, j in pairs(v.Bodygroups) do
				if ent:GetBodygroup(i) != j then
					continue
				end

				ent:SetBodygroup(i, j)
			end
		end

		if v.Fullbright then
			render.SuppressEngineLighting(true)
		end

		if v.Color then
			render.SetColorModulation(v.Color.r / 255, v.Color.g / 255, v.Color.b / 255)
			render.SetBlend(v.Color.a / 255)
		end

		if v.Invert then
			render.CullMode(MATERIAL_CULLMODE_CW)
		end

		ent:DrawModel()

		render.CullMode(MATERIAL_CULLMODE_CCW)

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
	elseif v.Type == SCK_SPRITE and not v.Hidden then
		render.SetMaterial(v.Material)
		render.DrawSprite(pos, v.Size.x, v.Size.y, v.Color)
	elseif v.Type == SCK_QUAD and v.Callback and not v.Hidden then
		cam.Start3D2D(pos, ang, v.Size)
			v.Callback(self)
		cam.End3D2D()
	elseif v.Type == SCK_LASER and not v.Hidden and not self:ShouldLower() then
		local col1 = Color(v.Color.r, v.Color.g, v.Color.b, 225)
		local col3 = Color(v.Color.r, v.Color.g, v.Color.b, 60)

		local dir = ang:Forward()

		local trace = util.TraceLine({
			start = EyePos(),
			endpos = EyePos() + dir * 8192,
			filter = {self.Owner, self, self.VM},
			mask = MASK_SHOT
		})

		if trace.StartSolid then
			return
		end

		v.DelayedAng = LerpAngle(0.8, v.DelayedAng or Angle(), ang)

		render.SetMaterial(self.LaserGlow)
		render.DrawSprite(pos, 0.5, 0.5, col1)

		if trace.Hit and not trace.HitSky then
			render.DrawSprite(trace.HitPos, v.Dot, v.Dot, col1)
		end

		local len = 1 * (trace.Fraction * 10)

		render.SetMaterial(self.LaserLine)
		render.DrawBeam(pos, trace.HitPos, v.Line, 0, len, col3)
	end
end

function SWEP:DrawWorldModelTranslucent()
	if not self.HideWM then
		if self.DrawWorldModel then
			self:DrawWorldModel()
		else
			self:DrawModel()
		end
	end

	if not self.WRenderOrder then
		self.WRenderOrder = {}

		for k, v in pairs(self.WElements) do
			if v.Type == SCK_MODEL then
				table.insert(self.WRenderOrder, 1, k)
			elseif istable(v) and v.Type then
				table.insert(self.WRenderOrder, k)
			end
		end
	end

	local parent = self

	for _, v in pairs(self.WRenderOrder) do
		local abort = self:DrawWMSCKElement(v, parent)

		if abort then -- Something went wrong, reset the render order and try again
			self.WRenderOrder = nil

			break
		end
	end
end

function SWEP:DrawWMSCKElement(index, parent)
	local v = self.WElements[index]

	if not v then -- Renderorder isn't valid anymore, the fuck happened?
		return true -- Abort
	end

	if v.Hidden then
		return
	end

	local pos, ang

	if v.Bone then
		pos, ang = self:GetSCKOrientation(self.WElements, v, parent)
	else
		pos, ang = self:GetSCKOrientation(self.WElements, v, parent, "ValveBiped.Bip01_R_Hand")
	end

	if not pos or not ang then
		return
	end

	v.Pos = v.Pos or Vector()
	v.Ang = v.Ang or Angle()

	pos = pos + (ang:Forward() * v.Pos.x)
	pos = pos + (ang:Right() * v.Pos.y)
	pos = pos + (ang:Up() * v.Pos.z)

	ang:RotateAroundAxis(ang:Up(), v.Ang.y)
	ang:RotateAroundAxis(ang:Right(), v.Ang.p)
	ang:RotateAroundAxis(ang:Forward(), v.Ang.r)

	if v.Type == SCK_MODEL and IsValid(v.Entity) then
		local ent = v.Entity

		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetParent(self)

		if v.Hidden then
			return
		end

		local matrix = Matrix()

		if v.Size then
			matrix:Scale(v.Size)
		end

		if v.Bonemerge then
			local bone = self:LookupBone(v.Bone)

			matrix:SetTranslation(self:GetBonePosition(bone))
		end

		ent:EnableMatrix("RenderMultiply", matrix)

		if v.SubMaterials then
			for i, j in pairs(v.SubMaterials) do
				if ent:GetSubMaterial(i) == j then
					continue
				end

				if isstring(j) then
					ent:SetSubMaterial(i, j)
				else
					ent:SetSubMaterial(i, "console/background01_widescreen")
				end
			end
		elseif v.Material then
			ent:SetMaterial(v.Material)
		end

		if v.Skin and ent:GetSkin() != v.Skin then
			ent:SetSkin(v.Skin)
		end

		if v.Bodygroups then
			for i, j in pairs(v.Bodygroups) do
				if ent:GetBodygroup(i) != j then
					continue
				end

				ent:SetBodygroup(i, j)
			end
		end

		if v.Fullbright then
			render.SuppressEngineLighting(true)
		end

		if v.Color then
			render.SetColorModulation(v.Color.r / 255, v.Color.g / 255, v.Color.b / 255)
			render.SetBlend(v.Color.a / 255)
		end

		ent:DrawModel()

		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
	elseif v.Type == SCK_SPRITE then
		render.SetMaterial(v.Material)
		render.DrawSprite(pos, v.Size.x, v.Size.y, v.Color)
	elseif v.Type == SCK_QUAD and v.Callback then
		cam.Start3D2D(pos, ang, v.Size)
			v.Callback(self)
		cam.End3D2D()
	elseif v.Type == SCK_LASER and not v.Hidden and not self:ShouldLower() then
		local col1 = Color(v.Color.r, v.Color.g, v.Color.b, 225)
		local col3 = Color(v.Color.r, v.Color.g, v.Color.b, 60)

		local dir = ang:Forward()

		local trace = util.TraceLine({
			start = pos,
			endpos = pos + dir * 8192,
			filter = {self.Owner, self, self.VM},
			mask = MASK_SHOT
		})

		if trace.StartSolid then
			return
		end

		v.DelayedAng = LerpAngle(0.8, v.DelayedAng or Angle(), ang)

		render.SetMaterial(self.LaserGlow)
		render.DrawSprite(trace.StartPos, 0.5, 0.5, col1)

		if trace.Hit and not trace.HitSky then
			render.DrawSprite(trace.HitPos, v.Dot, v.Dot, col1)
		end

		local len = 1 * (trace.Fraction * 10)

		render.SetMaterial(self.LaserLine)
		render.DrawBeam(trace.StartPos, trace.HitPos, v.Line, 0, len, col3)
	end
end

function SWEP:GetSCKOrientation(tab, v, ent, bone)
	local pos = Vector()
	local ang = Angle()

	if v.Parent then
		local parent = tab[v.Parent]

		if not parent then
			return
		end

		pos, ang = self:GetSCKOrientation(tab, parent, ent, bone)

		if not pos or not ang then
			return
		end

		pos = pos + (ang:Forward() * parent.Pos.x)
		pos = pos + (ang:Right() * parent.Pos.y)
		pos = pos + (ang:Up() * parent.Pos.z)

		ang:RotateAroundAxis(ang:Up(), parent.Ang.y)
		ang:RotateAroundAxis(ang:Right(), parent.Ang.p)
		ang:RotateAroundAxis(ang:Forward(), parent.Ang.r)
	else
		--print(v.Name, v.Bone)
		bone = bone or v.Bone

		if not bone then
			return self.VM:GetPos(), self.VM:GetAngles()
		end

		if string.Left(bone, 2) == "A_" then
			local attachment = ent:LookupAttachment(string.sub(bone, 3))
			local data = ent:GetAttachment(attachment)

			pos = data.Pos
			ang = data.Ang
		else
			bone = ent:LookupBone(bone)

			if not bone then
				return ent:GetPos(), ent:GetAngles()
			end

			local matrix = ent:GetBoneMatrix(bone)

			if matrix then
				pos = matrix:GetTranslation()
				ang = matrix:GetAngles()
			end
		end

		if self.ViewModelFlip and ent == self.VM then
			ang.r = -ang.r
		end
	end

	return pos, ang
end