CIVRP_Events["AntlionBurrow"] = {}
CIVRP_Events["AntlionBurrow"].Chance = 50
CIVRP_Events["AntlionBurrow"].Condition = function(ply) 
	return true
end
CIVRP_Events["AntlionBurrow"].Function = function(ply)	
	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = {Class = "npc_antlion"}
	Minions.Number = math.random(1,4)
	
	for i = 1, Minions.Number do
		local distance = math.random(100, 200)
		local angle = math.random(0, 360)
		local MinionSelection = table.Random(Minions.Type)
		local npc = ents.Create(MinionSelection.Class)
		npc:SetPos(ply:GetPos() + (Vector(math.cos(angle) * (distance + 500), math.sin(angle) * (distance + 500))))
		npc:SetKeyValue("startburrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
	end
end