--Include shared lua files
include("shared.lua")
include("sh_resource")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_resource")

function GM:PlayerLoadout(ply)
	ply:Give("civrp_hands")
	ply:Give("weapon_smg1")
	ply:Give("weapon_pistol")
	ply:Give("weapon_crowbar")
end
