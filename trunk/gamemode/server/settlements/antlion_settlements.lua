CIVRP_Events["Antlion_Settlement01"] = {}
CIVRP_Events["Antlion_Settlement01"].Condition = function(ply) 
	if CIVRP_Settlements == nil then
		CIVRP_Settlements = {} 
		for i = 1, CIVRP_MaxSettlements do
			CIVRP_Settlements[i] = "empty"
		end
		return true
	end
	for _,data in pairs(CIVRP_Settlements) do
		if data == "empty" then
			return true
		end
	end
	return false
end

CIVRP_Events["Antlion_Settlement01"].Tech = {}
CIVRP_Events["Antlion_Settlement01"].Tech[1] = function(data)	
	local npcs = {}
	local objects = {}
	
	local AntlionHiveLarger = ents.Create("prop_physics")
	AntlionHiveLarger:SetModel("models/props_hive/nest_med_flat.mdl")
	AntlionHiveLarger:SetPos(data.Center)
	AntlionHiveLarger:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHiveLarger:Spawn()
	if AntlionHiveLarger:GetPhysicsObject():IsValid() then
		AntlionHiveLarger:GetPhysicsObject():EnableMotion(false)
	end
	AntlionHiveLarger.Removelevel = 2
	table.insert(objects, AntlionHiveLarger)
	
	local numsmallhives = math.random(1, 4)
	for i = 1, numsmallhives do
		local AntlionHiveSmall = ents.Create("prop_physics")
		AntlionHiveSmall:SetModel("models/props_hive/nest_sm_flat.mdl")
		AntlionHiveSmall:SetPos(data.Center + Vector(math.random(-500, 500), math.random(-500, 500), 0))
		AntlionHiveSmall:SetAngles(Angle(0,math.random(0,360),0))
		AntlionHiveSmall:Spawn()
		AntlionHiveSmall.Removelevel = 2
		table.insert(objects, AntlionHiveSmall)
	end
	
	local antents = data.Objects
	for _,ent in pairs(antents) do
		if (ValidEntity(ent) && ent:GetModel() == "models/props_hive/egg.mdl") then
			local Antlion = ents.Create("npc_antlion")
			Antlion:SetPos(ent:GetPos())
			Antlion:SetAngles(Angle(0, math.random(0,360), 0) )
			Antlion:SetKeyValue("Start Burrowed", 1)
			Antlion:Spawn()		
			Antlion:Activate()
			Antlion:Fire('Unburrow','',0.5)
			Antlion:SetColor(0, 0, 0, 0)
			timer.Simple(0.2, function()
				if (ValidEntity(Antlion)) then
					Antlion:SetColor(255, 255, 255, 255)
				end
			end)
			ent:Remove()
			table.insert(npcs, Antlion)
		end
	end
		
	local numeggs = math.random(1, 5)
	
	for i = 1, numeggs do
		local AntlionEgg = ents.Create("prop_physics")
		AntlionEgg:SetModel("models/props_hive/egg.mdl")
		AntlionEgg:SetPos(data.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		AntlionEgg:SetAngles(Angle(0,math.random(0,360),0))
		AntlionEgg:Spawn()
		AntlionEgg:Activate()
		if AntlionEgg:GetPhysicsObject():IsValid() then
			AntlionEgg:GetPhysicsObject():EnableMotion(false)
		end
		table.insert(objects, AntlionEgg)
	end	
	
	return {NPCS = npcs, OBJECTS = objects}
end
CIVRP_Events["Antlion_Settlement01"].Tech[2] = function(data)	
	local npcs = {}
	local objects = {}
	
	local AntlionHiveLarge = ents.Create("prop_physics")
	AntlionHiveLarge:SetModel("models/props_hive/nest_lrg_flat.mdl")
	AntlionHiveLarge:SetPos(data.Center)
	AntlionHiveLarge:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHiveLarge:Spawn()
	if AntlionHiveLarge:GetPhysicsObject():IsValid() then
		AntlionHiveLarge:GetPhysicsObject():EnableMotion(false)
	end
	AntlionHiveLarge.Removelevel = 3
	table.insert(objects, AntlionHiveLarge)
	
	local numsmallhives = math.random(1, 4)
	for i = 1, numsmallhives do
		local AntlionHiveSmall = ents.Create("prop_physics")
		AntlionHiveSmall:SetModel("models/props_hive/nest_sm_flat.mdl")
		AntlionHiveSmall:SetPos(data.Center + Vector(math.random(-500, 500), math.random(-500, 500), 0))
		AntlionHiveSmall:SetAngles(Angle(0,math.random(0,360),0))
		AntlionHiveSmall:Spawn()
		AntlionHiveSmall.Removelevel = 3
		table.insert(objects, AntlionHiveSmall)
	end
	
	local antents = data.Objects
	for _,ent in pairs(antents) do
		if (ValidEntity(ent) && ent:GetModel() == "models/props_hive/egg.mdl") then
			local Antlion = ents.Create("npc_antlion")
			Antlion:SetPos(ent:GetPos())
			Antlion:SetAngles(Angle(0, math.random(0,360), 0) )
			Antlion:SetKeyValue("Start Burrowed", 1)
			Antlion:Spawn()		
			Antlion:Activate()
			Antlion:Fire('Unburrow','',0.5)
			ent:Remove()
			table.insert(npcs, Antlion)
		end
	end
		
	local numeggs = math.random(1, 5)
	
	for i = 1, numeggs do
		local AntlionEgg = ents.Create("prop_physics")
		AntlionEgg:SetModel("models/props_hive/egg.mdl")
		AntlionEgg:SetPos(data.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		AntlionEgg:SetAngles(Angle(0,math.random(0,360),0))
		AntlionEgg:Spawn()
		AntlionEgg:Activate()
		if AntlionEgg:GetPhysicsObject():IsValid() then
			AntlionEgg:GetPhysicsObject():EnableMotion(false)
		end
		table.insert(objects, AntlionEgg)
	end	
	
	return {NPCS = npcs, OBJECTS = objects}
end
CIVRP_Events["Antlion_Settlement01"].Tech[3] = function(data)	
	local npcs = {}
	local objects = {}
	
	local AntlionHill = ents.Create("prop_physics")
	AntlionHill:SetModel("models/props_wasteland/antlionhill.mdl")
	AntlionHill:SetPos(data.Center)
	AntlionHill:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHill:Spawn()
	if AntlionHill:GetPhysicsObject():IsValid() then
		AntlionHill:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects, AntlionHill)
		
	local numgrubs = math.random(5, 10)
	
	for i = 1, numgrubs do
		local Antliongrub = ents.Create("npc_antlion_grub")
		Antliongrub:SetPos(data.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		Antliongrub:SetAngles(Angle(0,math.random(0,360),0))
		Antliongrub:Spawn()
		table.insert(objects, Antliongrub)
	end	
	
	local antents = data.Objects
	for _,ent in pairs(antents) do
		if (ValidEntity(ent) && ent:GetModel() == "models/props_hive/egg.mdl") then
			local Antlion = ents.Create("npc_antlion_worker")
			Antlion:SetPos(ent:GetPos())
			Antlion:SetAngles(Angle(0, math.random(0,360), 0) )
			Antlion:SetKeyValue("Start Burrowed", 1)
			Antlion:Spawn()		
			Antlion:Activate()
			Antlion:Fire('Unburrow','',0.5)
			ent:Remove()
			table.insert(npcs, Antlion)
		end
	end
	
	return {NPCS = npcs, OBJECTS = objects}
end

CIVRP_Events["Antlion_Settlement01"].Function = function(ply)	
	local objects = {}
	
	local vx = math.random(-14000, 14000)--
	local vy = math.random(-14000, 14000)--
	local CENTER = Vector(vx, vy, 128)
	
	local AntlionHiveSmall = ents.Create("prop_physics")
	AntlionHiveSmall:SetModel("models/props_hive/nest_sm_flat.mdl")
	AntlionHiveSmall:SetPos(CENTER)
	AntlionHiveSmall:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHiveSmall:Spawn()
	AntlionHiveSmall.Removelevel = 1
	table.insert(objects, AntlionHiveSmall)

	local leader = ents.Create("npc_antlionguard")
	leader:SetPos(AntlionHiveSmall:GetPos() + AntlionHiveSmall:GetAngles():Right() * -200)
	leader:SetModel("models/antlion_guard.mdl")
	leader:SetAngles(Angle(0,math.random(0,360),0))
	leader:Spawn()
	leader:Activate()
	
	local numeggs = math.random(1, 5)
	
	for i = 1, numeggs do
		local AntlionEgg = ents.Create("prop_physics")
		AntlionEgg:SetModel("models/props_hive/egg.mdl")
		AntlionEgg:SetPos(CENTER + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		AntlionEgg:SetAngles(Angle(0,math.random(0,360),0))
		AntlionEgg:Spawn()
		AntlionEgg:Activate()
		if AntlionEgg:GetPhysicsObject():IsValid() then
			AntlionEgg:GetPhysicsObject():EnableMotion(false)
		end
		table.insert(objects, AntlionEgg)
	end
	

	local ID = CIVRP_Register_Settlement(leader, objects, {}, CENTER, "Antlion_Settlement01")
	timer.Simple(200, function() CIVRP_Progress_Settlement(ID) end)
end