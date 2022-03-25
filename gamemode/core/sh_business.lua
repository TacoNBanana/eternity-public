local meta = FindMetaTable("Player")

function meta:GetBuyableItems()
	local tab = {}

	for k in pairs(GAMEMODE.ItemClasses) do
		local item = class.Get(k)

		if not item.License or not self:HasLicense(item.License) then
			continue
		end

		if item.UnitPrice <= 0 then
			continue
		end

		table.insert(tab, k)
	end

	return tab
end

function meta:CanBuyItem(classname, amount)
	if self:Restrained() then
		return false
	end

	if not class.Exists(classname) then
		return false
	end

	local item = class.Get(classname)

	if not item.License or not self:HasLicense(item.License) then
		return false
	end

	if item.UnitPrice <= 0 then
		return false
	end

	if self:InOutlands() and LICENSES[item.License].Price then -- Don't allow city licenses to be used in the outlands
		return false
	end

	if not self:HasMoney(math.ceil(item.UnitPrice * amount)) then
		return false
	end

	return true
end

function meta:CanSellItem(item)
	if not item:CanInteract(self) then
		return false
	end

	if not item.License or not self:HasLicense(item.License) then
		return false
	end

	if item.SellPrice <= 0 then
		return false
	end

	if self:InOutlands() and LICENSES[item.License].Price then -- Don't allow city licenses to be used in the outlands
		return false
	end

	return true
end

function meta:GetMoney()
	return self:GetItemCount("money")
end

function meta:HasMoney(amount)
	return self:HasItem("money", amount)
end

function meta:GetLicenses()
	local tab = {}

	for k in pairs(LICENSES) do
		if self:HasLicense(k) then
			table.insert(tab, k)
		end
	end

	return tab
end

function meta:HasLicense(id)
	return tobool(bit.band(self:BusinessLicenses(), 2^(id - 1)))
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