function CIVRP_CreateThreat()
	local ply = table.Random(player.GetAll())
	local tbl = {}
	for _,data in pairs(CIVRP_Threats) do
		if data.Condition(ply) then
			table.insert(tbl,_)
		end
	end
	if table.Count(tbl) >= 1 then
		CIVRP_Threats[table.Random(tbl)].Function(ply)
	end
	timer.Simple(60,function() CIVRP_CreateThreat() end)
end
--timer.Simple(60,function() CIVRP_CreateThreat() end)

CIVRP_Threats = {}

CIVRP_Threats["Ambush"] = {
	Condition = function(ply) 
		if table.Count(ents.FindByClass("npc_*")) >= 5 then
			return false
		end
		if IsDay() then
			if ply:Health() >=  50 then
				return true
			end
		else
			return true
		end
		return false
	end,
	Function = function(ply)
				local Bosses = {{Class = "npc_antlionguard",Number = math.random(1,2),MinionsNumber = math.random(1,3), Minions =  {{Class = "npc_antlion"},{Class ="npc_antlion_worker"}}},{Class = "npc_hunter",Number = math.random(1,3),MinionsNumber = math.random(1,3),Minions =  {{Class = "npc_hunter"},{Class = "npc_combine_s",Weapon = "weapon_ar2"},{Class = "npc_combine_s",Weapon = "weapon_smg1"}}},}
					local Selection = table.Random(Bosses) 
					for i = 1, Selection.Number do
						local npc = ents.Create(Selection.Class)
						npc:SetPos(ply:GetPos() + Vector(math.random(-1500,1500),math.random(-1500,1500),0))
						npc:Spawn()
						npc:Activate()
						for i = 1, Selection.MinionsNumber do
							local MinionSelection = table.Random(Selection.Minions)
							local npc = ents.Create(MinionSelection.Class)
							npc:SetPos(ply:GetPos() + Vector(math.random(-1500,1500),math.random(-1500,1500),0) )
							if MinionSelection.Weapon != nil then
								npc:SetKeyValue( "additionalequipment", MinionSelection.Weapon )
							end
							npc:Spawn()		
							npc:Activate()
						end
					end
				
	end,	
}

