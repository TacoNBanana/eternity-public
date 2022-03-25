module("includes", package.seeall)

local function filename(path)
	return string.StripExtension(string.GetFileFromFilename(path))
end

function CurrentFolder(level)
	return string.Replace(string.GetPathFromFilename(debug.getinfo(level + 1, "S").short_src), "gamemodes/", "")
end

function Client(path)
	AddCSLuaFile(path)

	if CLIENT then
		return include(path)
	end
end

function Shared(path)
	AddCSLuaFile(path)

	return include(path)
end

function Server(path)
	if SERVER then
		return include(path)
	end
end

function File(path)
	local realm = string.Left(string.GetFileFromFilename(path), 3)

	if realm == "cl_" then
		return Client(path)
	elseif realm == "sv_" then
		return Server(path)
	else
		return Shared(path)
	end
end

function Folder(path)
	local src = CurrentFolder(2) .. path .. "/"
	local files = file.Find(src .. "*", "LUA")
	local returns = {}

	for _, v in pairs(files) do
		returns[filename(v)] = File(src .. v)
	end

	return returns
end