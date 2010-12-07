CIVRP_Events["Antlion_Settlement01"] = {}
CIVRP_Events["Antlion_Settlement01"].Chance = 20
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

local function HatchEggs(tblDataTableTable, boolWorker)
	tblDataTableTable.SquadName = tblDataTableTable.SquadName or ("Antlion_Settlement" .. CurTime())
	local tblObjects = tblDataTableTable.Objects
	for _, ent in pairs(tblObjects) do
		if ValidEntity(ent) && ent:GetModel() == "models/props_hive/egg.mdl" then
			local entAntlion
			if boolWorker then
				entAntlion = CreateCustomNPC("npc_antlion_worker", tblDataTableTable.SquadName, nil, nil, nil, {["startburrowed"] = {1}})
			else
				entAntlion = CreateCustomNPC("npc_antlion", tblDataTableTable.SquadName, nil, nil, {0, 1, 2, 3}, {["startburrowed"] = {1}})
			end
			entAntlion:SetPos(ent:GetPos())
			entAntlion:SetAngles(ent:GetAngles())
			entAntlion:Spawn()
			entAntlion:Activate()
			entAntlion:Fire('Unburrow','',0.5)
			entAntlion:SetColor(0, 0, 0, 0)

			ent:Remove()
			table.insert(tblDataTableTable.Npcs, entAntlion)
		end
	end
end

CIVRP_Events["Antlion_Settlement01"].Tech = {}
CIVRP_Events["Antlion_Settlement01"].Tech[1] = function(tblDataTableTable)	
	
	local entMedHive = CreateCustomProp("models/props_hive/nest_med_flat.mdl", false, true)
	entMedHive:SetPos(tblDataTableTable.Center)
	entMedHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entMedHive.Removelevel = 2
	table.insert(tblDataTableTable.Objects, entMedHive)
	
	HatchEggs(tblDataTableTable)
	
	for i = 1, math.random(3, 8) do
		local entEgg = CreateCustomProp("models/props_hive/egg.mdl", false, true)
		entEgg:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 200, 300))
		entEgg:SetAngles((entEgg:GetPos() - entMedHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		table.insert(tblDataTableTable.Objects, entEgg)
	end
	
	for i = 1, math.random(1, 3) do
		local entGrub = ents.Create("npc_antlion_grub")
		entGrub:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 100, 150))
		entGrub:SetAngles((entGrub:GetPos() - entMedHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		entGrub:Spawn()
		entGrub.Removelevel = 2
		table.insert(tblDataTableTable.Objects, entGrub)
	end
	
	for i = 1, math.random(1, 4) do
		local entSmallHive = CreateCustomProp("models/props_hive/nest_sm_flat.mdl", false, true)
		entSmallHive:SetPos(GetRandomRadiusPos(entMedHive:GetPos(), 200, 500))
		entSmallHive:SetAngles(Angle(0, math.random(0, 360), 0))
		entSmallHive.Removelevel = 2
		table.insert(tblDataTableTable.Objects, entSmallHive)
	end
end
CIVRP_Events["Antlion_Settlement01"].Tech[2] = function(tblDataTableTable)
	local entLargeHive = CreateCustomProp("models/props_hive/nest_lrg_flat.mdl", false, true)
	entLargeHive:SetPos(tblDataTableTable.Center)
	entLargeHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entLargeHive.Removelevel = 3
	table.insert(tblDataTableTable.Objects, entLargeHive)
	
	HatchEggs(tblDataTableTable)
	
	for i = 1, math.random(2, 4) do
		local AntlionHiveSmall = CreateCustomProp("models/props_hive/nest_sm_flat.mdl", false, true)
		AntlionHiveSmall:SetPos(tblDataTableTable.Center + Vector(math.random(-500, 500), math.random(-500, 500), 0))
		AntlionHiveSmall:SetAngles(Angle(0,math.random(0,360),0))
		--AntlionHiveSmall.Removelevel = 3
		table.insert(tblDataTableTable.Objects, AntlionHiveSmall)
	end
	
	for i = 1, math.random(2, 4) do
		local AntlionEgg = CreateCustomProp("models/props_hive/egg.mdl", false, true)
		AntlionEgg:SetPos(GetRandomRadiusPos(entLargeHive:GetPos(), 200, 300))
		AntlionEgg:SetAngles((AntlionEgg:GetPos() - entLargeHive:GetPos()):Angle() + Angle(0, math.random(-5, 5), 0))
		table.insert(tblDataTableTable.Objects, AntlionEgg)
	end
end
CIVRP_Events["Antlion_Settlement01"].Tech[3] = function(tblDataTableTable)	
	local AntlionHill = CreateCustomProp("models/props_wasteland/antlionhill.mdl", false, true)
	AntlionHill:SetPos(tblDataTableTable.Center)
	AntlionHill:SetAngles(Angle(0,math.random(0,360),0))
	table.insert(tblDataTableTable.Objects, AntlionHill)
	
	for i = 1, math.random(5, 10) do
		local Antliongrub = ents.Create("npc_antlion_grub")
		Antliongrub:SetPos(tblDataTableTable.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		Antliongrub:SetAngles(Angle(0,math.random(0,360),0))
		Antliongrub:Spawn()
		table.insert(tblDataTableTable.Objects, Antliongrub)
	end	
	
	HatchEggs(tblDataTableTable, true)
end

CIVRP_Events["Antlion_Settlement01"].Function = function(ply)
	local tblDataTable = CIVRP_Events["Antlion_Settlement01"]
	--tblDataTable.Center = Vector(0, 0, 128) + ply:GetPos() - Vector(0, 0, ply:GetPos().z)
	tblDataTable.Center = Vector(math.random(-14000, 14000), math.random(-14000, 14000), 128)
	
	tblDataTable.SquadName = tblDataTable.SquadName or ("Antlion_Settlement" .. CurTime())
	tblDataTable.Leader = ents.Create("npc_antlionguard")
	tblDataTable.Leader:SetPos(GetRandomRadiusPos(tblDataTable.Center, 100, 200))
	tblDataTable.Leader:SetModel("models/antlion_guard.mdl")
	tblDataTable.Leader:SetAngles(Angle(0, math.random(0, 360), 0))
	tblDataTable.Leader:SetKeyValue("Squad Name", tblDataTable.SquadName)
	tblDataTable.Leader:Spawn()
	tblDataTable.Leader:Activate()
	
	local entSmallHive = CreateCustomProp("models/props_hive/nest_sm_flat.mdl", false, true)
	entSmallHive:SetPos(tblDataTable.Center)
	entSmallHive:SetAngles(Angle(0, math.random(0, 360), 0))
	entSmallHive.Removelevel = 1
	table.insert(tblDataTable.Objects, entSmallHive)
	
	for i = 1, math.random(1, 5) do
		local entEgg = CreateCustomProp("models/props_hive/egg.mdl", false, true)
		entEgg:SetPos(GetRandomRadiusPos(tblDataTable.Center, 240, 300))
		entEgg:SetAngles(Angle(0,math.random(0,360),0))
		table.insert(tblDataTable.Objects, entEgg)
	end
	
	CIVRP_Register_Settlement(tblDataTable)
end