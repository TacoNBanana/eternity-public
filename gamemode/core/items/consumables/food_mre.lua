ITEM = class.Create("base_consumable")

ITEM.Name 				= "MRE"
ITEM.Description 		= "A vacuum sealed bag containing a pre-cooked meal and a number of miscellaneous food items including protein bars, instant coffee and nutritional supplements. Guaranteed to remain edible for years."

ITEM.Model 				= Model("models/ishi/halo_rebirth/props/human/mre.mdl")

ITEM.Height 			= 1

ITEM.License 			= LICENSE_QM

ITEM.UseSelf 			= true
ITEM.SelfString 		= "Eat"

if SERVER then
	function ITEM:OnSelfUse(ply)
		ply:VisibleMessage(ply:RPName() .. " opens their MRE and eats the contents.")

		GAMEMODE:DeleteItem(self)
	end
end

return ITEM