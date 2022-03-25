hook.Add("Think", "sandbox.Think", function()
	if GetConVar("physgun_wheelspeed"):GetFloat() > 20 then
		RunConsoleCommand("physgun_wheelspeed", "20")
	end
end)