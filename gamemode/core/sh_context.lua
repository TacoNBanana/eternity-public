local pmeta = FindMetaTable("Player")
local emeta = FindMetaTable("Entity")

function pmeta:GetPlayerContextOptions(ply, interact)
	local tab = {}

	table.insert(tab, {
		Name = "Examine",
		Client = function()
			GAMEMODE:OpenGUI("Examine", self)
		end
	})

	if interact then
		if ply:HasItem("zipties") and not self:Restrained() then
			table.insert(tab, {
				Name = "Restrain",
				Callback = function()
					ply:VisibleMessage(string.format("%s starts restraining %s.", ply:RPName(), self:RPName()), true)

					if not ply:WaitFor(5, "Restraining...", {self}, "Being restrained...", self) then
						return
					end

					self:SetRestrained(true)
				end
			})
		end

		if self:Restrained() then
			table.insert(tab, {
				Name = "Release",
				Callback = function()
					ply:VisibleMessage(string.format("%s starts removing %s's restraints.", ply:RPName(), self:RPName()), true)

					if not ply:WaitFor(5, "Releasing...", {self}, "Being released...", self) then
						return
					end

					self:SetRestrained(false)
				end
			})
		end

		table.insert(tab, {
			Name = "Pat down",
			Callback = function()
				ply:VisibleMessage(string.format("%s starts patting down %s.", ply:RPName(), self:RPName()))

				ply:OpenGUI("Patdown", self)
			end
		})
	end

	return tab
end

function pmeta:GetAdminOptions()
	local tab = {}

	table.insert(tab, {
		Name = "Toggle Edit Mode",
		Callback = function()
			self:SetEditMode(not self:EditMode())
		end
	})

	local teleports = {}

	for _, v in pairs(ents.FindByClass("ent_adminteleport")) do
		if v:IsReady() then
			teleports[v:GetTeleportID()] = {Pos = v:GetPos(), Ang = v:GetAngles()}
		end
	end

	for k, v in SortedPairs(teleports) do
		table.insert(tab, {
			Name = k,
			Category = "Quick Teleport",
			Callback = function()
				self:SetPos(v.Pos)
				self:SetEyeAngles(Angle(self:EyeAngles().p, v.Ang.y, 0))
			end
		})
	end

	local buttons = {}

	for _, v in pairs(ents.FindByClass("ent_adminuser")) do
		if v:IsReady() then
			buttons[v:GetButtonID()] = v:GetPickedEntity()
		end
	end

	for k, v in SortedPairs(buttons) do
		table.insert(tab, {
			Name = k,
			Category = "Map Buttons",
			Callback = function()
				if not IsValid(v) then
					return
				end

				GAMEMODE:WriteLog("admin_mapbutton", {
					Admin = GAMEMODE:LogPlayer(self),
					Button = k
				})

				v:Input("Use", self, v)
			end
		})
	end

	return tab
end

function emeta:GetOptions(ply, interact)
	local tab = {}

	if ply:ShouldLockInput() then
		return tab
	end

	if self:IsPlayer() and not self:GetNoDraw() then
		table.Add(tab, self:GetPlayerContextOptions(ply, interact))
	end

	if self.GetContextOptions then
		table.Add(tab, self:GetContextOptions(ply, interact))
	end

	if self:IsDoor() then
		table.Add(tab, self:GetDoorOptions(ply, interact))
	end

	if self:IsButton() then
		table.Add(tab, self:GetButtonOptions(ply, interact))
	end

	local canDescribe = not self:IsProtectedEntity() and (ply:IsAdmin() or (ply:ToolTrust() >= TOOLTRUST_ADVANCED and self:SteamID() == ply:SteamID()))

	if PERMAPROP_CLASSES[self:GetClass()] and canDescribe and interact then
		table.insert(tab, {
			Name = "Set Description",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Description", {
					Default = self:Description(),
					Max = GAMEMODE:GetConfig("MaxPropDescLength")
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = GAMEMODE:GetConfig("MaxPropDescLength")
				}, val) then
					return
				end

				self:SetDescription(val)
			end
		})
	end

	return tab
end