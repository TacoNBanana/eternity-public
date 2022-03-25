ITEM = class.Create("base_consumable")

ITEM.Name 				= "Biofoam canister"
ITEM.Description 		= "A single-use canister of biofoam, acts as a temporary sealant to help keep damaged organs in place and to stop bleeding. For best results, inject directly into the wound."

ITEM.Model 				= Model("models/valk/h3odst/unsc/props/biofoam/biofoam.mdl")

ITEM.License 			= LICENSE_QM

ITEM.UseTarget 			= true
ITEM.TargetString 		= "Heal target"

function ITEM:IsValidTarget(target)
	return target:IsPlayer() and target:Health() < (target:GetMaxHealth() * 0.5)
end

if SERVER then
	function ITEM:OnTargetUse(ply, target)
		ply:VisibleMessage(string.format("%s begins to inject %s's wounds with biofoam...", ply:RPName(), target:RPName()))

		if not ply:WaitFor(4, "Injecting...", {target}) then
			return
		end

		ply:VisibleMessage(string.format("%s injects %s's wounds with biofoam.", ply:RPName(), target:RPName()))

		target:SetHealth(math.max(target:Health(), target:GetMaxHealth() * 0.5))

		GAMEMODE:DeleteItem(self)
	end
end

return ITEM