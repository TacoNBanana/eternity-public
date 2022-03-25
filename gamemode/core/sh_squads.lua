function GM:GetSquadMembers(name)
	local tab = {}

	for _, v in pairs(player.GetAll()) do
		if v:Squad() == name then
			table.insert(tab, v)
		end
	end

	return tab
end

function GM:GetSquadLeader(name)
	for _, v in pairs(player.GetAll()) do
		if v:Squad() == name and v:SquadLeader() then
			return v
		end
	end
end

function GM:CanJoinSquad(name, ply)
	for _, v in pairs(player.GetAll()) do
		if v:Squad() == name then
			return v:Team() == ply:Team()
		end
	end

	return false
end

if CLIENT then
	local function UpdateUI(ply)
		if ply != LocalPlayer() then
			return
		end

		local ui = GAMEMODE:GetGUI("PlayerMenu")

		if not IsValid(ui) or ui.Active != "Squads" then
			return
		end

		ui:UpdateSquadList()
	end

	hook.Add("PlayerSquadChanged", "squads", UpdateUI)
	hook.Add("PlayerSquadLeaderChanged", "squads", UpdateUI)

	netstream.Hook("SquadPasswordPrompt", function(data)
		local password = GAMEMODE:OpenGUI("Input", "string", "Password", {
			Max = 10
		})

		if #password < 1 then
			return
		end

		netstream.Send("JoinSquad", {
			Squad = data.Squad,
			Password = password
		})
	end)

	local mat = Material("vgui/ico_friend_indicator_alone")
	local leader = Color(127, 255, 159, 50)
	local other = Color(255, 255, 255, 50)

	hook.Add("PostDrawTranslucentRenderables", "squads", function()
		if not GAMEMODE:HUDEnabled("squadoverlay") then
			return
		end

		local lp = LocalPlayer()

		if lp:Squad() == "" then
			return
		end

		for _, v in pairs(player.GetAll()) do
			if v:IsDormant() or v:GetNoDraw() or v:Squad() != lp:Squad() then
				continue
			end

			if v == lp and lp:GetViewEntity() == lp then
				local should = lp:ShouldDrawLocalPlayer()

				if not should or (should and ctp:IsEnabled()) then
					continue
				end
			end

			render.DepthRange(0, 0)

			local pos = v:EyePos() + Vector(0, 0, 13)

			if v:InVehicle() then
				pos = v:GetVehicle():WorldSpaceCenter()
			end

			render.SetMaterial(mat)
			render.DrawSprite(pos, 4, 4, v:SquadLeader() and leader or other)

			render.DepthRange(0, 1)
		end
	end)
else
	GM.SquadPasswords = {}

	function GM:CreateSquad(name, ply, password)
		ply:SetSquad(name)
		ply:SetSquadLeader(true)

		if #password > 0 then
			self.SquadPasswords[name] = password
		end
	end

	function GM:JoinSquad(name, ply)
		ply:SetSquad(name)
		ply:SetSquadLeader(false)

		self:SendChat("NOTICE", ply:RPName() .. " has joined your squad.", self:GetSquadMembers(name))
	end

	function GM:LeaveSquad(ply, disconnecting)
		local name = ply:Squad()

		if name == "" then
			return
		end

		self:SendChat("NOTICE", ply:RPName() .. " has left your squad.", self:GetSquadMembers(name))

		if not disconnecting then
			ply:SetSquad("")
			ply:SetSquadLeader(false)
		end

		if #self:GetSquadMembers(name) < 1 then
			self.SquadPasswords[name] = nil
		end
	end

	function GM:DisbandSquad(name, ply)
		local squad = self:GetSquadMembers(name)

		for _, v in pairs(squad) do
			v:SetSquad("")
			v:SetSquadLeader(false)
		end

		self:SendChat("NOTICE", ply:RPName() .. " has disbanded your squad.", squad)
		self.SquadPasswords[name] = nil
	end

	function GM:SetSquadLeader(name, ply)
		if ply:Squad() != name then
			return
		end

		local squad = self:GetSquadMembers(name)

		for _, v in pairs(squad) do
			v:SetSquadLeader(v == ply)
		end

		self:SendChat("NOTICE", ply:RPName() .. " is your new squad leader.", squad)
	end

	netstream.Hook("CreateNewSquad", function(ply, data)
		if ply:Squad() != "" then
			return
		end

		GAMEMODE:CreateSquad(data.Name, ply, data.Password)
	end, {
		Name = {Type = TYPE_STRING},
		Password = {Type = TYPE_STRING}
	})

	netstream.Hook("TakeSquadCommand", function(ply, data)
		if ply:Squad() != data.Squad or IsValid(GAMEMODE:GetSquadLeader(data.Squad)) then
			return
		end

		GAMEMODE:SetSquadLeader(data.Squad, ply)
	end, {
		Squad = {Type = TYPE_STRING}
	})

	netstream.Hook("DisbandSquad", function(ply, data)
		if not ply:IsAdmin() and (ply:Squad() != data.Squad or not ply:SquadLeader()) then
			return
		end

		GAMEMODE:DisbandSquad(data.Squad, ply)
	end, {
		Squad = {Type = TYPE_STRING}
	})

	netstream.Hook("LeaveSquad", function(ply)
		if ply:Squad() == "" then
			return
		end

		GAMEMODE:LeaveSquad(ply)
	end)

	netstream.Hook("JoinSquad", function(ply, data)
		if ply:Squad() != "" then
			return
		end

		local password = GAMEMODE.SquadPasswords[data.Squad]

		if password then
			if data.Password and data.Password != password then
				ply:SendChat("ERROR", "Incorrect password!")

				return
			elseif not data.Password then
				netstream.Send("SquadPasswordPrompt", {
					Squad = data.Squad
				}, ply)

				return
			end
		end

		GAMEMODE:JoinSquad(data.Squad, ply)
	end, {
		Squad = {Type = TYPE_STRING},
		Password = {Type = TYPE_STRING, Optional = true}
	})

	hook.Add("UnloadCharacter", "Squads", function(ply)
		GAMEMODE:LeaveSquad(ply)
	end)

	hook.Add("PlayerDisconnected", "Squads", function(ply)
		GAMEMODE:LeaveSquad(ply, true)
	end)
end