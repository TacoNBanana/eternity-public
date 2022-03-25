ITEM = class.Create("base_consumable")

ITEM.Name 				= "Health pack"
ITEM.Description 		= "A standard UNSC first aid kit containing various medical supplies containing biofoam, a stitch kit, polypseudomorphine injectors, antiseptic battle dressings and other medical supplies."

ITEM.Model 				= Model("models/ishi/halo_rebirth/props/human/health_kit.mdl")

ITEM.Width 				= 2

ITEM.License 			= LICENSE_QM

ITEM.UseTarget 			= true
ITEM.TargetString 		= "Heal target"

function ITEM:IsValidTarget(target)
	return target:IsPlayer() and target:Health() < target:GetMaxHealth()
end

if SERVER then
	function ITEM:OnTargetUse(ply, target)
		ply:VisibleMessage(string.format("%s starts to perform first aid on %s...", ply:RPName(), target:RPName()))

		if not ply:WaitFor(10, "Healing...", {target}) then
			return
		end

		ply:VisibleMessage(string.format("%s finishes tending to %s's wounds.", ply:RPName(), target:RPName()))

		target:SetHealth(target:GetMaxHealth())

		GAMEMODE:DeleteItem(self)
	end
end

return ITEM