AddCSLuaFile()
DEFINE_BASECLASS("ent_picker")

ENT.Base 			= "ent_picker"
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.PrintName 		= "Entity User (Admin)"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Color 			= Color(255, 255, 100)

function ENT:Initialize()
	BaseClass.Initialize(self)

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EntityID")

	self:NetworkVar("Entity", 0, "PickedEntity")

	self:NetworkVar("String", 0, "ButtonID")
end

function ENT:GetContextOptions(ply, interact)
	local tab = BaseClass.GetContextOptions(self, ply, interact)

	if not ply:IsInEditMode() or self:IsReady() or not interact then
		return tab
	end

	table.insert(tab, {
		Name = "Set Button ID",
		Client = function()
			return GAMEMODE:OpenGUI("Input", "string", "Set Button ID", {
				Default = self:GetButtonID(),
				Max = 30
			})
		end,
		Callback = function(val)
			if not GAMEMODE:CheckInput("string", {
				Max = 30
			}, val) then
				return
			end

			for _, v in pairs(ents.FindByClass("ent_adminuser")) do
				if v != self and v:GetButtonID() == val then
					ply:SendChat("ERROR", "There already exists a button with this ID!")

					return
				end
			end

			self:SetButtonID(val)
		end
	})

	return tab
end

function ENT:CanSave()
	return self:GetButtonID() != ""
end

if CLIENT then
	function ENT:Draw()
		BaseClass.Draw(self)

		if LocalPlayer():IsInEditMode() then
			GAMEMODE:DrawWorldText(self:GetPos() + Vector(0, 0, 15), self:GetButtonID())
		end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	function ENT:GetCustomData()
		return {
			ButtonID = self:GetButtonID(),
		}
	end

	function ENT:LoadCustomData(data)
		self:SetButtonID(data.ButtonID)
	end
end