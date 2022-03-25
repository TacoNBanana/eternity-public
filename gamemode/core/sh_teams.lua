hook.Add("CreateTeams", "teams.CreateTeams", function()
	for k, v in pairs(TEAMS) do
		team.SetUp(k, v.Name, v.Color, false)
	end
end)