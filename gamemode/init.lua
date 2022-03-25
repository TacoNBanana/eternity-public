AddCSLuaFile("lib/sh_includes.lua")
include("lib/sh_includes.lua")

includes.File("shared.lua")

local folders = {
	"eternity",
	"eternity/maps",
	"eternity/permaprops"
}

hook.Add("Initialize", "init.Initialize", function()
	for _, v in pairs(folders) do
		if not file.Exists(v, "DATA") then
			file.CreateDir(v)
		end
	end

	local mapfile = string.format("eternity/maps/%s.txt", game.GetPort())

	if file.Exists(mapfile, "DATA") then
		local map = file.Read(mapfile, "DATA")

		if map and map != game.GetMap() and table.HasValue(game.GetMaps(), map) then
			GAMEMODE.MapOverride = map
		end
	end

	RunConsoleCommand("mp_falldamage", 1)

	concommand.Remove("gm_save")
end)

CreateConVar("debug_sql", 0)
CreateConVar("debug_netstream", 0)
CreateConVar("debug_replicated", 0)
CreateConVar("debug_accessors", 0)
CreateConVar("debug_logs", 1)