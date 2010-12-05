CIVRP_Events["HeadCrabCanister"] = {}
CIVRP_Events["HeadCrabCanister"].Condition = function(ply) 
	return true
end
CIVRP_Events["HeadCrabCanister"].Function = function(ply)
	local intHeadCrabRange = 700
	local tblHeadCrabs = {"0", "1", "2"} --0 = Normal, 1 = Fast, 2 = Poision
	local intHeadCrabMin = 4
	local intHeadCrabMax = 8
	local intHeadCrabDamage = 20
	
	local distance = math.random(300, intHeadCrabRange)
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