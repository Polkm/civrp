CIVRP_Events["Ambush"] = {}
CIVRP_Events["Ambush"].Condition = function(ply) 
	--if table.Count(ents.FindByClass("npc_*")) >= 5 then return false end
	if IsDay() and ply:Health() <= 30 then return false else return true end
	return false
end
CIVRP_Events["Ambush"].Function = function(ply)
	local Bosses = {}
	Bosses[1] = {}
	Bosses[1].Class = "npc_antlionguard"
	Bosses[1].Skins = {0, 1}
	Bosses[1].Number = math.random(1, 2)
	Bosses[1].MinionsNumber = math.random(2, 3)
	Bosses[1].HealthFactor = 0.9 --Tad too hard so nerf it a bit
	Bosses[1].Minions = {}
	Bosses[1].Minions[1] = {Class = "npc_antlion", Skins = {0, 1, 2, 3}}
	Bosses[1].Minions[2] = {Class = "npc_antlion_worker"}
	
	Bosses[2] = {}
	Bosses[2].Class = "npc_hunter"
	Bosses[2].Number = math.random(1, 3)
	Bosses[2].MinionsNumber = math.random(2, 4)
	Bosses[2].HealthFactor = 1.1 --Tad too easy make it harder
	Bosses[2].Minions = {}
	Bosses[2].Minions[1] = {Class = "npc_combine_s",
		KeyValues = {additionalequipment = {"weapon_ar2", "weapon_smg1"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	Bosses[2].Minions[2] = {Class = "npc_combine_s",
		Skins = {1}, KeyValues = {additionalequipment = {"weapon_shotgun"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	--Forest Ranger that uses a custom mat
	--Bosses[2].Minions[3] = {Class = "npc_combine_s", Mat = "Models/Combine_soldier/combinesoldiersheet_forestranger",
	--	KeyValues = {additionalequipment = {"weapon_ar2", "weapon_shotgun"}, NumGrenades = {Min = 0, Max = 2}, tacticalvariant = {true}}}
	Bosses[2].Minions[4] = {Class = "npc_manhack"}
	
	Bosses[3] = {}
	Bosses[3].Class = "npc_fastzombie"
	Bosses[3].Number = math.random(1, 4)
	Bosses[3].MinionsNumber = math.random(2, 5)
	Bosses[3].Minions = {}
	Bosses[3].Minions[1] = {Class = "npc_poisonzombie"}
	Bosses[3].Minions[2] = {Class = "npc_zombie"}
	
	local Selection = table.Random(Bosses)
	for i = 1, Selection.Number do
		local boss = CreateCustomNPC(Selection.Class, Selection.Class .. CurTime(), Selection.HealthFactor, Selection.Mat, Selection.Skins, Selection.KeyValues)
		boss:SetPos(GetRandomRadiusPos(ply:GetPos() + Vector(0, 0, 10), 200, 1200))
		boss:Spawn()
		boss:Activate()
		for i = 1, Selection.MinionsNumber do
			local tblMinion = table.Random(Selection.Minions)
			local npc = CreateCustomNPC(tblMinion.Class, Selection.Class .. CurTime(), tblMinion.HealthFactor, tblMinion.Mat, tblMinion.Skins, tblMinion.KeyValues)
			npc:SetPos(GetRandomRadiusPos(ply:GetPos() + Vector(0, 0, 10), 200, 1200))
			npc:Spawn()
			npc:Activate()
		end
	end
end