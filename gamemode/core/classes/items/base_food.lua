ITEM = class.Create("base_item")

ITEM.Model 				= Model("models/props_junk/watermelon01.mdl")

ITEM.ItemGroup 			= "Food"
ITEM.ConsumeString		= "Eat"

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = self.ConsumeString,
		Callback = function()
			ply:SendChat("NOTICE", string.format("You %s the %s.", string.lower(self.ConsumeString), string.lower(self.Name)))

			GAMEMODE:DeleteItem(self)
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

return ITEM