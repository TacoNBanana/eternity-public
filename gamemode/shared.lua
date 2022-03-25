-- 16/8/2018

DeriveGamemode("sandbox")

GM.Name = "TnB Halo RP"
GM.Author = "TankNut"

includes.File("enums.lua")

includes.File("lib/sh_utils.lua")
includes.File("lib/sh_queue.lua")
includes.File("lib/sh_log.lua")
includes.File("lib/sh_pon.lua")
includes.File("lib/sv_dbal.lua")
includes.File("lib/sh_netstream.lua")
includes.File("lib/sh_accessor.lua")
includes.File("lib/sh_class.lua")
includes.File("lib/cl_markleft.lua")
includes.File("lib/sh_model.lua")
includes.File("lib/cl_part.lua")
includes.File("lib/sh_console.lua")
includes.File("lib/cl_heartbeat.lua")
includes.File("lib/sv_ban.lua")
includes.File("lib/sv_linuxcolorfix.lua")
includes.File("lib/sh_chttp.lua")
includes.File("lib/sv_playerreg.lua")
includes.File("lib/sv_prometheus.lua")
includes.File("lib/sh_base64.lua")
includes.File("lib/cl_outline.lua")

GM.Config = GM.Config or {}

includes.File("config/cl_motd.lua")
includes.File("config/cl_names.lua")
includes.File("config/sh_config.lua")
includes.File("config/sv_config.lua")
includes.File("config/sv_sql.lua")

local files = {
	string.format("config/sh_%s.lua", game.GetPort())
}

for _, v in pairs(files) do
	if file.Exists(includes.CurrentFolder(1) .. v, "LUA") then
		includes.File(v)
	end
end

includes.Folder("core")
includes.Folder("core/classes")
includes.Folder("core/gui") -- guis
includes.Folder("core/logtypes")
includes.Folder("core/commands")
includes.Folder("core/ctp")

includes.Folder("vgui") -- panels

hook.Add("ShutDown", "shared.ShutDown", function()
	GAMEMODE.IsShuttingDown = true
end)