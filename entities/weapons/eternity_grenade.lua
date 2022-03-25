AddCSLuaFile()
DEFINE_BASECLASS("eternity_throwing_base")

SWEP.Base 			= "eternity_throwing_base"

SWEP.PrintName 		= "MK3A2 Frag Grenade"
SWEP.Author 		= "TankNut"

SWEP.ViewModel 		= Model("models/weapons/c_grenade.mdl")
SWEP.WorldModel 	= Model("models/weapons/w_grenade.mdl")

function SWEP:CreateEntity()
	local ent = ents.Create("ent_grenade_frag")
	local ply = self.Owner

	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:EyeAngles())
	ent:SetOwner(ply)
	ent:Spawn()
	ent:Activate()

	ent:SetTimer(3)

	return ent
end