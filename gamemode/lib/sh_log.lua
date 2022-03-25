module("log", package.seeall)

function Default(...)
	local tab = {...}

	table.insert(tab, "\n")

	MsgC(Color(200, 200, 200), unpack(tab))
end