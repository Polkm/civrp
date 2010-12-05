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
					timer.Simple(300,function() CIVRP_Progress_Settlement(ID) end)
				end
			end
		end
	end
end
--- Combine Settlement Start --
CIVRP_Events["Combine_Settlement01"] = {}
CIVRP_Events["Combine_Settlement01"].Condition = function(ply) 
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
CIVRP_Events["Combine_Settlement01"].Tech = {}
CIVRP_Events["Combine_Settlement01"].Tech[1] = function(data)
	local objects = {}
	
	local thumper = ents.Create("prop_thumper")
	thumper:SetPos(data.Center)
	thumper:SetAngles(Angle(0,math.random(0,360),0))
	thumper:Spawn()
	thumper:Activate()
	thumper.Removelevel = 4
	thumper.DecayFunction = function(self,data)
		self:Fire("Disable",'',0)
		self.DecayFunction = nil
	end
	if thumper:GetPhysicsObject():IsValid() then
		thumper:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects,thumper)
	
	local crate = ents.Create("prop_physics") 
	crate:SetPos(thumper:GetPos() + thumper:GetAngles():Right() * 120 + thumper:GetAngles():Up() * 50)
	crate:SetModel("models/items/ammocrate_ar2.mdl")
	crate:SetAngles(Angle(0,thumper:GetAngles().y - 90,0))
	crate:Spawn()
	crate:DropToFloor()
	crate.Removelevel = 4
	crate:Activate() 
	if crate:GetPhysicsObject():IsValid() then
		crate:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects,crate)

	local SupplyList = {"item_healthvial","item_ammo_smg1","item_ammo_ar2","item_ammo_smg1_grenade","item_ammo_ar2_altfire", "weapon_frag",}
	local itemtbl = {}
	for itemclass,data in pairs(CIVRP_Item_Data) do
		table.insert(itemtbl,itemclass)
	end	
	local selection = table.Random(itemtbl)
	local number = math.random(2,3)
	for i = 1, number do
		local item = ents.Create("prop_physics")
		item:SetModel(CIVRP_Item_Data[selection].Model)
		item:SetAngles(crate:GetAngles())
		item:Spawn()
		local width = Vector(item:OBBMaxs().x,item:OBBMaxs().y,0) - Vector(item:OBBMins().x,item:OBBMins().y,0)
		item:SetPos(crate:GetPos() + crate:GetAngles():Up()  * 30 + crate:GetAngles():Up()  * 20 * i + crate:GetAngles():Right() * -10 * i + crate:GetAngles():Right() * 20 + width + crate:GetAngles():Forward() * -10 )
		item:Activate()
		item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		item.ItemClass = selection
	end
	
	return {NPCS = nil,OBJECTS = objects}
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
	return {NPCS = nil,OBJECTS = objects}
end

CIVRP_Events["Combine_Settlement01"].Tech[3] = function(data)
	local npcs =  {}
	local turretnum = math.random(1,3)
	for i = 1, turretnum do
		local distance = math.random(450, 480)
		local angle = math.random(0, 360)
		local turret = ents.Create("npc_turret_floor")
		turret:SetPos(data.Center + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		turret:SetAngles((turret:GetPos() - data.Center):Angle())
		turret:SetPos(turret:GetPos() + Vector(0,0,30))
		turret:Spawn()
		turret:DropToFloor()
		table.insert(npcs,turret)
	end
	local function think() 
		if npcs != nil then
			for _,turret in pairs(npcs) do
				if turret:IsValid() then
					if (turret:GetAngles().p >= 50 or turret:GetAngles().p < -50 ) ||	(turret:GetAngles().r >= 50 or turret:GetAngles().r < -50 ) then
						turret:Remove()
					end
				end
			end
		end
		if npcs != nil then
			timer.Simple(60,function() think() end)
		end
	end
	timer.Simple(60,function() think() end)
	return {NPCS = npcs,OBJECTS = nil}
end

CIVRP_Events["Combine_Settlement01"].Function = function(ply)	
	local objects = {}
	
	local vx = math.random(-14000, 14000)--
	local vy = math.random(-14000, 14000)--
	local CENTER = Vector(vx,vy,128)
	
	local apc = ents.Create("prop_physics")
	apc:SetModel("models/combine_apc_wheelcollision.mdl")
	apc:SetPos(CENTER)
	apc:SetAngles(Angle(0,math.random(0,360),0))
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
	leader:SetAngles(Angle(0,math.random(0,360),0))
	
	local Weapons = {"weapon_ar2", "weapon_smg1",}
	leader:SetKeyValue("additionalequipment", table.Random(Weapons))
	
	leader:Spawn()
	leader:Activate()

	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = {Class = "npc_combine_s", Weapons = {"weapon_ar2", "weapon_smg1", "weapon_shotgun"},}
	Minions.Number = math.random(1,2)
	
	local npcs = {}
	for i = 1, Minions.Number do
		local MinionSelection = table.Random(Minions.Type)
		local npc = ents.Create(MinionSelection.Class)
		npc:SetPos(leader:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0))
		if MinionSelection.Weapons != nil then
			npc:SetKeyValue("additionalequipment", table.Random(MinionSelection.Weapons))
		end
		npc:Spawn()		
		npc:Activate()
		table.insert(npcs,npc)
	end

	local ID = CIVRP_Register_Settlement(leader,objects,npcs,CENTER,"Combine_Settlement01")
	timer.Simple(300,function() CIVRP_Progress_Settlement(ID) end)
end

--- Combine Settlement End --
--- Antlion Settlement Start ---
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
	local Minions = {}
	Minions.Class = "npc_antlion_worker"
	Minions.Number = math.random(2, 4)
	
	local npcs = {}
	for i = 1, Minions.Number do
		local npc = ents.Create(Minions.Class)
		npc:SetPos(data.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		npc:SetKeyValue("Start Burrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
		table.insert(npcs, npc)
	end
	
	local grub = {}
	grub.Number = math.random(5, 10)
	for i = 1, grub.Number do
		local npc = ents.Create("npc_antlion_grub")
		npc:SetPos(data.Center + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		npc:SetKeyValue("Start Burrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
		table.insert(npcs, npc)
	end

	return {NPCS = npcs, OBJECTS = nil}
end
CIVRP_Events["Antlion_Settlement01"].Tech[2] = function(data)
	local objects = {}
	local DC = data.Center
	local vx = math.Clamp(math.random(-1000, 1000) + DC.x, -13000, 13000)
	local vy = math.Clamp(math.random(-1000, 1000) + DC.y, -13000, 13000)
	
	local ClampedV = Vector(vx, vy, DC.z)
	
	local AntlionHill = ents.Create("prop_physics")
	AntlionHill:SetModel("models/props_wasteland/antlionhill.mdl")
	AntlionHill:SetPos(ClampedV)
	AntlionHill:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHill:Spawn()
	AntlionHill:Activate()
	if AntlionHill:GetPhysicsObject():IsValid() then
		AntlionHill:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects, AntlionHill)
	
	data.Leader:SetLastPosition( ClampedV + AntlionHill:GetAngles():Right() * -200)
	data.Leader:SetSchedule(  SCHED_FORCED_GO_RUN )
	
	local npcs = {}

	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = "npc_antlion_worker"
	Minions.Type[2] = "npc_antlion_grub"
	Minions.Type[3] = "npc_antlion"
	Minions.Number = math.random(7, 12)
	
	
	for i = 1, Minions.Number do
		local npc = ents.Create(Minions.Type[math.random(1, 3)])
		npc:SetPos(ClampedV + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		npc:SetKeyValue("Start Burrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
		table.insert(npcs, npc)
	end
	
	return {NPCS = npcs, OBJECTS = objects}
end


CIVRP_Events["Antlion_Settlement01"].Function = function(ply)	
	local objects = {}
	
	local vx = math.random(-14000, 14000)--
	local vy = math.random(-14000, 14000)--
	local CENTER = Vector(vx, vy, 128)
	
	local AntlionHill = ents.Create("prop_physics")
	AntlionHill:SetModel("models/props_wasteland/antlionhill.mdl")
	AntlionHill:SetPos(CENTER)
	AntlionHill:SetAngles(Angle(0,math.random(0,360),0))
	AntlionHill:Spawn()
	AntlionHill:Activate()
	if AntlionHill:GetPhysicsObject():IsValid() then
		AntlionHill:GetPhysicsObject():EnableMotion(false)
	end
	table.insert(objects,AntlionHill)

	local leader = ents.Create("npc_antlionguard")
	leader:SetPos(AntlionHill:GetPos() + AntlionHill:GetAngles():Right() * -200)
	leader:SetModel("models/antlion_guard.mdl")
	leader:SetAngles(Angle(0,math.random(0,360),0))
		
	leader:Spawn()
	leader:Activate()
	
	local Minions = {}
	Minions.Class = "npc_antlion"
	Minions.Number = math.random(1, 3)
	
	local npcs = {}
	for i = 1, Minions.Number do
		local npc = ents.Create(Minions.Class)
		npc:SetPos(CENTER + Vector(math.random(-400, 400), math.random(-400, 400), 0))
		npc:SetKeyValue("Start Burrowed", 1)
		npc:Spawn()		
		npc:Activate()
		npc:Fire('Unburrow','',0.5)
		table.insert(npcs, npc)
	end
	local ID = CIVRP_Register_Settlement(leader, objects, npcs, CENTER, "Antlion_Settlement01")
	timer.Simple(200, function() CIVRP_Progress_Settlement(ID) end)
end
--- Antlion Settlement End ---