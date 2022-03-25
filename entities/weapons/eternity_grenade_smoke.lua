AddCSLuaFile()
DEFINE_BASECLASS("eternity_throwing_base")

SWEP.Base 			= "eternity_throwing_base"

SWEP.PrintName 		= "M-83 Smoke Grenade"
SWEP.Author 		= "TankNut"

SWEP.ViewModel 		= Model("models/weapons/c_grenade.mdl")
SWEP.WorldModel 	= Model("models/weapons/w_grenade.mdl")

function SWEP:CreateEntity()
	local ent = ents.Create("ent_grenade_smoke")
	local ply = self.Owner

	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:EyeAngles())
	ent:SetOwner(ply)
	ent:Spawn()
	ent:Activate()

	local item = self:GetItem()

	if item then
		ent.SmokeColor = item.SmokeColor
	end

	ent:SetTimer(0.1)

	return ent
end