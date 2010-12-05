GM.Name 		= "Civilization Role Play"
GM.Author 		= "Noobulater + Polkm"
GM.Email 		= "killerkat48@yahoo.com"
GM.Website 		= "www.shellshocked.net46.net"
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
CIVRP_Enviorment_Models[11] = 	{ID = 11, Model = "models/props_foliage/ferns01.mdl", Solid = false, Generated = false}
CIVRP_Enviorment_Models[12] = 	{ID = 12, Model = "models/props_foliage/ferns02.mdl", Solid = false, Generated = false}
CIVRP_Enviorment_Models[13] = 	{ID = 13, Model = "models/props_foliage/ferns03.mdl", Solid = false, Generated = false}
CIVRP_Enviorment_Models[14] = 	{ID = 14, Model = "models/props_foliage/tree_pine_large.mdl", Solid = true, Generated = true}
CIVRP_Enviorment_Models[15] =	{ID = 15, Model = "models/props_canal/rock_riverbed02a.mdl", Solid = true}


--CIVRP_Enviorment_Models[15] = 	{ID = 15, Model = "models/props_canal/rock_riverbed02b.mdl", Solid = true}
--models/Cliffs/rocks_small01_veg.mdl
--models/Cliffs/rocks_large01_veg.mdl

-- Watch the manual check for 11 and up in CL

CIVRP_SOLIDDISTANCE = 200
CIVRP_FADEDISTANCE = 2500
CIVRP_SUPERCHUNKSIZE = 2500
CIVRP_CHUNKSIZE = 500
CIVRP_ENVIORMENTSIZE = 15000

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