local function created(ent)
	-- Fuck you gredwitch
	timer.Simple(0.1, function()
		if not IsValid(ent) then
			return
		end

		if ent.isWacAircraft and ent.CustomThink then
			local old = ent.Think

			ent.Think = function(self)
				old(self)

				self:CustomThink()
			end
		end
	end)
end


if CLIENT then
	hook.Add("NetworkEntityCreated", "wac.NetworkEntityCreated", created)
else
	hook.Add("OnEntityCreated", "wac.OnEntityCreated", created)
end