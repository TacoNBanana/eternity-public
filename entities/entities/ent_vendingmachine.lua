AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Vending Machine"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/props_interiors/VendingMachineSoda01a.mdl")
ENT.LightMat 		= Material("particle/fire")

ENT.MaxSupply 		= 20

ENT.DispenseItems = {
	"food_water"
}

ENT.Sounds = {
	Use = Sound("Buttons.snd1"),
	Dispense = Sound("Buttons.snd4"),
	NoSupply = Sound("Buttons.snd10")
}

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end

		self:SetUseType(SIMPLE_USE)
	end

	self:SetSupply(self.MaxSupply)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")
	self:NetworkVar("Int", 1, "Supply")

	self:NetworkVar("Float", 0, "Delay")
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if self:IsReady() and interact then
		table.insert(tab, {
			Name = "Check Supply",
			Callback = function()
				ply:SendChat("NOTICE", string.format("There are %s cans left in the machine.", self:GetSupply()))
			end
		})
	end

	return tab
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		render.SetMaterial(self.LightMat)

		local r = Color(255, 23, 23)
		local g = Color(0, 255, 0)

		local pos = Vector(17.8, 24.25, 5)

		for i = 0, 7 do
			if i == 3 then
				continue
			end

			render.DrawSprite(self:LocalToWorld(pos + Vector(0, 0, -2 * i)), 4, 4, r)
		end

		pos.z = -1

		render.DrawSprite(self:LocalToWorld(pos), 4, 4, self:GetSupply() > 0 and g or r)
	end
end

if SERVER then
	function ENT:Use(ply)
		if not self:IsReady() then
			return
		end

		if self:GetDelay() > CurTime() then
			return
		end

		self:SetDelay(CurTime() + 2.5)

		if self:GetSupply() <= 0 then
			self:EmitSound(self.Sounds.NoSupply)

			return
		end

		self:EmitSound(self.Sounds.Use)

		timer.Simple(1, function()
			if not IsValid(self) then
				return
			end

			local pos = self:LocalToWorld(Vector(16, -6, -24))
			local ang = self:LocalToWorldAngles(Angle(0, 0, 90))

			coroutine.WrapFunc(function()
				local item = GAMEMODE:CreateItem(table.Random(self.DispenseItems))

				item:SetNetworked(true)
				item:SetWorldItem(pos, ang)

				if IsValid(self) then
					self:EmitSound(self.Sounds.Dispense)
				end
			end)
		end)

		self:SetSupply(math.max(self:GetSupply() - 1, 0))
		self:Save()
	end

	function ENT:GetCustomData()
		return {
			Supply = self:GetSupply()
		}
	end

	function ENT:LoadCustomData(data)
		self:SetSupply(data.Supply)
	end
end