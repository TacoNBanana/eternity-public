ITEM = class.Create("base_item")

ITEM.Name 				= "Packed ration"
ITEM.Description 		= "An unopened ration package, folded up tightly for easier storage."

ITEM.Model 				= Model("models/props_junk/cardboard_box004a.mdl")

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Unpack",
		Callback = function()
			ply:SendChat("NOTICE", "You unfold the packaging.")

			GAMEMODE:DeleteItem(self)

			ply:GiveItem("ration_custom")
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

return ITEM