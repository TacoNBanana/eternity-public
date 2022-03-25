ITEM = class.Create("base_item")

ITEM.Description 		= "Can be used to change your appearance."

ITEM.OutlineColor 		= Color(180, 220, 32)

ITEM.EquipmentSlots 	= {EQUIPMENT_XEN}

ITEM.ItemGroup 			= "Xenian"

ITEM.Voicelines 		= {}

function ITEM:OnEquip(ply, slot, loading)
	if SERVER and not loading then
		ply:HandlePlayerModel()

		if self.ArmorLevel > 0 then
			ply:HandleArmorLevel()
		end

		ply:HandleMoveSpeed()
	end
end

function ITEM:OnUnequip(ply, slot, unloading)
	if SERVER and not unloading then
		ply:HandlePlayerModel()

		if self.ArmorLevel > 0 then
			ply:HandleArmorLevel()
		end

		ply:HandleMoveSpeed()
	end
end

function ITEM:GetVoicelines(ply)
	return self.Voicelines
end

if SERVER then
	function ITEM:GetSpeeds(ply)
	end
end

return ITEM