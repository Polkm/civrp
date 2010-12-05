function GM:OnNPCKilled(  NPC,  killer,  weapon )
	if NPC.SETTLEMENTID != nil then
		if CIVRP_Settlements[NPC.SETTLEMENTID] != "empty" then
			local ID = NPC.SETTLEMENTID
			timer.Simple(60,function() if CIVRP_Settlements[ID] != "empty" then CIVRP_Settlement_Disband(ID) end end)
		end
	end
end

CIVRP_MaxSettlements = 4

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
			timer.Simple(math.random(200,400),	function() 
				if object:IsValid() then 
					if object:GetPhysicsObject():IsValid() then 
						object:GetPhysicsObject():EnableMotion(true) 
						object:GetPhysicsObject():ApplyForceCenter(Vector(math.random(50,100)*object:GetPhysicsObject():GetMass(),math.random(50,100)*object:GetPhysicsObject():GetMass(),math.random(50,100)*object:GetPhysicsObject():GetMass()))
						timer.Simple(math.random(30,60), function() if object:IsValid() then  object:Remove() end end)
					else
						object:Remove()
					end
				end	
			end)
		end
	end
	for _,npc in pairs(data.Npcs) do
		if !npc:IsValid() then
			table.remove(data.Npcs,_)
		elseif npc:IsValid() then
			npc:TakeDamage(150)
		end	
	end
end

function CIVRP_Settlement_Clean(ID)	
	local data = CIVRP_Settlements[ID] || nil
	if data == nil then return false end
	for _,object in pairs(data.Objects) do
		if !object:IsValid() then
			table.remove(data.Objects,_)
		elseif object:IsValid() && object.Removelevel == data.TechLevel then
			object:Remove()
		end	
	end
	for _,npc in pairs(data.Npcs) do
		if !npc:IsValid() then
			table.remove(data.Npcs,_)
		elseif npc:IsValid() && npc.Removelevel == data.TechLevel then
			npc:Remove()
		end	
	end
end

function CIVRP_Register_Settlement(leader,propstbl,npcstbl,CENTERPOS,EventKey)
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
			CIVRP_Settlements[i].Npcs = npcstbl
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
		if settlement.Leader:IsValid() then
			if settlement.TechLevel < table.Count(CIVRP_Events[settlement.EventKey].Tech) then
				settlement.TechLevel = settlement.TechLevel + 1
				CIVRP_Settlement_Clean(ID)
				local data = CIVRP_Events[settlement.EventKey].Tech[settlement.TechLevel](settlement)
				if data != nil then
					for _,object in pairs(data.OBJECTS || {}) do
						if object:IsValid() then
							table.insert(settlement.Objects,object)
						end
					end
					for _,npc in pairs(data.NPCS || {} ) do
						if npc:IsValid() then
							table.insert(settlement.Npcs,npc)
						end
					end
				end
				if settlement.TechLevel < table.Count(CIVRP_Events[settlement.EventKey].Tech) then
					if (settlement.ProgressRate && settlement.ProgressRate > 0) then
						timer.Simple(settlement.ProgressRate, function() CIVRP_Progress_Settlement(ID) end)
					else
						timer.Simple(300, function() CIVRP_Progress_Settlement(ID) end)
					end
				end
			end
		end
	end
end