ITEM = class.Create("base_item")

ITEM.Name 				= "Combine Lock"
ITEM.Description 		= "A portable combine lock."

ITEM.Model 				= Model("models/props_combine/combine_lock01.mdl")

ITEM.Width 				= 2
ITEM.Height 			= 3

function ITEM:GetOptions(ply)
	local tab = {}

	table.insert(tab, {
		Name = "Attach to Door",
		Callback = function()
			local tr = ply:GetEyeTrace()
			local ent = tr.Entity

			if not IsValid(ent) or not ent:IsDoor() or not ent:WithinInteractRange(ply) then
				ply:SendChat("ERROR", "You need to look directly at a door!")

				return
			end

			ent = ent:GetMainDoor()

			if ent:CombineLock() then
				ply:SendChat("ERROR", "This door already has a lock installed!")

				return
			end

			if ent:GetClass() != "prop_door_rotating" then
				ply:SendChat("ERROR", "This door type doesn't support a combine lock!")

				return
			end

			if ent:MapCreationID() == -1 then
				ply:SendChat("ERROR", "Combine locks only work with doors that are part of the map!")

				return
			end

			if ent:DoorType() != DOOR_PUBLIC then
				ply:SendChat("ERROR", "Combine locks can only be applied to public doors!")

				return
			end

			if not ply:HasPermission(PERMISSION_MAINTENANCE, true) then
				ply:SendChat("ERROR", "The lock requires maintenance access and a biosignal to set up!")

				return
			end

			ent:SetCombineLockSide(math.InRange((tr.HitNormal:Angle() - ent:GetAngles()).y, -1, 1))
			ent:SetCombineLock(true)

			GAMEMODE:DeleteItem(self)
		end
	})

	for _, v in pairs(self:ParentCall("GetOptions", ply)) do
		table.insert(tab, v)
	end

	return tab
end

return ITEM