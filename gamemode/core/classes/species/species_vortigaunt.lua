local CLASS = class.Create("base_species")

CLASS.Name 					= "Vortigaunt"
CLASS.Team 					= TEAM_VORTIGAUNT

CLASS.BaseHealth 			= 130

CLASS.WeaponLoadout 		= {"eternity_hands"}
CLASS.PlayerModels 			= {
	Model("models/vortigaunt.mdl")
}

CLASS.DisabledProperties 	= {}

CLASS.AllowStash 			= false
CLASS.GasImmune 			= true

CLASS.EquipmentSlots 		= {EQUIPMENT_VORTS}
CLASS.WeaponSlots 			= {EQUIPMENT_ID, EQUIPMENT_BROOM}

CLASS.ArmorLevel 			= ARMOR_LIGHT

CLASS.MoveSpeed 			= {
	Walk = 44,
	Run = 140,
	Jump = 210,
	Crouch = 44
}

if SERVER then
	function CLASS:InitialSetup(ply)
		local shackles = GAMEMODE:CreateItem("vort_shackles")

		ply:GetInventory(EQUIPMENT_VORTS):AddItem(shackles, 1, 1)
	end
end

return CLASS