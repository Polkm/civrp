CIVRP_MaxSettlements = 4
CIVRP_DefaultSettlementProgressTime = 250

function GM:OnNPCKilled(entNPC, entKiller, entWeapon)
	if entNPC.SETTLEMENTID != nil && CIVRP_Settlements[entNPC.SETTLEMENTID] != "empty" then
		local ID = entNPC.SETTLEMENTID
		timer.Simple(60, function() if CIVRP_Settlements[ID] != "empty" then CIVRP_Settlement_Disband(ID) end end)
	end
end

function CIVRP_Settlement_Disband(ID)	
	CIVRP_Settlement_Clean(ID)
	CIVRP_Settlement_Decay(ID)	
	CIVRP_Settlements[ID] = "empty"
end

function CIVRP_Settlement_Decay(ID)	
	local data = CIVRP_Settlements[ID] || nil
	if data == nil then return false end
	for _,object in pairs(data.Objects) do
		if !object:IsValid() then
			table.remove(data.Objects,_)
		elseif object:IsValid() && object.Removelevel == data.TechLevel then
			object:Remove()
		elseif object:IsValid() then
			if object.DecayFunction != nil then
				object.DecayFunction(object,data)
			end
			timer.Simple(math.random(200,400), function() 
				if object:IsValid() then 
					if object:GetPhysicsObject():IsValid() then 
						object:GetPhysicsObject():EnableMotion(true) 
						object:GetPhysicsObject():ApplyForceCenter(Vector(math.random(50, 100) * object:GetPhysicsObject():GetMass(), math.random(50, 100) * object:GetPhysicsObject():GetMass(),math.random(50,100)*object:GetPhysicsObject():GetMass()))
						timer.Simple(math.random(30, 60), function() if object:IsValid() then  object:Remove() end end)
					else
						object:Remove()
					end
				end	
			end)
		end
	end
	for _, npc in pairs(data.Npcs) do
		if !npc:IsValid() then
			table.remove(data.Npcs, _)
		elseif npc:IsValid() then
			npc:TakeDamage(150)
		end	
	end
end

function CIVRP_Settlement_Clean(ID)	
	local data = CIVRP_Settlements[ID] || nil
	if data == nil then return false end
	for _, object in pairs(data.Objects) do
		if !object:IsValid() then
			table.remove(data.Objects, _)
		elseif object:IsValid() && object.Removelevel && object.Removelevel <= data.TechLevel then
			table.remove(data.Objects, _)
			object:Remove()
		end
	end
	for _, npc in pairs(data.Npcs) do
		if !npc:IsValid() then
			table.remove(data.Npcs,_)
		elseif npc:IsValid() && npc.Removelevel && npc.Removelevel == data.TechLevel then
			table.remove(data.Npcs, _)
			npc:Remove()
		end
	end
end

function CIVRP_Register_Settlement(tblDataTable)
	if CIVRP_Settlements == nil then
		CIVRP_Settlements = {}
		for i = 1, CIVRP_MaxSettlements do
			CIVRP_Settlements[i] = "empty"
		end
	end
	
	for i = 1, table.Count(CIVRP_Settlements) do
		if CIVRP_Settlements[i] == "empty" then
			CIVRP_Settlements[i] = tblDataTable
			CIVRP_Settlements[i].Leader.SETTLEMENTID = i
			CIVRP_Settlements[i].TechLevel = 0
			CIVRP_Settlements[i].ID = i
			timer.Simple(CIVRP_Settlements[i].ProgressRate, function() CIVRP_Progress_Settlement(i) end)
			return i
		end
	end
end

function CIVRP_Progress_Settlement(ID)
	local tblSettlementData = CIVRP_Settlements[ID]
	if tblSettlementData != "empty" && tblSettlementData.Leader:IsValid() then
		if tblSettlementData.TechLevel < table.Count(tblSettlementData.Tech) then
			tblSettlementData.TechLevel = tblSettlementData.TechLevel + 1
			CIVRP_Settlement_Clean(ID)
			tblSettlementData.Tech[tblSettlementData.TechLevel](tblSettlementData)
			if tblSettlementData.TechLevel < table.Count(tblSettlementData.Tech) then
				if tblSettlementData.ProgressRate && tblSettlementData.ProgressRate >= 0 then
					timer.Simple(tblSettlementData.ProgressRate, function() CIVRP_Progress_Settlement(ID) end)
				else
					timer.Simple(CIVRP_DefaultSettlementProgressTime, function() CIVRP_Progress_Settlement(ID) end)
				end
			end
		end
	end
end