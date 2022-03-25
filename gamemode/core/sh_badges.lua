local meta = FindMetaTable("Player")

local badges = {
	admin = {Name = "Admin", Material = Material("icon16/shield.png")},
	superadmin = {Name = "Superadmin", Material = Material("icon16/shield_add.png")},
	dev = {Name = "Developer", Material = Material("icon16/tag.png")},
	OOC = {Name = "OOC Muted", Material = Material("icon16/keyboard_mute.png")},
	donator = {Name = "Donator", Material = Material("icon16/ruby.png")},
	outlands = {Name = "In Outlands", Material = Material("icon16/weather_clouds.png")}
}

if CLIENT then
	function meta:GetBadges()
		local tab = {}

		if self:IsDeveloper() then
			table.insert(tab, badges.dev)
		elseif self:IsSuperAdmin() then
			table.insert(tab, badges.superadmin)
		elseif self:IsAdmin() then
			table.insert(tab, badges.admin)
		end

		if self:OOCMuted() then
			table.insert(tab, badges.OOC)
		end

		if self:Donator() and not self:DonatorHidden() then
			table.insert(tab, badges.donator)
		end

		if LocalPlayer():IsAdmin() and self:InOutlands() then
			table.insert(tab, badges.outlands)
		end

		for k, v in pairs(BADGES) do
			if self:HasBadge(k) then
				table.insert(tab, v)
			end
		end

		return tab
	end
end

function meta:HasBadge(id)
	return tobool(bit.band(self:Badges(), 2^(id - 1)))
end

function meta:GiveBadge(id)
	if self:HasBadge(id) then
		return
	end

	self:SetBadges(self:Badges() + 2^(id - 1))
end

function meta:TakeBadge(id)
	if not self:HasBadge(id) then
		return
	end

	self:SetBadges(self:Badges() - 2^(id - 1))
end