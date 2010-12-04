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
	timer.Simple(math.random(55, 65) * GetPlayerFactor() / GetDifficultyFactor(), function() CIVRP_CreateEvent() end)
end
hook.Add("Initialize", "initializing_threat_systems", function()
	if CIVRP_DIFFICULTY != "Peacefull" then --No baddies for peace lovers
		timer.Simple(10, function() CIVRP_CreateEvent() end)
	end
end)

CIVRP_MaxSettlements = 10

function CIVRP_Register_Settlement(leader,propstbl,CENTERPOS,EventKey)
	if CIVRP_Settlements == nil then
		CIVRP_Settlements = {} 
		for i = 1, CIVRP_MaxSettlements do
			CIVRP_Settlements[i] = "empty"
		end
	end
	for i = 1, table.Count(CIVRP_Settlements) do
		if CIVRP_Settlements[i] == "empty" then
			CIVRP_Settlements[i] = {}	
			leader.SETTLEMENTID = i
			CIVRP_Settlements[i].Leader = leader
			CIVRP_Settlements[i].Objects = propstbl
			CIVRP_Settlements[i].Center = CENTERPOS
			CIVRP_Settlements[i].EventKey = EventKey 
			CIVRP_Settlements[i].TechLevel = 0
			return i
		end
	end
end

function CIVRP_Progress_Settlement(ID)
	local settlement = CIVRP_Settlements[ID] 
	if settlement != "empty" then
		if settlement.TechLevel < table.Count(CIVRP_Events[settlement.EventKey].Tech) then
			settlement.TechLevel = settlement.TechLevel + 1
			for _,object in pairs(settlement.Objects) do
				if !object:IsValid() then
					table.remove(settlement.Objects,_)
				elseif object:IsValid() && object.Removelevel == settlement.TechLevel then
					object:Remove()
				end	
			end
			local objects = CIVRP_Events[settlement.EventKey].Tech[settlement.TechLevel](settlement)
			if objects != nil then
				for _,object in pairs(objects) do
					if object:IsValid() then
						table.insert(settlement.Objects,object)
					end
				end
			end
			if settlement.TechLevel < table.Count(CIVRP_Events[settlement.EventKey].Tech) then
				timer.Simple(3,function() CIVRP_Progress_Settlement(ID) end)
			end
		end
	end
end

CIVRP_Events = {}

CIVRP_Events["Combine_Settlement01"] = {}
CIVRP_Events["Combine_Settlement01"].Condition = function(ply) 
	return true
end
CIVRP_Events["Combine_Settlement01"].Tech = {}
CIVRP_Events["Combine_Settlement01"].Tech[1] = function(data)
	local objects = {}
	
	local thumper = ents.Create("prop_thumper")
	thumper:SetPos(data.Center)
	thumper:SetAngles(Angle(0,math.random(0,180),0))
	thumper:Spawn()
	thumper:Activate()
	thumper.Removelevel = 4
	if thumper:GetPhysicsObject():IsValid() then
		thumper:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects,thumper)
	return objects
end

CIVRP_Events["Combine_Settlement01"].Tech[2] = function(data)
	local objects = {}
	local cades = math.random(4,14)
	for i = 1, cades do
		local distance = math.random(490, 510)
		local angle = math.random(0, 360)
		local cade = ents.Create("prop_physics")
		cade:SetModel("models/props_combine/combine_barricade_short01a.mdl")
		cade:SetPos(data.Center + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		cade:SetAngles((cade:GetPos() - data.Center):Angle())
		cade:SetPos(cade:GetPos() + Vector(0,0,30))
		cade.RemoveLevel = 4
		cade:Spawn()
		cade:Activate()
		if cade:GetPhysicsObject():IsValid() then
			cade:GetPhysicsObject():EnableMotion(false)
		end
		table.insert(objects,cade)
	end
	return objects
end

CIVRP_Events["Combine_Settlement01"].Tech[3] = function(data)
	local turrets = math.random(1,3)
	for i = 1, turrets do
		local distance = math.random(450, 480)
		local angle = math.random(0, 360)
		local turret = ents.Create("npc_turret_floor")
		turret:SetPos(data.Center + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		turret:SetAngles((turret:GetPos() - data.Center):Angle())
		turret:SetPos(turret:GetPos() + Vector(0,0,30))
		turret:Spawn()
	end
	return nil
end

CIVRP_Events["Combine_Settlement01"].Function = function(ply)	
	local objects = {}
	
	local vx = math.random(0,600)---15600, 15600)
	local vy = math.random(0,600)--15600, 15600)
	local CENTER = Vector(vx,vy,128)
	
	local apc = ents.Create("prop_physics")
	apc:SetModel("models/combine_apc_wheelcollision.mdl")
	apc:SetPos(CENTER)
	apc:SetAngles(Angle(0,math.random(0,180),0))
	apc:Spawn()
	apc:Activate()
	apc.Removelevel = 1
	if apc:GetPhysicsObject():IsValid() then
		apc:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects,apc)

	local leader = ents.Create("npc_combine_s")
	leader:SetPos(apc:GetPos() + apc:GetAngles():Right() * -200)
	leader:SetModel("models/combine_super_soldier.mdl")
	leader:SetAngles(Angle(0,math.random(0,180),0))
	
	local Weapons = {"weapon_ar2", "weapon_smg1",}
	leader:SetKeyValue("additionalequipment", table.Random(Weapons))
	
	leader:Spawn()
	leader:Activate()

	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = {Class = "npc_combine_s", Weapons = {"weapon_ar2", "weapon_smg1", "weapon_shotgun"},}
	Minions.Number = math.random(1,2)

	for i = 1, Minions.Number do
		local MinionSelection = table.Random(Minions.Type)
		local npc = ents.Create(MinionSelection.Class)
		npc:SetPos(leader:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0))
		if MinionSelection.Weapons != nil then
			npc:SetKeyValue("additionalequipment", table.Random(MinionSelection.Weapons))
		end
		npc:Spawn()		
		npc:Activate()
	end

	local ID = CIVRP_Register_Settlement(leader,objects,CENTER,"Combine_Settlement01")
	timer.Simple(3,function() CIVRP_Progress_Settlement(ID) end)
end

--[[
CIVRP_Events["Ambush"] = {}
CIVRP_Events["Ambush"].Condition = function(ply) 
	if table.Count(ents.FindByClass("npc_*")) >= 5 then return false end
	if IsDay() and ply:Health() >= 50 then return true
	else return true end
	return false
end
CIVRP_Events["Ambush"].Function = function(ply)
	local Bosses = {}
	Bosses[1] = {}
	Bosses[1].Class = "npc_antlionguard"
	Bosses[1].Number = math.random(1, 2)
	Bosses[1].MinionsNumber = math.random(1, 3)
	Bosses[1].Minions = {}
	Bosses[1].Minions[1] = {Class = "npc_antlion"}
	Bosses[1].Minions[2] = {Class = "npc_antlion_worker"}
	
	Bosses[2] = {}
	Bosses[2].Class = "npc_hunter"
	Bosses[2].Number = math.random(1, 3)
	Bosses[2].MinionsNumber = math.random(1, 3)
	Bosses[2].Minions = {}
	--Bosses[2].Minions[1] = {Class = "npc_hunter"}
	Bosses[2].Minions[2] = {Class = "npc_combine_s", Weapons = {"weapon_ar2", "weapon_smg1", "weapon_shotgun"}}
	Bosses[2].Minions[3] = {Class = "npc_manhack"}
	
	Bosses[3] = {}
	Bosses[3].Class = "npc_fastzombie"
	Bosses[3].Number = math.random(1, 3)
	Bosses[3].MinionsNumber = math.random(1, 3)
	Bosses[3].Minions = {}
	Bosses[3].Minions[1] = {Class = "npc_poisonzombie"}
	Bosses[3].Minions[2] = {Class = "npc_zombie"}
	
	local Selection = table.Random(Bosses) 
	for i = 1, Selection.Number do
		local npc = ents.Create(Selection.Class)
		npc:SetPos(ply:GetPos() + Vector(math.random(-1500, 1500), math.random(-1500, 1500), 0))
		npc:Spawn()
		npc:Activate()
		for i = 1, Selection.MinionsNumber do
			local MinionSelection = table.Random(Selection.Minions)
			local npc = ents.Create(MinionSelection.Class)
			npc:SetPos(ply:GetPos() + Vector(math.random(-1500, 1500), math.random(-1500, 1500), 0))
			if MinionSelection.Weapons != nil then
				npc:SetKeyValue("additionalequipment", table.Random(MinionSelection.Weapons))
			end
			npc:Spawn()		
			npc:Activate()
		end
	end
end

CIVRP_Events["Patrol"] = {}
CIVRP_Events["Patrol"].Condition = function(ply) 
	return true
end
CIVRP_Events["Patrol"].Function = function(ply)
	local Bosses = {}
	
	Bosses[1] = {}
	Bosses[1].Class = "npc_hunter"
	Bosses[1].Number = math.random(1, 1)
	Bosses[1].MinionsNumber = math.random(1, 3)
	Bosses[1].Minions = {}
	--Bosses[2].Minions[1] = {Class = "npc_hunter"}
	Bosses[1].Minions[1] = {Class = "npc_combine_s", Weapons = {"weapon_ar2", "weapon_smg1", "weapon_shotgun"}}
	Bosses[1].Minions[2] = {Class = "npc_manhack"}
	
	local Selection = table.Random(Bosses) 
	for i = 1, Selection.Number do
		local npc = ents.Create(Selection.Class)
		npc:SetPos(ply:GetPos() + Vector(math.random(-5000, 5000), math.random(-5000, 5000), 0))
		npc:Spawn()
		npc:Activate()
		for i = 1, Selection.MinionsNumber do
			local MinionSelection = table.Random(Selection.Minions)
			local npc = ents.Create(MinionSelection.Class)
			npc:SetPos(ply:GetPos() + Vector(math.random(-5000, 5000), math.random(-5000, 5000), 0))
			if MinionSelection.Weapons != nil then
				npc:SetKeyValue("additionalequipment", table.Random(MinionSelection.Weapons))
			end
			npc:Spawn()		
			npc:Activate()
		end
	end
end

CIVRP_Events["Healthkit"] = {}
CIVRP_Events["Healthkit"].Condition = function(ply) 
	if ply:Health() <= 90 then
		return true
	end
	return false
end
CIVRP_Events["Healthkit"].Function = function(ply)
	local item = ents.Create("item_healthkit")
	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item:SetModel(CIVRP_Item_Data["item_healthkit"].Model)
	item:SetPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item:Spawn()
	item:Activate()
	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	item.ItemClass = "item_healthkit"
	CheckDistanceFunction(item, 500, 60)
end



CIVRP_Events["Supply"] = {}
CIVRP_Events["Supply"].Condition = function(ply) 
	return true
end
CIVRP_Events["Supply"].Function = function(ply)
	local SupplyList = {
		"item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol",
		"item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",
		"item_ammo_smg1_grenade", "item_box_buckshot", "item_ammo_ar2_altfire", "weapon_frag",}
	local itemtbl = {}
	for itemclass,data in pairs(CIVRP_Item_Data) do
		table.insert(itemtbl,itemclass)
	end	
	local selection = table.Random(itemtbl)
	local item = ents.Create("prop_physics")
	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item:SetModel(CIVRP_Item_Data[selection].Model)
	item:SetPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item:Spawn()
	item:Activate()
	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	item.ItemClass = selection
	CheckDistanceFunction(item, 500, 30)
end



CIVRP_Events["Weapon"] = {}
CIVRP_Events["Weapon"].Condition = function(ply) 
	return true
end
CIVRP_Events["Weapon"].Function = function(ply)
	local SupplyList = {"weapon_shotgun", "weapon_357", "weapon_ar2",}
	local itemtbl = {}
	for itemclass,data in pairs(CIVRP_Item_Data) do
		table.insert(itemtbl,itemclass)
	end	
	local selection = table.Random(itemtbl)
	local item = ents.Create("prop_physics")
	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item:SetModel(CIVRP_Item_Data[selection].Model)
	item:SetPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item:Spawn()
	item:Activate()
	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	item.ItemClass = selection
	CheckDistanceFunction(item, 500, 30)
end



CIVRP_Events["CrashedVan"] = {}
CIVRP_Events["CrashedVan"].Condition = function(ply) 
	return true
end
CIVRP_Events["CrashedVan"].Function = function(ply)
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
			if v:GetPos():Distance(van:GetPos()) < 800 then
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
	
	for i = 1, math.random(0, 6) do
		local itemtbl = {}
		for itemclass,data in pairs(CIVRP_Item_Data) do
			table.insert(itemtbl,itemclass)
		end	
		local selection = table.Random(itemtbl)
		local item = ents.Create("prop_physics")
		item:SetModel(CIVRP_Item_Data[selection].Model)
		item:SetPos(van:GetPos() + van:GetAngles():Forward() * (-5 * i) + Vector(0, 0, 15))
		item:Spawn()
		item:Activate()
		item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		item.ItemClass = selection
		table.insert(items, item)
	end
end

]]