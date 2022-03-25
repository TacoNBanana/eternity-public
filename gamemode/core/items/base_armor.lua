ITEM = class.Create("base_item")

ITEM.OutlineColor 		= Color(110, 76, 170)

ITEM.EquipmentSlots 	= {EQUIPMENT_ARMOR}

ITEM.ItemGroup 			= "Armor"

ITEM.Species 			= SPECIES_GRUNT

function ITEM:CanEquip(ply)
	return ply:Species() == self.Species
end

return ITEM