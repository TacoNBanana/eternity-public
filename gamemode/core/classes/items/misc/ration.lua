ITEM = class.Create("base_item")

ITEM.Name 				= "Ration"
ITEM.Description 		= "A hermetically sealed package containing a small selection of basic living supplies."

ITEM.Model 				= Model("models/weapons/w_package.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 2

ITEM.Contents 			= {
	{"food_water"},
	{"food_beans", "food_chinese"}
}

ITEM.Money 				= 60

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Open",
		Callback = function()
			ply:SendChat("NOTICE", "You rip open the ration, revealing its contents.")

			GAMEMODE:DeleteItem(self)

			for _, v in pairs(self.Contents) do
				ply:GiveItem(table.Random(v))
			end

			ply:GiveItem("money", self.Money, true)
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

return ITEM