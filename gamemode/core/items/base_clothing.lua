ITEM = class.Create("base_item")

ITEM.Model 			= Model("models/valk/h3/unsc/props/crates/case.mdl")

ITEM.ModelGroups 	= {}

function ITEM:GetModelGroup(ply)
	local undersuit = ply:GetEquipment(EQUIPMENT_UNDERSUIT)

	return undersuit and undersuit.ModelGroup or "Off-Duty"
end

if CLIENT then
	function ITEM:GetTags()
		local tags = self:ParentCall("GetTags")

		for _, v in pairs(self.ModelGroups) do
			table.insert(tags, v)
		end

		return tags
	end
end

function ITEM:CanEquip(ply)
	return table.HasValue(self.ModelGroups, self:GetModelGroup(ply))
end

return ITEM