CIVRP_Events["Healthkit"] = {}
CIVRP_Events["Healthkit"].Chance = 70
CIVRP_Events["Healthkit"].Condition = function(ply) 
	if ply:Health() <= 90 then
		return true
	end
	return false
end
CIVRP_Events["Healthkit"].Function = function(ply)
	local item = ents.Create("prop_physics")
	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item:SetModel(CIVRP_Item_Data["item_healthkit"].Model)
	item:SetPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item:Spawn()
	item:Activate()
	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	item.ItemClass = "item_healthkit"
	CheckDistanceFunction(item, 500, 60)
end



CIVRP_Events["Supply"] = {}
CIVRP_Events["Supply"].Chance = 60
CIVRP_Events["Supply"].Condition = function(ply) 
	return true
end
CIVRP_Events["Supply"].Function = function(ply)
	local SupplyList = {
		"item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol",
		"item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",
		"item_ammo_smg1_grenade", "item_box_buckshot", "item_ammo_ar2_altfire", "weapon_frag",}
	local itemtbl = {}
	for itemclass,data in pairs(CIVRP_Item_Data) do
		table.insert(itemtbl,itemclass)
	end	
	local selection = table.Random(itemtbl)
	local item = ents.Create("prop_physics")
	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item:SetModel(CIVRP_Item_Data[selection].Model)
	item:SetPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item:Spawn()
	item:Activate()
	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	item.ItemClass = selection
	CheckDistanceFunction(item, 500, 30)
end