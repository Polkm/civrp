CIVRP_Events["Antlion_Settlement01"] = {}
CIVRP_Events["Antlion_Settlement01"].ProgressRate = 250
CIVRP_Events["Antlion_Settlement01"].EventKey = "Antlion_Settlement01"
CIVRP_Events["Antlion_Settlement01"].Objects = {}
CIVRP_Events["Antlion_Settlement01"].Npcs = {}
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

local function HatchEggs(tblDataTable, boolWorker)
	tblDataTable.SquadName = tblDataTable.SquadName or ("Antlion_Settlement" .. CurTime())
	local tblObjects = tblDataTable.Objects
	for _, ent in pairs(tblObjects) do
		if ValidEntity(ent) && ent:GetModel() == "models/props_hive/egg.mdl" then
			local entAntlion
			if boolWorker then
				entAntlion = CreateCustomNPC("npc_antlion_worker", tblDataTable.SquadName, nil, nil, nil, {["Start Burrowed"] = {1}})
			else
				entAntlion = CreateCustomNPC("npc_antlion", tblDataTable.SquadName, nil, nil, {0, 1, 2, 3}, {["Start Burrowed"] = {1}})
			end
			entAntlion:SetPos(ent:GetPos())
			entAntlion:SetAngles(ent:GetAngles())
			entAntlion:Spawn()
			entAntlion:Activate()
			entAntlion:Fire('Unburrow','',0.5)
			entAntlion:SetColor(0, 0, 0, 0)
			timer.Simple(0.2, function()
				if (ValidEntity(entAntlion)) then
					entAntlion:SetColor(255, 255, 255, 255)
				end
			end)
			ent:Remove()
			table.insert(tblDataTable.Npcs, entAntlion)
		end
	end
end

CIVRP_Events["Antlion_Settlement01"].Tech = {}
CIVRP_Events["Antlion_Settlement01"].Tech[1] = function(tblDataTable)	
	local entMedHive = ents.Create("prop_physics")
	entMedHive:SetModel("models/props_hive/nest_med_flat.mdl")
	entMedHive:SetPos(tblDataTable.Center)
	entMedHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entMedHive:Spawn()
	if entMedHive:GetPhysicsObject():IsValid() then entMedHive:GetPhysicsObject():EnableMotion(false) end
	entMedHive.Removelevel = 2
	table.insert(tblDataTable.Objects, entMedHive)
	
	HatchEggs(tblDataTable)
	
	for i = 1, math.random(3, 8) do
		local entEgg = ents.Create("prop_physics")
		entEgg:SetModel("models/props_hive/egg.mdl")
		entEgg:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 200, 300))
		entEgg:SetAngles((entEgg:GetPos() - entMedHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		entEgg:Spawn()
		entEgg:Activate()
		if entEgg:GetPhysicsObject():IsValid() then entEgg:GetPhysicsObject():EnableMotion(false) end
		table.insert(tblDataTable.Objects, entEgg)
	end
	
	for i = 1, math.random(1, 3) do
		local entGrub = ents.Create("npc_antlion_grub")
		entGrub:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 100, 150))
		entGrub:SetAngles((entGrub:GetPos() - entMedHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		entGrub:Spawn()
		entGrub.Removelevel = 2
		table.insert(tblDataTable.Objects, entGrub)
	end
	
	for i = 1, math.random(1, 4) do
		local entSmallHive = ents.Create("prop_physics")
		entSmallHive:SetModel("models/props_hive/nest_sm_flat.mdl")
		entSmallHive:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 200, 500))
		entSmallHive:SetAngles(Angle(0, math.random(0, 360), 0))
		entSmallHive:Spawn()
		entSmallHive.Removelevel = 2
		table.insert(tblDataTable.Objects, entSmallHive)
	end
end
CIVRP_Events["Antlion_Settlement01"].Tech[2] = function(tblDataTable)
	local entLargeHive = ents.Create("prop_physics")
	entLargeHive:SetModel("models/props_hive/nest_lrg_flat.mdl")
	entLargeHive:SetPos(tblDataTable.Center)
	entLargeHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entLargeHive:Spawn()
	if entLargeHive:GetPhysicsObject():IsValid() then entLargeHive:GetPhysicsObject():EnableMotion(false) end
	entLargeHive.Removelevel = 3
	table.insert(tblDataTable.Objects, entLargeHive)
	
	HatchEggs(tblDataTable)
	
	for i = 1, math.random(2, 4) do
		local AntlionHiveSmall = ents.Create("prop_physics")
		AntlionHiveSmall:SetModel("models/props_hive/nest_sm_flat.mdl")
		AntlionHiveSmall:SetPos(tblDataTable.Center + Vector(math.random(-500, 500), math.random(-500, 500), 0))
		AntlionHiveSmall:SetAngles(Angle(0,math.random(0,360),0))
		AntlionHiveSmall:Spawn()
		--AntlionHiveSmall.Removelevel = 3
		table.insert(tblDataTable.Objects, AntlionHiveSmall)
	end
	
	for i = 1, math.random(2, 4) do
		local AntlionEgg = ents.Create("prop_physics")
		AntlionEgg:SetModel("models/props_hive/egg.mdl")
		AntlionEgg:SetPos(GetRandomRadiusPos(entLargeHive:GetPos(), 200, 300))
		AntlionEgg:SetAngles((AntlionEgg:GetPos() - entLargeHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		AntlionEgg:Spawn()
		AntlionEgg:Activate()
		if AntlionEgg:GetPhysicsObject():IsValid() then
			AntlionEgg:GetPhysicsObject():EnableMotion(false)
		end
		table.insert(tblDataTable.Objects, AntlionEgg)
	end
end
CIVRP_Events["Antlion_Settlement01"].Tech[3] = function(tblDataTable)	
	local AntlionHill = ents.Create("prop_physics")
	AntlionHill:SetModel("models/props_wasteland/antlionhill.mdl")
	AntlionHill:SetPos(tblDataTable.Center)
	AntlionHill:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHill:Spawn()
	if AntlionHill:GetPhysicsObject():IsValid() then
		AntlionHill:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(tblDataTable.Objects, AntlionHill)
	
	for i = 1, math.random(5, 10) do
		local Antliongrub = ents.Create("npc_antlion_grub")
		Antliongrub:SetPos(tblDataTable.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		Antliongrub:SetAngles(Angle(0,math.random(0,360),0))
		Antliongrub:Spawn()
		table.insert(tblDataTable.Objects, Antliongrub)
	end	
	
	HatchEggs(tblDataTable, true)
end

CIVRP_Events["Antlion_Settlement01"].Function = function(ply)
	local tblData = CIVRP_Events["Antlion_Settlement01"]
	--tblData.Center = Vector(0, 0, 128) + ply:GetPos() - Vector(0, 0, ply:GetPos().z)
	tblData.Center = Vector(math.random(-14000, 14000), math.random(-14000, 14000), 128)
	
	tblDataTable.SquadName = tblDataTable.SquadName or ("Antlion_Settlement" .. CurTime())
	tblData.Leader = ents.Create("npc_antlionguard")
	tblData.Leader:SetPos(GetRandomRadiusPos(tblData.Center, 100, 200))
	tblData.Leader:SetModel("models/antlion_guard.mdl")
	tblData.Leader:SetAngles(Angle(0, math.random(0, 360), 0))
	tblData.Leader:SetKeyValue("Squad Name", tblDataTable.SquadName)
	tblData.Leader:Spawn()
	tblData.Leader:Activate()
	
	local entSmallHive = ents.Create("prop_physics")
	entSmallHive:SetModel("models/props_hive/nest_sm_flat.mdl")
	entSmallHive:SetPos(tblData.Center)
	entSmallHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entSmallHive:Spawn()
	entSmallHive.Removelevel = 1
	table.insert(tblData.Objects, entSmallHive)
	
	for i = 1, math.random(1, 5) do
		local entEgg = ents.Create("prop_physics")
		entEgg:SetModel("models/props_hive/egg.mdl")
		entEgg:SetPos(GetRandomRadiusPos(tblData.Center, 240, 300))
		entEgg:SetAngles(Angle(0,math.random(0,360),0))
		entEgg:Spawn()
		entEgg:Activate()
		if entEgg:GetPhysicsObject():IsValid() then entEgg:GetPhysicsObject():EnableMotion(false) end
		table.insert(tblData.Objects, entEgg)
	end
	
	CIVRP_Register_Settlement(tblData)
end