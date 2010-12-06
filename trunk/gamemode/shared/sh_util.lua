function GetPlayerFactor(intNumberOPlayer)
	return 1 / ((math.Clamp(intNumberOPlayer || table.Count(player.GetAll()), 1, 4) / 2) + 0.5)
end

function GetDifficultyFactor()
	if CIVRP_DIFFICULTY == "Peacefull" then
		return 0.2
	elseif CIVRP_DIFFICULTY == "Normal" then
		return 1.0
	elseif CIVRP_DIFFICULTY == "Hard" then
		return 1.5
	elseif CIVRP_DIFFICULTY == "Hell" then
		return 2.5
	end
	return 1
end

function CheckDistanceFunction(item, distance, interval)
	if item:IsValid() then 
		for _,ply in pairs(player.GetAll()) do 
			if ply:GetPos():Distance(item:GetPos()) <= distance then 
				timer.Simple(interval, function() if item:IsValid() then CheckDistanceFunction(item, distance, interval) end end)
				return false
			end
		end
		if !item:GetOwner():IsPlayer() then
			item:Remove() 
		end
	end
end

function CompressInteger(intInteger)
	local intMin = 48
	local intMax = 125
	local intBytes = math.floor(intInteger / (intMax - intMin))
	local intRemander = intInteger - (intBytes * (intMax - intMin)) + intMin
	if intBytes > 0 then
		if intRemander == 92 then intRemander = 126 end
		return CompressInteger(intBytes) .. string.char(intRemander)
	else
		return string.char(intRemander)
	end
end

function DecompressInteger(strCompresseed)
	local intMin = 48
	local intMax = 125
	local tblValues = string.Explode("", strCompresseed)
	local intValue = 0
	local intBytes = table.Count(tblValues)
	for i = 1, intBytes do
		local intByte = 0
		if tblValues[i] == "~" then intByte = 92 else intByte = string.byte(tblValues[i]) end
		intValue = intValue + (intByte - intMin) * math.pow(intMax - intMin, intBytes - i)
	end
	return intValue
end

if SERVER then
	function SendUsrMsg(strName, plyTarget, tblArgs)
		umsg.Start(strName, plyTarget)
		for _, value in pairs(tblArgs or {}) do
			if type(value) == "string" then umsg.String(value)
			elseif type(value) == "number" then umsg.Long(value)
			elseif type(value) == "boolean" then umsg.Bool(value)
			elseif type(value) == "Entity" or type(value) == "Player" then umsg.Entity(value)
			elseif type(value) == "Vector" then umsg.Vector(value)
			elseif type(value) == "Angle" then umsg.Angle(value)
			elseif type(value) == "table" then umsg.String(glon.encode(value)) end
		end
		umsg.End()
	end
	
	function CreateCustomNPC(strClass, strSquadName, intHealthFctr, strMat, tblSkins, tblKeyValues)
		local npc = ents.Create(strClass)
		if strSquadName then npc:SetKeyValue("Squad Name", strSquadName) end
		npc:SetHealth(npc:Health() * GetDifficultyFactor() * (intHealthFctr or 1))
		npc:SetMaterial(strMat or nil)
		
		if CIVRP_DIFFICULTY == "Hard" then
			npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
		elseif  CIVRP_DIFFICULTY == "Hell" then
			npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_VERY_GOOD)
		end
		if tblSkins then npc:SetSkin(table.Random(tblSkins)) end
		if tblKeyValues != nil then
			for key, tbl in pairs(tblKeyValues) do
				if tbl.Min && tbl.Max then
					npc:SetKeyValue(key, math.random(tbl.Min, tbl.Max))
				else
					npc:SetKeyValue(key, tostring(table.Random(tbl)))
				end
			end
		end
		npc:SetKeyValue( "spawnflags", npc:GetKeyValues().spawnflags + 1 + 512)
		return npc
	end
	
	function CreateCustomProp(strModel, DropToFloor, StopMotion)
		local Prop = ents.Create("prop_physics")
		Prop:SetModel(strModel)
		Prop:Spawn()
		if (DropToFloor) then Prop:DropToFloor() end
		if (Prop:GetPhysicsObject():IsValid() &&  StopMotion) then
			Prop:GetPhysicsObject():EnableMotion(false)
		end
		function Prop:SetKeyValues(tbltable)
			for key, tbl in pairs(tbltable) do
				if tbl.Min && tbl.Max then
					npc:SetKeyValue(key, math.random(tbl.Min, tbl.Max))
				else
					npc:SetKeyValue(key, tostring(table.Random(tbl)))
				end
			end
		end
		return Prop
	end
	
	function GetRandomRadiusPos(vecOrigin, intMinRadius, intMaxRadius)
		intMaxRadius = intMaxRadius or intMinRadius
		distance = math.random(intMinRadius, intMaxRadius)
		angle = math.random(0, 360)
		return vecOrigin + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
	end
end

local randseed = 1337
function math.pSeedRand(fSeed)
	randseed = fSeed
end
function math.pRand()
	randseed = ((8253729 * randseed) + 2396403)
	randseed = randseed - math.floor(randseed / 32767) * 32767
	return randseed / 32767
end