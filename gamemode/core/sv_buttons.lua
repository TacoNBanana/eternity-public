function GM:QueueButtonSave()
	timer.Create("ButtonSave", 20, 1, function()
		GAMEMODE:SaveButtonData()
	end)
end

function GM:LoadButtonData()
	local tab = GAMEMODE:GetMapData("ButtonData")

	for _, v in pairs(self.Buttons) do
		if not IsValid(v) then
			continue
		end

		local data = tab[v:MapCreationID()]

		if data then
			if data.ButtonName then
				v:SetButtonName(data.ButtonName)
			end

			if data.ButtonDisabled then
				v:SetButtonDisabled(true)
			end
		end
	end

	self.ButtonsLoaded = true
end

function GM:SaveButtonData()
	local data = {}

	for _, v in pairs(self.Buttons) do
		if not IsValid(v) then
			continue
		end

		local id = v:MapCreationID()

		if id == -1 then
			continue
		end

		local tab = {
			ButtonName = v:ButtonName() != "" and v:ButtonName() or nil,
			ButtonDisabled = v:ButtonDisabled() and true or nil
		}

		if table.Count(tab) == 0 then
			continue
		end

		data[id] = tab
	end

	self:SaveMapData("ButtonData", data)
end

hook.Add("InitPostEntity", "buttons.InitPostEntity", function()
	coroutine.WrapFunc(function()
		GAMEMODE:LoadButtonData()
	end)
end)

hook.Add("OnEntityCreated", "buttons.OnEntityCreated", function(ent)
	if not IsValid(ent) or ent:GetClass() != "func_button" then
		return
	end

	ent:SetIsButton(true)
end)

hook.Add("PlayerUse", "buttons.PlayerUse", function(ply, ent)
	if ent:ButtonDisabled() then
		return false
	end
end)