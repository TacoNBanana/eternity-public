GM:RegisterLogType("item_spawned", LOG_ITEMS, function(data)
	return string.format("%s has spawned %s", GAMEMODE:FormatPlayer(data.Ply), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_bought", LOG_ITEMS, function(data)
	return string.format("%s has bought %s %s for %s credits", GAMEMODE:FormatCharacter(data.Char), data.Amount, data.Class, data.Price)
end)

GM:RegisterLogType("item_sold", LOG_ITEMS, function(data)
	return string.format("%s has sold %s for %s credits", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item), data.Price)
end)

GM:RegisterLogType("item_pickup", LOG_ITEMS, function(data)
	return string.format("%s has picked up %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_drop", LOG_ITEMS, function(data)
	return string.format("%s has dropped %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_destroy", LOG_ITEMS, function(data)
	return string.format("%s has destroyed %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_split", LOG_ITEMS, function(data)
	return string.format("%s has split %s into %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item), GAMEMODE:FormatItem(data.New))
end)

GM:RegisterLogType("item_merge", LOG_ITEMS, function(data)
	return string.format("%s has merged %s into %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.From), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_insert", LOG_ITEMS, function(data)
	return string.format("%s has inserted %s into %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item), GAMEMODE:FormatItem(data.Target))
end)

GM:RegisterLogType("item_eject", LOG_ITEMS, function(data)
	return string.format("%s has ejected %s from %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item), GAMEMODE:FormatItem(data.Target))
end)

GM:RegisterLogType("item_equip", LOG_ITEMS, function(data)
	return string.format("%s has equipped %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item))
end)

GM:RegisterLogType("item_unequip", LOG_ITEMS, function(data)
	return string.format("%s has unequipped %s", GAMEMODE:FormatCharacter(data.Char), GAMEMODE:FormatItem(data.Item))
end)