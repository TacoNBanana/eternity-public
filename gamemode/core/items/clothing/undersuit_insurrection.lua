ITEM = class.Create("base_undersuit")

ITEM.Name 				= "Insurrection Undersuit"
ITEM.Description 		= "A standard UNSC undersuit and armor set that's been modified by the URF."

ITEM.Color 				= Color(145, 145, 145)
ITEM.OutlineColor 		= Color(255, 0, 0)

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.ArmorLevel 		= ARMOR_LIGHT

ITEM.Team 				= TEAM_INSURRECTION

ITEM.ModelPattern 		= "models/ishi/suno/halo_rebirth/player/innie/%s/innie_%s.mdl"
ITEM.ModelGroup 		= "Insurrection"

function ITEM:GetModelGroup(ply)
	return string.match(ply:CharModel(), "^.+/[^_]+_.-([^_]+).mdl")
end

return ITEM