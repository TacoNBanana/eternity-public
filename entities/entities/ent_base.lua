AddCSLuaFile()

ENT.Base 					= "base_anim"
ENT.Type 					= "anim"

ENT.RenderGroup 			= RENDERGROUP_BOTH

ENT.Spawnable 				= false
ENT.AdminSpawnable			= false

ENT.AutomaticFrameAdvance 	= true

ENT.AllowDupe 				= false
ENT.AllowPhys 				= false
ENT.AllowTool 				= false

function ENT:PostEntityPaste(ply, ent, tab)
	if not ent.AllowDupe then
		ent:Remove()
	end
end

function ENT:CanPhys(ply)
	return self.AllowPhys
end

function ENT:CanTool(ply, tool)
	return self.AllowTool
end

function ENT:GetContextOptions(ply, interact)
	return {}
end

function ENT:SpawnFunction(ply, tr, class)
	local ang = Angle(0, ply:EyeAngles().y + 180, 0) + (self.SpawnAngleOffset or Angle())
	local ent = ents.Create(class)

	ent:SetCreator(ply)
	ent:SetPos(tr.HitPos)
	ent:SetAngles(ang)

	ent:Spawn()
	ent:Activate()

	-- Duplicate of the prop alignment code from the spawnmenu
	local pos = tr.HitPos - (tr.HitNormal * 512)

	pos = ent:NearestPoint(pos)
	pos = ent:GetPos() - pos
	pos = tr.HitPos + pos

	ent:SetPos(pos)

	undo.Create(class)
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone " .. ent.PrintName)
	undo.Finish()

	return ent
end