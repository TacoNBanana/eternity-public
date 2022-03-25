ITEM = class.Create("helmet_marine_basic")

ITEM.Name 			= "ODST Helmet"
ITEM.Description 	= "A standard ODST helmet meant to fulfill a variety of combat roles. Comes packaged with a balaclava."

ITEM.Color 			= Color(145, 145, 145)
ITEM.OutlineColor 	= Color(109, 109, 109)

ITEM.EquipmentSlots = {EQUIPMENT_HEAD}

ITEM.License 		= false

ITEM.ModelGroups 	= {"ODST"}

ITEM.HelmetGroup 	= 2

ITEM.Filtered 		= true

function ITEM:OnUnequip(ply, slot, unloading)
	ply:SetVISR(false)

	self:ParentCall("OnUnequip", ply, slot, unloading)
end

function ITEM:GetContextOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Toggle VISR",
		Callback = function()
			ply:SetVISR(not ply:VISR())
		end
	})

	return tab
end

if SERVER then
	function ITEM:GetModelData(ply)
		local tab = {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self.HelmetGroup,
					Face = self.Balaclava and 1 or 0
				}
			}
		}

		if self.Visor then
			tab._base.Materials = {
				["models/ishis_garage/halo_rebirth/marines/odst/odst_helmets_visor"] = "models/props_combine/citadel_cable_b"
			}
		end

		return tab
	end
end

return ITEM