function GetPlayerFactor()
	return 1 / ((math.Clamp(table.Count(player.GetAll()), 1, 4) / 2) + 0.5)
end
function GetDifficultyFactor()
	if CIVRP_DIFFICULTY == "Peacefull" then
		return 0.2
	elseif CIVRP_DIFFICULTY == "Normal" then
		return 1.0
	elseif CIVRP_DIFFICULTY == "Hard" then
		return 2.0
	elseif CIVRP_DIFFICULTY == "Hell" then
		return 4.0
	end
	return 1
end

function CheckDistanceFunction(item, distance, interval)
	if item:IsValid() then 
		for _,ply in pairs(player.GetAll()) do 
			if ply:GetPos():Distance(item:GetPos()) <= distance then 
				timer.Simple(interval, function() if item:IsValid() then CheckDistanceFunction(item, distance) end end)
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
	local intMax = 122
	local intBytes = math.floor(intInteger / (intMax - intMin))
	local intRemander = intInteger - (intBytes * (intMax - intMin))
	if intBytes > 0 then
		return CompressInteger(intBytes) .. string.char(intMin + intRemander)
	else
		return string.char(intMin + intRemander)
	end
end


function DecompressInteger(strCompresseed)
	local intMin = 48
	local intMax = 122
	local tblValues = string.Explode("", strCompresseed)
	local intValue = 0
	local intBytes = table.Count(tblValues)
	for i = 1, intBytes do
		intValue = intValue + (string.byte(tblValues[i]) - intMin) * math.pow(intMax - intMin, intBytes - i)
	end
	print(strCompresseed .. " ----> " .. intValue .. "  %" .. ())
end

DecompressInteger(CompressInteger(8953418905785))

local randseed = 1337
function math.pSeedRand(fSeed)
	randseed = fSeed
end
function math.pRand()
	randseed = ((8253729 * randseed) + 2396403)
	randseed = randseed - math.floor(randseed / 32767) * 32767
	return randseed / 32767
end