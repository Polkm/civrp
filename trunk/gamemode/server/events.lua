function CIVRP_CreateEvent()
	local ply = table.Random(player.GetAll())
	local tbl = {}
	for _, data in pairs(CIVRP_Events) do
		if data.Condition(ply) then
			table.insert(tbl, _)
		end
	end
	if table.Count(tbl) >= 1 then
		CIVRP_Events[table.Random(tbl)].Function(ply)
		--CIVRP_Events["Ambush"].Function(ply)
	end
	timer.Simple(math.Round(math.random(55, 65) * GetPlayerFactor()), function() CIVRP_CreateEvent() end)
end

hook.Add("Initialize", "initializing_threat_systems", function()
	if CIVRP_DIFFICULTY != "Peacefull" then --No baddies for peace lovers
		timer.Simple(10, function() CIVRP_CreateEvent() end)
	end
end)

CIVRP_Events = {}


CIVRP_Events["Ambush"] = {}
CIVRP_Events["Ambush"].Condition = function(ply) 
	if table.Count(ents.FindByClass("npc_*")) >= 5 then return false end
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
		for i = 1, Selection.MinionsNumber do
			local tblMinion = table.Random(Selection.Minions)
			local npc = CreateCustomNPC(tblMinion.Class, Selection.Class .. CurTime(), tblMinion.HealthFactor, tblMinion.Mat, tblMinion.Skins, tblMinion.KeyValues)
			npc:SetPos(GetRandomRadiusPos(boss:GetPos() + Vector(0, 0, 10), 100, 200))
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
	local VanSkins = 2
	local items = {}
	
	local van = ents.Create("prop_physics")
	van:SetModel(VanModels[math.random(1, table.Count(VanModels))])
	van:SetSkin(math.random(0, VanSkins - 1))
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
	van:SetAngles(Angle(math.random(-5,5),math.random(0,360),math.random(-5,5)))
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



CIVRP_Events["HeadCrabCanister"] = {}
CIVRP_Events["HeadCrabCanister"].Condition = function(ply) 
	return true
end
CIVRP_Events["HeadCrabCanister"].Function = function(ply)
	local intHeadCrabRange = 1000
	local tblHeadCrabs = {"0", "1", "2"} --0 = Normal, 1 = Fast, 2 = Poision
	local intHeadCrabMin = 4
	local intHeadCrabMax = 8
	local intHeadCrabDamage = 20
	
	local distance = math.random(500, intHeadCrabRange)
	local angle = math.random(0, 360)
	local entStartingPos = ents.Create("info_target")
	entStartingPos:SetPos(ply:GetPos() + (Vector(math.cos(angle) * (distance + 500), math.sin(angle) * (distance + 500)) + Vector(0, 0, 9500)))
	entStartingPos:SetKeyValue("targetname", "HeadCrabCanTarget" .. entStartingPos:EntIndex()) --As to not conflict with other canisters
	entStartingPos:Spawn()
	
	distance = math.random(500, intHeadCrabRange)
	angle = math.random(0, 360)
	local entCanister = ents.Create("env_headcrabcanister")
	entCanister:SetPos(ply:GetPos() + (Vector(math.cos(angle) * distance, math.sin(angle) * distance, 128)) - Vector(0, 0, ply:GetPos().z)) --This is the landing pos
	entCanister:SetAngles(Angle(-100, math.random(0, 360), 0)) --Angle it is coming out of the ground
	entCanister:SetKeyValue("HeadcrabType", table.Random(tblHeadCrabs))
	entCanister:SetKeyValue("HeadcrabCount", math.random(intHeadCrabMin, intHeadCrabMax))
	entCanister:SetKeyValue("LaunchPositionName", "HeadCrabCanTarget" .. entStartingPos:EntIndex())
	entCanister:SetKeyValue("FlightSpeed", 350)
	entCanister:SetKeyValue("FlightTime", 3.5)
	entCanister:SetKeyValue("Damage", intHeadCrabDamage) -- Damage when it impacts
	entCanister:SetKeyValue("DamageRadius", 75) -- Damage radius
	entCanister:SetKeyValue("SmokeLifetime", 25) -- How long it smokes
	entCanister:Fire("Spawnflags", "16384", 0)
	entCanister:Fire("FireCanister", "", 0)
	entCanister:Fire("AddOutput", "OnImpacted OpenCanister", 0)
	entCanister:Fire("AddOutput", "OnOpened SpawnHeadcrabs", 0)
	entCanister:Fire("AddOutput", "OnOpened HeadCrabCanTarget" .. entStartingPos:EntIndex() .. " Kill", 0)
	entCanister:Spawn()
	timer.Simple(50, function() CheckDistanceFunction(entCanister, 500, 50) end)
end

CIVRP_Events["AntlionBurrow"] = {}
CIVRP_Events["AntlionBurrow"].Condition = function(ply) 
	return true
end
CIVRP_Events["AntlionBurrow"].Function = function(ply)	
	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = {Class = "npc_antlion",}
	Minions.Number = math.random(1,4)
	
	for i = 1, Minions.Number do
		local distance = math.random(100, 200)
		local angle = math.random(0, 360)
		local MinionSelection = table.Random(Minions.Type)
		local npc = ents.Create(MinionSelection.Class)
		npc:SetPos(ply:GetPos() + (Vector(math.cos(angle) * (distance + 500), math.sin(angle) * (distance + 500)) + Vector(0, 0, -50)))
		npc:SetKeyValue("Start Burrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
	end
end
--]]