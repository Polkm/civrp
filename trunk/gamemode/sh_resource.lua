local ClientPaths = {}
ClientPaths[1] = "gamemode/client"

local ServerPaths = {}
ServerPaths[1] = "gamemode/server"
ServerPaths[2] = "gamemode/server/settlements"

local SharedPaths = {}
SharedPaths[1] = "gamemode/shared"
SharedPaths[2] = "gamemode/shared/items"

for _, strPaths in pairs(SharedPaths) do
	local Path = string.Replace(GM.Folder,"gamemodes/","").."/" .. strPaths .. "/"
	for _,v in pairs(file.FindInLua(Path.."*.lua")) do
		include(Path..v)
		if (SERVER) then
			AddCSLuaFile(Path..v)
		end
	end
end

if SERVER then
	for _, strPaths in pairs(ServerPaths) do
		local Path = string.Replace(GM.Folder,"gamemodes/","").."/" .. strPaths .. "/"
		for _,v in pairs(file.FindInLua(Path.."*.lua")) do
			include(Path..v)
		end
	end
	for _, strPaths in pairs(ClientPaths) do
		local Path = string.Replace(GM.Folder,"gamemodes/","").."/" .. strPaths .. "/"
		for _,v in pairs(file.FindInLua(Path.."*.lua")) do
			AddCSLuaFile(Path..v)
		end
	end
	function resource.AddDir(dir, ext)
		for _, f in pairs(file.Find("../" .. dir .. "/*" .. (ext or ""))) do
			resource.AddFile(dir .. "/" .. f)
		end
	end	
else
	for _, strPaths in pairs(ClientPaths) do
		local Path = string.Replace(GM.Folder,"gamemodes/","").."/" .. strPaths .. "/"
		for _,v in pairs(file.FindInLua(Path.."*.lua")) do
			include(Path..v)
		end
	end
end