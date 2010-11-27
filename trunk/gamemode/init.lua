--Include shared lua files
include( 'shared.lua' )
include( 'day_night.lua' )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
	if string.find(file,".lua") then
		AddCSLuaFile('client/'..file)
	end
end
for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
	if string.find(file,".lua") then
		AddCSLuaFile('shared/'..file)
		print("include('shared/'..file)")
	end
end
for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
	if string.find(file,".lua") then
		include('server/'..file)
	end
end


