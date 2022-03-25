ITEM = class.Create("base_item")

ITEM.ItemGroup 			= "Consumable"

ITEM.UseSelf 			= false
ITEM.SelfString 		= "Use on self"

ITEM.UseTarget 			= false
ITEM.TargetString 		= "Use on target"

function ITEM:GetOptions(ply)
	local tab = {}

	if self.UseSelf then
		table.insert(tab, {
			Name = self.SelfString,
			Callback = function()
				self:OnSelfUse(ply)
			end
		})
	end

	if self.UseTarget then
		local target = ply:GetEyeTrace().Entity

		if IsValid(target) and self:IsValidTarget(target) and target:WithinInteractRange(ply) then
			table.insert(tab, {
				Name = self.TargetString,
				Callback = function()
					self:OnTargetUse(ply, target)
				end
			})
		end
	end

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

function ITEM:IsValidTarget(target)
	return false
end

if SERVER then
	function ITEM:OnSelfUse(ply)
	end

	function ITEM:OnTargetUse(ply, target)
	end
end

return ITEM