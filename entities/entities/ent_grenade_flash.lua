AddCSLuaFile()
DEFINE_BASECLASS("ent_base")

ENT.Base 		= "ent_base"

ENT.Model 		= Model("models/weapons/w_npcnade.mdl")

function ENT:SetTimer(delay)
	self.Detonate = CurTime() + delay

	self:NextThink(CurTime())
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end
	end
end

function ENT:Explode()
	netstream.Send("Flashbang", {
		Index = self:EntIndex(),
		Pos = self:GetPos()
	})

	self:EmitSound("weapons/flashbang/flashbang_explode2.wav")
	self:Remove()
end

function ENT:Think()
	if CLIENT then
		return
	end

	if self.Detonate and self.Detonate <= CurTime() then
		self:Explode()
		self:NextThink(math.huge)

		return true
	end

	self:NextThink(CurTime() + 0.1)

	return true
end

if CLIENT then
	GAMEMODE.Flashbang = 0

	netstream.Hook("Flashbang", function(data)
		local index = data.Index
		local pos = data.Pos

		local light = DynamicLight(index)

		if light then
			light.Pos = pos

			light.r = 255
			light.g = 255
			light.b = 255

			light.Brightness = 10
			light.Size = 256

			light.Decay = 5000
			light.DieTime = CurTime() + 0.2

			light.Style = 0
		end

		local filter = {LocalPlayer()}
		local ent = Entity(index)

		if IsValid(ent) then
			table.insert(filter, ent)
		end

		local eye = LocalPlayer():EyePos()

		if LocalPlayer():Alive() and pos:Distance(eye) < 650 and GAMEMODE:CanSeePos(eye, pos, filter) then
			GAMEMODE.Flashbang = CurTime() + 6

			LocalPlayer():SetDSP(math.random(35, 37))
		end
	end)

	hook.Add("RenderScreenspaceEffects", "flashbang.RenderScreenspaceEffects", function()
		local time = GAMEMODE.Flashbang - CurTime()

		if time > 0 and LocalPlayer():Alive() then
			local brightness = math.ClampedRemap(time, 3, 0, 1, 0)

			local tab = {}

			tab["$pp_colour_addr"] 			= 0
			tab["$pp_colour_addg"] 			= 0
			tab["$pp_colour_addb"] 			= 0
			tab["$pp_colour_brightness"] 	= brightness
			tab["$pp_colour_contrast"] 		= 1
			tab["$pp_colour_colour"] 		= 1
			tab["$pp_colour_mulr"] 			= 0
			tab["$pp_colour_mulg"] 			= 0
			tab["$pp_colour_mulb"] 			= 0

			DrawColorModify(tab)
		end
	end)
end