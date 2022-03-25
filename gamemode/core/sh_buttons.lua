local emeta = FindMetaTable("Entity")

GM.Buttons = GM.Buttons or {}

accessor.Entity("IsButton", "Entity", false)
accessor.Entity("ButtonName", "Entity", "")
accessor.Entity("ButtonDisabled", "Entity", false)

function emeta:GetButtonOptions(ply, interact)
	local tab = {}

	if not interact then
		return tab
	end

	if ply:IsInEditMode() then
		table.insert(tab, {
			Name = self:ButtonDisabled() and "Enable" or "Disable",
			Callback = function(val)
				self:SetButtonDisabled(not self:ButtonDisabled())

				GAMEMODE:QueueButtonSave()
			end
		})

		table.insert(tab, {
			Name = "Set Name",
			Client = function()
				return GAMEMODE:OpenGUI("Input", "string", "Set Title", {
					Default = self:ButtonName(),
					Max = 30
				})
			end,
			Callback = function(val)
				if not GAMEMODE:CheckInput("string", {
					Max = 30
				}, val) then
					return
				end

				self:SetButtonName(val)

				GAMEMODE:QueueButtonSave()
			end
		})
	end

	return tab
end

hook.Add("EntityIsButtonChanged", "buttons.EntityIsButtonChanged", function(ent, old, new)
	if new then
		table.insert(GAMEMODE.Buttons, ent)
	end
end)