local workshopIDs = GM:GetConfig("WorkshopIDs")

for _, id in pairs(workshopIDs) do
	resource.AddWorkshop(id)
end

local mapID = GM:GetConfig("WorkshopMapIDs")[game.GetMap()]

if mapID then
	if istable(mapID) then
		for _, id in pairs(mapID) do
			resource.AddWorkshop(id)
		end
	else
		resource.AddWorkshop(mapID)
	end
else
	resource.AddSingleFile("maps/" .. game.GetMap() .. ".bsp")
end