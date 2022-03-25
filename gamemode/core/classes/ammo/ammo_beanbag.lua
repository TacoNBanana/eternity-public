AMMO = class.Create("ammo_ballistic")

AMMO.CDamage = 25

function AMMO:Callback(attacker, tr, dmginfo)
	if not SERVER then
		return
	end

	local ent = tr.Entity
	if not IsValid(ent) then
		return
	end

	if ent:IsPlayer() then
		ent:TakeCDamage(self.CDamage)
	elseif IsValid(ent:FakePlayer()) then
		ent:FakePlayer():TakeCDamage(self.CDamage)
	elseif ent:IsVehicle() and IsValid(ent:GetDriver()) then
		ent:GetDriver():TakeCDamage(self.CDamage)
	end
end

return AMMO