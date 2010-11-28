function AutoAdd_LuaFiles()
	if SERVER then
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				AddCSLuaFile('client/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				AddCSLuaFile('shared/'..file)
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
			if string.find(file,".lua") then
				include('server/'..file)
				Msg(file..",")
			end
		end
	else
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				include('client/'..file)
				Msg(file..",")
			end
		end
	end
end

GM.Name 		= "Civilization Role Play"
GM.Author 		= "Noobulater"
GM.Email 		= "killerkat48@yahoo.com"
GM.Website 		= ""
GM.TeamBased 	= false

GM.Path = "CivRP";

CIVRP_Enviorment_Models = { }
CIVRP_Enviorment_Models[1] = 	{ID = 1, Model = "models/props_foliage/tree_pine04.mdl", Solid = true}
CIVRP_Enviorment_Models[2] = 	{ID = 2, Model = "models/props_foliage/tree_pine05.mdl", Solid = true}
CIVRP_Enviorment_Models[3] = 	{ID = 3, Model = "models/props_foliage/tree_pine06.mdl", Solid = true}
CIVRP_Enviorment_Models[4] = 	{ID = 4, Model = "models/props_foliage/tree_dry01.mdl", Solid = true}
CIVRP_Enviorment_Models[5] = 	{ID = 5, Model = "models/props_foliage/tree_dry02.mdl", Solid = true}
CIVRP_Enviorment_Models[6] = 	{ID = 6, Model = "models/props_foliage/tree_dead01.mdl", Solid = true}
CIVRP_Enviorment_Models[7] = 	{ID = 7, Model = "models/props_foliage/tree_dead02.mdl", Solid = true}
CIVRP_Enviorment_Models[8] = 	{ID = 8, Model = "models/props_foliage/tree_dead03.mdl", Solid = true}
CIVRP_Enviorment_Models[9] = 	{ID = 9, Model = "models/props_foliage/tree_dead04.mdl", Solid = true}
CIVRP_Enviorment_Models[10] = 	{ID = 10, Model = "models/props_foliage/tree_pine04.mdl", Solid = true}
CIVRP_Enviorment_Models[11] = 	{ID = 11, Model = "models/props_foliage/ferns01.mdl", Solid = false}
CIVRP_Enviorment_Models[12] = 	{ID = 12, Model = "models/props_foliage/ferns02.mdl", Solid = false}
CIVRP_Enviorment_Models[13] = 	{ID = 13, Model = "models/props_foliage/ferns03.mdl", Solid = false}
-- Watch the manual check for 11 and up in CL

CIVRP_SOLIDDISTANCE = 200
CIVRP_FADEDISTANCE = 3000
CIVRP_CHUNKSIZE = 1000
CIVRP_ENVIORMENTSIZE = 8000