AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 		= "ent_base"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.AllowPhys 	= true
ENT.AllowTool 	= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemID")
end

function ENT:GetItem()
	return GAMEMODE:GetItem(self:GetItemID())
end

function ENT:CanTool(ply, tool)
	local can = BaseClass.CanTool(self)

	if can and SERVER and tool == "remover" then
		GAMEMODE:WriteLog("item_destroy", {
			Ply = GAMEMODE:LogPlayer(ply),
			Char = GAMEMODE:LogCharacter(ply),
			Item = GAMEMODE:LogItem(self:GetItem())
		})
	end

	return can
end

if CLIENT then
	function ENT:Draw(studio)
		if GAMEMODE:GetSetting("hud_items") then
			if halo.RenderedEntity() == self or (studio != 1 and studio != 9) then
				self:DrawModel()

				return
			end

			local config = GAMEMODE:GetConfig("ItemRange")

			local pos = self:WorldSpaceCenter()
			local eyepos = EyePos()

			local dist = pos:Distance(eyepos)
			local aimdist = util.DistanceToLine(eyepos, eyepos + EyeAngles():Forward() * config.Dist, pos)

			local frac = math.ClampedRemap(aimdist, config.AimDist + self:BoundingRadius(), self:BoundingRadius(), 0, 1) * math.ClampedRemap(dist, 0, config.Dist, 1, 0) * self:GetVisible()

			self.VisFraction = frac

			if GAMEMODE:GetSetting("hud_itemstyle") != ITEMTYPE_LABEL then
				local item = self:GetItem()

				if item and frac > 0 then
					local col = self:GetItem():GetOutlineColor()

					if col == true then
						local time = CurTime() * 50

						col = HSVToColor(time % 360, 1, 1)
					end

					for k, v in pairs(col) do
						col[k] = v * frac
					end

					render.SetStencilEnable(true)
						render.SetStencilWriteMask(255)
						render.SetStencilTestMask(255)
						render.SetStencilReferenceValue(15)

						render.SetStencilPassOperation(STENCIL_REPLACE)
						render.SetStencilFailOperation(STENCIL_KEEP)
						render.SetStencilZFailOperation(STENCIL_KEEP)

						render.SetStencilCompareFunction(STENCIL_ALWAYS)

						render.SetBlend(0)
						render.MaterialOverride(Material("models/shiny"))

						local min, max = self:GetModelBounds()
						local ratio = max - min

						local mult = math.max(ratio.x, ratio.y, ratio.z)

						ratio = ratio - Vector(mult, mult, mult)
						ratio = -(ratio / mult) + Vector(1, 1, 1)
						ratio = 0.04 * ratio

						local mat = Matrix()
						mat:SetScale(Vector(1, 1, 1) + ratio)
						mat:SetTranslation(-self:OBBCenter() * ratio)

						self:EnableMatrix("RenderMultiply", mat)
						self:SetupBones()
						self:DrawModel()

						mat:SetScale(Vector(1, 1, 1) - ratio)
						mat:SetTranslation(self:OBBCenter() * ratio)

						self:EnableMatrix("RenderMultiply", mat)
						self:SetupBones()
						self:DrawModel()
						self:DisableMatrix("RenderMultiply", mat)

						render.MaterialOverride(false)
						render.SetBlend(1)

						render.SetStencilCompareFunction(STENCIL_EQUAL)

						cam.Start2D()
							surface.SetDrawColor(col.r, col.g, col.b, col.a)
							surface.DrawRect(0, 0, ScrW(), ScrH())
						cam.End2D()
					render.SetStencilEnable(false)
					render.ClearStencil()
				end
			end
		end

		self:SetupBones()
		self:DrawModel()
	end
end

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end

		self.StoredPos = self:GetPos()
	end

	function ENT:Think()
		local item = self:GetItem()

		if item and self:GetPos() != self.StoredPos then
			item:SaveLocation()

			self.StoredPos = self:GetPos()
		end

		self:NextThink(CurTime() + 30)

		return true
	end

	function ENT:OnRemove()
		local item = self:GetItem()

		if item and not GAMEMODE.IsShuttingDown then
			GAMEMODE:DeleteItem(item)
		end
	end

	function ENT:Use(activator, caller, usetype, val)
		local item = self:GetItem()

		if not item then
			return
		end

		if not activator:IsAdmin() and self.DropID == activator:SteamID() and self.DropCharacter != activator:CharID() then
			GAMEMODE:WriteLog("security_itemtransfer", {
				Ply = GAMEMODE:LogPlayer(activator),
				Char = GAMEMODE:LogCharacter(activator),
				Item = GAMEMODE:LogItem(item)
			})

			activator:SendChat("ERROR", "You cannot pick up items you've dropped on another character!")

			GAMEMODE:SendChat("NOTICE", string.format("%s (%s) is trying to transfer items between characters!", activator:RPName(), activator:Nick()), player.GetUsergroup(USERGROUP_ADMIN))

			return
		end

		if not item:OnWorldUse(activator) then
			activator:SendChat("ERROR", "You don't have room to fit this item!")
		end
	end
end