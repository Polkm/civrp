function AutoAdd_LuaFiles()
	if SERVER then
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				AddCSLuaFile('client/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				AddCSLuaFile('shared/'..file)
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
			if string.find(file,".lua") then
				include('server/'..file)
				Msg(file..",")
			end
		end
	else
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				include('client/'..file)
				Msg(file..",")
			end
		end
	end
end

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

GM.Name 		= "Civilization Role Play"
GM.Author 		= "Noobulater"
GM.Email 		= "killerkat48@yahoo.com"
GM.Website 		= ""
GM.TeamBased 	= false

GM.Path = "CivRP"

CIVRP_Enviorment_Models = {}
CIVRP_Enviorment_Models[1] = 	{ID = 1, Model = "models/props_foliage/tree_pine04.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[2] = 	{ID = 2, Model = "models/props_foliage/tree_pine05.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[3] = 	{ID = 3, Model = "models/props_foliage/tree_pine06.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[4] = 	{ID = 4, Model = "models/props_foliage/tree_dry01.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[5] = 	{ID = 5, Model = "models/props_foliage/tree_dry02.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[6] = 	{ID = 6, Model = "models/props_foliage/tree_dead01.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[7] = 	{ID = 7, Model = "models/props_foliage/tree_dead02.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[8] = 	{ID = 8, Model = "models/props_foliage/tree_dead03.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[9] = 	{ID = 9, Model = "models/props_foliage/tree_dead04.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[10] = 	{ID = 10, Model = "models/props_foliage/tree_pine04.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[11] = 	{ID = 11, Model = "models/props_foliage/ferns01.mdl", Solid = false, Generated = true}
CIVRP_Enviorment_Models[12] = 	{ID = 12, Model = "models/props_foliage/ferns02.mdl", Solid = false, Generated = true}
CIVRP_Enviorment_Models[13] = 	{ID = 13, Model = "models/props_foliage/ferns03.mdl", Solid = false, Generated = true}
CIVRP_Enviorment_Models[14] = 	{ID = 14, Model = "models/props_foliage/tree_pine_large.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[15] = 	{ID = 15, Model = "models/props_canal/rock_riverbed02a.mdl", Solid = true}


--CIVRP_Enviorment_Models[15] = 	{ID = 15, Model = "models/props_canal/rock_riverbed02b.mdl", Solid = true}
--models/Cliffs/rocks_small01_veg.mdl
--models/Cliffs/rocks_large01_veg.mdl

-- Watch the manual check for 11 and up in CL

CIVRP_SOLIDDISTANCE = 200
CIVRP_FADEDISTANCE = 2500
CIVRP_SUPERCHUNKSIZE = 2500
CIVRP_CHUNKSIZE = 500
CIVRP_ENVIORMENTSIZE = 10000

CIVRP_DIFFICULTY_SETTINGS = {"Peacefull", "Normal", "Hard", "Hell"}
CIVRP_DIFFICULTY = "Normal" --Good for debuggin

local function RestorHealth(plyUser, amount)
	if plyUser:Health() < plyUser:GetMaxHealth() then
		plyUser:SetHealth(math.Clamp(plyUser:Health() + amount, 0, plyUser:GetMaxHealth()))
		return true
	end
	return false
end

local function PlaySound(plyUser, strSound, volume, pitch)
	plyUser:EmitSound(strSound, volume or 100, pitch or 100)
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

local function FireBullets(plyUser, intNumber, intSpread, intDamage)
	local tblBullet = {}
	tblBullet.Num = intNumber or 1
	tblBullet.Src = plyUser:GetShootPos()
	tblBullet.Dir = plyUser:GetAngles():Forward()
	tblBullet.Spread = Vector(intSpread or 0.01, intSpread or 0.01, 0)
	tblBullet.Tracer = 2
	tblBullet.Force = intDamage or 1
	tblBullet.Damage = intDamage or 1
	plyUser:FireBullets(tblBullet)
end

CIVRP_Item_Data = {}
CIVRP_Item_Data["item_healthvial"] = {Class = "item_healthvial", Model = "models/healthvial.mdl"}
CIVRP_Item_Data["item_healthvial"].HoldPos = Vector(15, -15, 8)
CIVRP_Item_Data["item_healthvial"].HoldAngle = Angle(0, 0, 0)
CIVRP_Item_Data["item_healthvial"].FireFunction = function(plyUser)
	local worked = RestorHealth(plyUser, 20)
	if worked then PlaySound(plyUser, "items/smallmedkit1.wav", 70) end
	return worked
end

CIVRP_Item_Data = {}
CIVRP_Item_Data["item_healthkit"] = {Class = "item_healthkit", Model = "models/Items/HealthKit.mdl"}
CIVRP_Item_Data["item_healthkit"].HoldPos = Vector(20, -4, 10)
CIVRP_Item_Data["item_healthkit"].HoldAngle = Angle(90, 180, 0)
CIVRP_Item_Data["item_healthkit"].FireFunction = function(plyUser)
	local worked = RestorHealth(plyUser, 50)
	if worked then PlaySound(plyUser, "items/smallmedkit1.wav", 70) end
	return worked
end




CIVRP_Item_Data["weapon_pistol"] = {Class = "weapon_pistol", Model = "models/weapons/W_pistol.mdl"}
CIVRP_Item_Data["weapon_pistol"].HoldPos = Vector(15, -8, 8)
CIVRP_Item_Data["weapon_pistol"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["weapon_pistol"].AmmoType = "pistol"
CIVRP_Item_Data["weapon_pistol"].ClipSize = 10
CIVRP_Item_Data["weapon_pistol"].LoadedAmmo = 0
CIVRP_Item_Data["weapon_pistol"].NextFire = 0
CIVRP_Item_Data["weapon_pistol"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if tblItem.LoadedAmmp <= 0 then
		if plyUser:GetAmmoCount(tblItem.AmmoType) >= tblItem.ClipSize then
			plyUser:RemoveAmmo(tblItem.ClipSize, tblItem.AmmoType)
		end
	else
		FireBullets(plyUser, 1, 0.05, 20)
		PlaySound(plyUser, "weapons/pistol/pistol_fire2.wav")
		
	end
	return false
end




