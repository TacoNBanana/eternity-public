AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 					= "ent_worldent"
ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.PrintName 				= "Container"
ENT.Category 				= "Eternity"

ENT.Spawnable 				= true
ENT.AdminOnly 				= true

ENT.Model 					= Model("models/Items/ammocrate_smg1.mdl")

ENT.InventorySize 			= {10, 6}

ENT.Sounds = {
	Open = Sound("AmmoCrate.Open"),
	Close = Sound("AmmoCrate.Close")
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

	self:ResetSequence("close")
	self:SetSubMaterial(1, "engine/occlusionproxy")
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")

	self:NetworkVar("Bool", 0, "Open")
	self:NetworkVar("Bool", 1, "Locked")
end

function ENT:CanAccessInventory(ply)
	return self:WithinInteractRange(ply) and self:GetOpen()
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not interact then
		return tab
	end

	if self:IsReady() then
		if not self:GetOpen() then
			local data = {
				Name = "Open",
				Callback = function(val)
					if self:GetLocked() and not ply:IsAdmin() then
						if not val then
							return
						end

						if not GAMEMODE:CheckInput("string", {
							Max = 30
						}, val) then
							return
						end

						if self.Password != val then
							return
						end
					end

					self:EmitSound(self.Sounds.Open)
					self:ResetSequence("open")

					self:SetOpen(true)
				end
			}

			if self:GetLocked() and not ply:IsAdmin() then
				data.Client = function()
					return GAMEMODE:OpenGUI("Input", "string", "Unlock Container", {
						Max = 30
					})
				end
			end

			table.insert(tab, data)
		else
			table.insert(tab, {
				Name = "Close",
				Callback = function()
					self:EmitSound(self.Sounds.Close)
					self:ResetSequence("close")

					self:SetOpen(false)
				end
			})
		end
	elseif ply:IsInEditMode() then
		table.insert(tab, {
			Name = "Set Password",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Password", {
					Max = 30
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = 30
				}, val) then
					return
				end

				self:SetLocked(true)
				self.Password = val
			end
		})
		table.insert(tab, {
			Name = "Clear Password",
			Callback = function()
				self:SetLocked(false)
				self.Password = nil
			end
		})
	end

	return tab
end

if SERVER then
	function ENT:Use(ply)
		if not self:IsReady() or not self:GetOpen() then
			return
		end

		local inventory = GAMEMODE:GetInventoryByType(STORE_CONTAINER, self:GetEntityID(), "Main")

		ply:OpenGUI("InventoryPopup", "Container", {inventory.NetworkID})
	end

	function ENT:OnInitialLoad()
		GAMEMODE:CreateGrid(STORE_CONTAINER, self:GetEntityID(), "Main", self.InventorySize[1], self.InventorySize[2], false, true):SetNetworked(true)
	end

	function ENT:GetCustomData()
		return {
			Password = self.Password
		}
	end

	function ENT:LoadCustomData(data)
		self.Password = data.Password

		if self.Password then
			self:SetLocked(true)
		end
	end
end