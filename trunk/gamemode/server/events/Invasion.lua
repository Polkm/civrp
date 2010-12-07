CIVRP_Events["Invasion"] = {}
CIVRP_Events["Invasion"].Chance = 50
CIVRP_Events["Invasion"].Condition = function(ply) 
	if (IsDay()) then return false end
	if (ply:Health() <= 30) then return false end
	if (table.Count(player.GetAll()) < 4) then return false end
	local NearPlayers = {}
	for _,v in pairs(player.GetAll()) do
		if (v:GetPos():Distance(ply:GetPos() < 300)) then
			table.insert(NearPlayers, v)
		end
	end
	if (table.Count(NearPlayers) < 4) then return false end
	return true
end
CIVRP_Events["Invasion"].Function = function(ply)
	local Invasion = {}
	Invasion.Class = "npc_antlionguard"
	Invasion.Skins = {0, 1}
	Invasion.Number = math.random(1, 2)
	Invasion.MinionsNumber = math.random(5, 10)
	Invasion.HealthFactor = 0.9 --Tad too hard so nerf it a bit
	Invasion.Minions = {}
	Invasion.Minions[1] = {Class = "npc_antlion", Skins = {0, 1, 2, 3}}
	Invasion.Minions[2] = {Class = "npc_antlion_worker"}
	
	for i = 1, Invasion.Number do
		local boss = CreateCustomNPC(Invasion.Class, Invasion.Class .. CurTime(), Invasion.HealthFactor, Invasion.Mat, Invasion.Skins, Invasion.KeyValues)
		boss:SetPos(GetRandomRadiusPos(ply:GetPos() + Vector(0, 0, 10), 200, 1200))
		boss:Spawn()
		boss:Activate()
		CheckDistanceFunction(boss, 500, 120)
		for i = 1, Invasion.MinionsNumber do
			local tblMinion = table.Random(Invasion.Minions)
			local npc = CreateCustomNPC(tblMinion.Class, Invasion.Class .. CurTime(), tblMinion.HealthFactor, tblMinion.Mat, tblMinion.Skins, tblMinion.KeyValues)
			npc:SetPos(GetRandomRadiusPos(ply:GetPos() + Vector(0, 0, 10), 200, 1200))
			npc:Spawn()
			npc:Activate()
			CheckDistanceFunction(npc, 500, 120)
		end
	end
end