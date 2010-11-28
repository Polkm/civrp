function CIVRP_CreateEvent()
	local ply = table.Random(player.GetAll())
	local tbl = {}
	for _,data in pairs(CIVRP_Events) do
		if data.Condition(ply) then
			table.insert(tbl,_)
		end
	end
	if table.Count(tbl) >= 1 then
		CIVRP_Events[table.Random(tbl)].Function(ply)
	end
	timer.Simple(math.random(55, 65), function() CIVRP_CreateEvent() end)
end
timer.Simple(10, function() CIVRP_CreateEvent() end)

CIVRP_Events = {}

CIVRP_Events["Ambush"] = {
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
				local Bosses = {{Class = "npc_antlionguard",Number = math.random(1,2),MinionsNumber = math.random(1,3), Minions =  {{Class = "npc_antlion"},{Class ="npc_antlion_worker"}}},{Class = "npc_hunter",Number = math.random(1,2),MinionsNumber = math.random(1,2),Minions =  {{Class = "npc_hunter"},{Class = "npc_combine_s",Weapon = "weapon_ar2"},{Class = "npc_combine_s",Weapon = "weapon_smg1"}}},}
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

CIVRP_Events["Healthkit"] = {
	Condition = function(ply) 
		if ply:Health() < 100 then
			return true
		end
		return false
	end,
	Function = function(ply)
				local item = ents.Create("item_healthkit")
				item:SetPos(ply:GetPos() + Vector(math.random(-1000,1000),math.random(-1000,1000),10))
				item:Spawn()
				item:Activate()
				item.Think = function() 
								if item:IsValid() then 
									for _,ply in pairs(player.GetAll()) do 
										if ply:GetPos():Distance(item:GetPos()) < 300 then 
											timer.Simple(60,function() if item:IsValid() then item.Think() end end)
											return false 
										end
									end
									item:Remove() 
								end 					
							end 
				timer.Simple(60,function() if item:IsValid() then item.Think() end end)
	end,	
}

CIVRP_Events["Supply"] = {
	Condition = function(ply) 
		return true
	end,
	Function = function(ply)
				local SupplyList = {"item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",}
				local item = ents.Create(table.Random(SupplyList))
				item:SetPos(ply:GetPos() + Vector(math.random(-1000, 1000),math.random(-1000, 1000), 10))
				item:Spawn()
				item:Activate()
				item.Think = function() 
								if item:IsValid() then 
									for _,ply in pairs(player.GetAll()) do 
										if ply:GetPos():Distance(item:GetPos()) < 300 then 
											timer.Simple(30,function() if item:IsValid() then item.Think() end end)
											return false 
										end
									end
									item:Remove() 
								end 					
							end 
				timer.Simple(30,function() if item:IsValid() then item.Think() end end)
	end,	
}

CIVRP_Events["Weapon"] = {
	Condition = function(ply) 
		return true
	end,
	Function = function(ply)
				local SupplyList = {"weapon_shotgun", "weapon_357", "weapon_crowbar",}
				local item = ents.Create(table.Random(SupplyList))
				item:SetPos(ply:GetPos() + Vector(math.random(-1000,1000),math.random(-1000,1000),10))
				item:Spawn()
				item:Activate()
				item.Think = function() 
								if item:IsValid() then 
									for _,ply in pairs(player.GetAll()) do 
										if ply:GetPos():Distance(item:GetPos()) < 300 then 
											timer.Simple(30,function() if item:IsValid() then item.Think() end end)
											return false 
										end
									end
									item:Remove() 
								end 					
							end 
				timer.Simple(30,function() if item:IsValid() then item.Think() end end)
	end,	
}

CIVRP_Events["CrashedVan"] = {
	Condition = function(ply) 
		return true
	end,
	Function = function(ply)
				local SupplyList = {"weapon_shotgun", "weapon_357", "weapon_crowbar", "item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",}
				local VanModels = {"models/props_vehicles/van001a.mdl", "models/props_vehicles/van001a_nodoor.mdl"}
				local VanSkins = 1
				local items = {}
					local van = ents.Create("prop_physics")
					van:SetModel(VanModels[math.random(1, table.Count(VanModels))])
					van:SetSkin(math.random(0, VanSkins))
					local tries = 0
					local function Check()
						van:SetPos(Vector(ply:GetPos().x + math.random(-3000,3000),ply:GetPos().y + math.random(-3000,3000),158))
						for _,v in pairs(player.GetAll()) do
							if v:GetPos():Distance(van:GetPos()) < 600 then
								Check()
								tries = tries + 1
								if tries >= 20 then
									van:Remove()
									return false
								end
								break
							end
						end
					end
					Check()
					van:SetAngles(Angle(math.random(-5,5),math.random(0,180),math.random(-5,5)))
					van:Spawn()
					van:Activate()
					if van:GetPhysicsObject():IsValid() then
						van:GetPhysicsObject():EnableMotion(false)
					end
					van.Think = function() 
									if van:IsValid() then 
										for _,ply in pairs(player.GetAll()) do 
											if ply:GetPos():Distance(van:GetPos()) < 300 then 
												timer.Simple(60,function() if van:IsValid() then van.Think() end end)
												return false 
											end
										end 
										for _,ent in pairs(items) do
											if ent:IsValid() && !ent:GetOwner():IsPlayer() then
												ent:Remove()
											end
										end
										van:Remove() 
									end 					
								end 
					timer.Simple(300,function() if van:IsValid() then van.Think() end end)				
				for i = 1, math.random(0,6) do
					local item = ents.Create(table.Random(SupplyList))
					item:SetPos(van:GetPos() + van:GetAngles():Forward() * (-5 * i) + Vector(0,0,15))
					item:Spawn()
					item:Activate()
					table.insert(items,item)
							
				end
				
	end,	
}
