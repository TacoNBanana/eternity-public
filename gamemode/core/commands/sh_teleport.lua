console.AddCommand("rpa_goto", function(ply, target)
	ply:SetPos(target:GetPos())
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_FORCESINGLETARGET, CFLAG_NOSELFTARGET, CFLAG_NOCONSOLE},
"Teleport", "Sends yourself to another player")

console.AddCommand("rpa_bring", function(ply, targets)
	for _, v in pairs(targets) do
		v:SetPos(ply:GetPos())
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_NOSELFTARGET, CFLAG_NOCONSOLE},
"Teleport", "Sends another player to you")

console.AddCommand("rpa_send", function(ply, from, to)
	from:SetPos(to:GetPos())
end, COMMAND_ADMIN, {CTYPE_PLAYER, CTYPE_PLAYER}, {CFLAG_FORCESINGLETARGET, CFLAG_NOSELFTARGET},
"Teleport", "Sends one player to another")

console.AddCommand({"rpa_tp", "rpa_teleport"}, function(ply, targets)
	local pos = ply:GetEyeTrace().HitPos

	for _, v in pairs(targets) do
		v:SetPos(pos)
	end
end, COMMAND_ADMIN, {CTYPE_PLAYER}, {CFLAG_NOCONSOLE},
"Teleport", "Send a player to wherever you're looking")