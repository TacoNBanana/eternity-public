SWEP.SavedAmmo = {}

function SWEP:SetupFiremodes()
	self.Firemodes = table.Copy(weapons.GetStored(self:GetClass()).Firemodes)

	for index, firemode in ipairs(self.Firemodes) do
		local instance = class.Instance(firemode.Mode, self)

		firemode.Vars = firemode.Vars or {}

		for k, v in pairs(firemode.Vars) do
			instance[k] = v
		end

		self.Firemodes[index] = instance
	end
end

function SWEP:GetFiremode(index)
	if not index then
		return self.StoredMode
	end

	return self.Firemodes[index]
end

function SWEP:CycleFiremode()
	if CurTime() < self:GetNextModeSwitch() then
		return
	end

	if #self.Firemodes < 2 then
		return
	end

	local old = self:GetFiremodeIndex()
	local new = old + 1

	if new > #self.Firemodes then
		new = 1
	end

	self:SetFiremode(old, new)

	if CLIENT then
		self:EmitSound("weapons/smg1/switch_single.wav")
	end
end

function SWEP:SetFiremode(old, new)
	if old == 0 then
		old = 1
	end

	if new == 0 then
		new = 1
	end

	local newmode = self:GetFiremode(new)

	self:SetFiremodeIndex(new)
	self.StoredMode = newmode

	if old then
		local oldmode = self:GetFiremode(old)

		oldmode:SwitchFrom()
	end

	newmode:SwitchTo()
end