ITEM = class.Create("base_item")

ITEM.Model 				= Model("models/valk/h3/unsc/props/crates/case.mdl")

ITEM.EquipmentSlots 	= {EQUIPMENT_UNDERSUIT}

ITEM.ModelPattern 		= ""
ITEM.ModelSkin 			= 0
ITEM.ModelGroup 		= ""

if CLIENT then
	function ITEM:GetTags()
		local tags = self:ParentCall("GetTags")

		table.insert(tags, self.ModelGroup)

		return tags
	end
end

function ITEM:GetDescription()
	local description = self:ParentCall("GetDescription")

	if not file.Exists(self:GetModel(LocalPlayer()), "GAME") then
		description = description .. "\n\n<col=255,0,0>This undersuit isn't compatible with your model.</col>"
	end

	return description
end

function ITEM:GetModelGroup(ply)
	return string.match(ply:CharModel(), "^.+/[^_]+_(.+).mdl")
end

function ITEM:GetModel(ply)
	return string.format(self.ModelPattern, GAMEMODE:GetGenderString(ply:CharModel()), self:GetModelGroup(ply))
end

function ITEM:CheckModelGroups(ply, group)
	local species = ply:GetActiveSpecies()

	for _, v in pairs(species.EquipmentSlots) do
		if v == EQUIPMENT_UNDERSUIT then
			continue
		end

		local equipment = ply:GetEquipment(v)

		if equipment and not table.HasValue(equipment.ModelGroups, group) then
			return false
		end
	end

	return true
end

function ITEM:CanEquip(ply)
	if not file.Exists(self:GetModel(ply), "GAME") then
		return false
	end

	if not self:CheckModelGroups(ply, self.ModelGroup) then
		return false
	end

	return true
end

function ITEM:CanUnequip(ply)
	return self:CheckModelGroups(ply, "Off-Duty")
end

if SERVER then
	function ITEM:GetModelData(ply)
		return {
			_base = {
				Model = self:GetModel(ply),
				Skin = self.ModelSkin
			}
		}
	end
end

return ITEM