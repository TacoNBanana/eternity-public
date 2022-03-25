function GM:LoadWorldEnt(data)
	local ent = ents.Create(data.Class)

	if not IsValid(ent) then
		return
	end

	local pos = pon.decode(data.MapPos)

	ent:SetPos(Vector(pos.vx, pos.vy, pos.vz))
	ent:SetAngles(Angle(pos.ap, pos.ay, pos.ar))

	ent:Spawn()
	ent:Activate()

	ent:SetEntityID(data.id)
	ent:LoadCustomData(pon.decode(data.CustomData))

	local phys = ent:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	ent:OnInitialLoad()
end

local prioritylist = {
	["ent_remover"] = 1
}

function GM:LoadWorldEnts()
	local priority = {}
	local unordered = {}

	for _, v in ipairs(dbal.Query("eternity", "SELECT * FROM $worldents WHERE MapName = ?", game.GetMap())) do
		local order = prioritylist[v.Class]

		if order then
			priority[order] = priority[order] or {}

			table.insert(priority[order], v)
		else
			table.insert(unordered, v)
		end
	end

	for _, tab in SortedPairs(priority) do
		for _, v in pairs(tab) do
			self:LoadWorldEnt(v)
		end
	end

	for _, v in pairs(unordered) do
		self:LoadWorldEnt(v)
	end
end

function GM:SaveWorldEnt(ent)
	local data = pon.encode(ent:GetCustomData())

	local vec = ent:GetPos()
	local ang = ent:GetAngles()

	local pos = pon.encode({
		vx = math.Round(vec.x, 2),
		vy = math.Round(vec.y, 2),
		vz = math.Round(vec.z, 2),
		ap = math.Round(ang.p, 2),
		ay = math.Round(ang.y, 2),
		ar = math.Round(ang.r, 2)
	})

	if ent:IsReady() then
		-- Saved before
		dbal.Update("eternity", "$worldents", {
			MapPos = pos,
			CustomData = data
		}, "id = ?", ent:GetEntityID(), stub)
	else
		-- First time save
		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		coroutine.WrapFunc(function()
			local id = dbal.Insert("eternity", "$worldents", {
				Class = ent:GetClass(),
				MapName = game.GetMap(),
				MapPos = pos,
				CustomData = data
			}).LastInsert

			ent:SetEntityID(id)
			ent:OnInitialLoad()
		end)
	end
end

function GM:DeleteWorldEnt(ent)
	if not ent:IsReady() then
		return
	end

	coroutine.WrapFunc(function()
		dbal.Query("eternity", "DELETE FROM $worldents WHERE ID = ?", ent:GetEntityID())

		if IsValid(ent) then
			ent:Remove()
		end
	end)
end

hook.Add("InitPostEntity", "worldents.InitPostEntity", function()
	GAMEMODE:LoadWorldEnts()
end)