CIVRP_Events["Patrol"] = {}
CIVRP_Events["Patrol"].Chance = 40
CIVRP_Events["Patrol"].Condition = function(ply) 
	return true
end
CIVRP_Events["Patrol"].Function = function(ply)
	local Bosses = {}
	
	Bosses[1] = {}
	Bosses[1].Class = "npc_hunter"
	Bosses[1].Number = math.random(1, 1)
	Bosses[1].MinionsNumber = math.random(1, 3)
	Bosses[1].HealthFactor = 1.1 --Tad too easy make it harder
	Bosses[1].Minions = {}
	--Bosses[2].Minions[1] = {Class = "npc_hunter"}
	Bosses[1].Minions[1] = {Class = "npc_combine_s",
		KeyValues = {additionalequipment = {"weapon_ar2", "weapon_smg1"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	Bosses[1].Minions[2] = {Class = "npc_combine_s",
		Skins = {1}, KeyValues = {additionalequipment = {"weapon_shotgun"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	Bosses[1].Minions[2] = {Class = "npc_manhack"}
	
	local Selection = table.Random(Bosses) 
	for i = 1, Selection.Number do
		local boss = CreateCustomNPC(Selection.Class, Selection.Class .. CurTime(), Selection.HealthFactor, Selection.Mat, Selection.Skins, Selection.KeyValues)
		boss:SetPos(GetRandomRadiusPos(ply:GetPos() + Vector(0, 0, 10), 2000, 3000))
		boss:Spawn()
		boss:Activate()
		CheckDistanceFunction(boss, 500, 120)
		for i = 1, Selection.MinionsNumber do
			local tblMinion = table.Random(Selection.Minions)
			local npc = CreateCustomNPC(tblMinion.Class, Selection.Class .. CurTime(), tblMinion.HealthFactor, tblMinion.Mat, tblMinion.Skins, tblMinion.KeyValues)
			npc:SetPos(GetRandomRadiusPos(boss:GetPos() + Vector(0, 0, 10), 100, 200))
			npc:Spawn()
			npc:Activate()
			CheckDistanceFunction(npc, 500, 120)
		end
	end
end