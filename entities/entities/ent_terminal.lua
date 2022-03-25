AddCSLuaFile()
DEFINE_BASECLASS("ent_worldent")

ENT.Base 			= "ent_worldent"
ENT.RenderGroup 	= RENDERGROUP_OPAQUE

ENT.PrintName 		= "Terminal"
ENT.Category 		= "Eternity"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true

ENT.Model 			= Model("models/ishi/halo_rebirth/props/human/tech_console_b.mdl")

ENT.MenuOptions 	= {
	{Name = "Surveillance", GUI = "SurveillanceMenu", Callback = function(ply) return ply:HasPermission(PERMISSION_SURVEILLANCE) end}
}

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end
end

if SERVER then
	function ENT:Use(ply)
		if not self:IsReady() then
			return
		end

		for _, v in pairs(self.MenuOptions) do
			if not v.Callback or v.Callback(ply) then
				ply:OpenGUI("TerminalMenu", self)

				return
			end
		end

		self.NextSound = self.NextSound or CurTime()

		if self.NextSound <= CurTime() then
			self:EmitSound("buttons/combine_button_locked.wav")
			self.NextSound = CurTime() + 1
		end
	end
end