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

CIVRP_Foilage_Models = { }
CIVRP_Foilage_Models[1] = 	"models/props_foliage/tree_pine04.mdl"
CIVRP_Foilage_Models[2] = 	"models/props_foliage/tree_pine05.mdl"
CIVRP_Foilage_Models[3] = 	"models/props_foliage/tree_pine06.mdl"
CIVRP_Foilage_Models[4] = 	"models/props_foliage/tree_dry01.mdl"
CIVRP_Foilage_Models[5] = 	"models/props_foliage/tree_dry02.mdl"
CIVRP_Foilage_Models[6] = 	"models/props_foliage/tree_dead01.mdl"
CIVRP_Foilage_Models[7] = 	"models/props_foliage/tree_dead02.mdl"
CIVRP_Foilage_Models[8] = 	"models/props_foliage/tree_dead03.mdl"
CIVRP_Foilage_Models[9] = 	"models/props_foliage/tree_dead04.mdl"
CIVRP_Foilage_Models[10] = 	"models/props_foliage/tree_pine04.mdl"
CIVRP_Foilage_Models[11] = 	"models/props_foliage/ferns01.mdl"
CIVRP_Foilage_Models[12] = 	"models/props_foliage/ferns02.mdl"
CIVRP_Foilage_Models[13] = 	"models/props_foliage/ferns03.mdl"
-- Watch the manual check for 11 and up in CL

CIVRP_SOLIDDISTANCE = 200
CIVRP_FADEDISTANCE = 3000
CIVRP_CHUNKSIZE = 1000
