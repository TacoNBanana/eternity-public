local meta = FindMetaTable("Player")

function meta:TakeMoney(amount)
	return self:TakeItem("money", amount)
end

function meta:GiveMoney(amount)
	self:GiveItem("money", amount)
end

function meta:GiveLicense(id)
	if self:HasLicense(id) then
		return
	end

	self:SetBusinessLicenses(self:BusinessLicenses() + 2^(id - 1))
end

function meta:TakeLicense(id)
	if not self:HasLicense(id) then
		return
	end

	self:SetBusinessLicenses(self:BusinessLicenses() - 2^(id - 1))
end

netstream.Hook("BuyLicense", function(ply, data)
	local license = data.License

	if not LICENSES[license] then
		return
	end

	local tab = LICENSES[license]

	if ply:HasLicense(license) or not tab.Price then
		return
	end

	if not ply:HasMoney(tab.Price) then
		return
	end

	ply:TakeMoney(tab.Price)

	for k, v in pairs(LICENSES) do
		if not v.Price then
			continue
		end

		if k == license then
			ply:GiveLicense(k)
		else
			ply:TakeLicense(k)
		end
	end

	GAMEMODE:WriteLog("character_buylicense", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		License = license
	})

	netstream.Send("UpdateBusiness", {
		Items = true
	}, ply)
end, {
	License = {Type = TYPE_NUMBER}
})

netstream.Hook("BuyItem", function(ply, data)
	local item = class.Get(data.Class)
	local amount = data.Amount or 1
	local stacking = item:IsTypeOf("base_stacking")

	if not stacking then
		amount = 1
	end

	if not ply:CanBuyItem(data.Class, amount) then
		return
	end

	if item.UnitPrice > 0 then
		local cost = math.ceil(item.UnitPrice * amount)

		if not ply:HasMoney(cost) then
			return
		end

		ply:TakeMoney(cost)
	end

	ply:GiveItem(data.Class, amount)

	GAMEMODE:WriteLog("item_bought", {
		Ply = GAMEMODE:LogPlayer(ply),
		Char = GAMEMODE:LogCharacter(ply),
		Amount = amount,
		Class = data.Class,
		Price = cost
	})

	netstream.Send("UpdateBusiness", {}, ply)
end, {
	Class = {Type = TYPE_STRING},
	Amount = {Type = TYPE_NUMBER, Optional = true}
})