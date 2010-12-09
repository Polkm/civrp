--Include shared lua files
include("shared.lua")
include("sh_resource.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_resource.lua")

function GM:PlayerLoadout(ply)
	ply:Give("civrp_hands")
	
	timer.Simple(1,function() if ply:IsValid() then ply:AddItem(table.Random({"weapon_shotgun","weapon_crowbar","weapon_pistol","weapon_smg"}))  end end)
end
function GM:PlayerSpawn(ply)
	ply:SetPos(Vector(math.random(-13000,13000),math.random(-13000,13000),150))
	GAMEMODE:PlayerSetModel( ply )
	GAMEMODE:PlayerLoadout(ply)
end