local workshopIDs = GM:GetConfig("WorkshopIDs")

for _, id in pairs(workshopIDs) do
	resource.AddWorkshop(id)
end