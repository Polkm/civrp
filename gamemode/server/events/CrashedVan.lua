CIVRP_Events["CrashedVan"] = {}
CIVRP_Events["CrashedVan"].Condition = function(ply) 
	return true
end
CIVRP_Events["CrashedVan"].Function = function(ply)
	local SupplyList = {"weapon_shotgun", "weapon_357", "weapon_crowbar", "item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",}
	local VanModels = {"models/props_vehicles/van001a.mdl", "models/props_vehicles/van001a_nodoor.mdl"}
	local VanSkins = 2
	local items = {}
	
	local van = ents.Create("prop_physics")
	van:SetModel(VanModels[math.random(1, table.Count(VanModels))])
	van:SetSkin(math.random(0, VanSkins - 1))
	local tries = 0
	local function Check()
		van:SetPos(Vector(ply:GetPos().x + math.random(-3000,3000),ply:GetPos().y + math.random(-3000,3000),158))
		for _,v in pairs(player.GetAll()) do
			if v:GetPos():Distance(van:GetPos()) < 800 then
				Check()
				tries = tries + 1
				if tries >= 20 then
					van:Remove()
					return false
				end
				break
			end
		end
	end
	Check()
	van:SetAngles(Angle(math.random(-5,5),math.random(0,360),math.random(-5,5)))
	van:Spawn()
	van:Activate()
	if van:GetPhysicsObject():IsValid() then
		van:GetPhysicsObject():EnableMotion(false)
	end
	van.Think = function() 
					if van:IsValid() then 
						for _,ply in pairs(player.GetAll()) do 
							if ply:GetPos():Distance(van:GetPos()) < 300 then 
								timer.Simple(60,function() if van:IsValid() then van.Think() end end)
								return false 
							end
						end 
						for _,ent in pairs(items) do
							if ent:IsValid() && !ent:GetOwner():IsPlayer() then
								ent:Remove()
							end
						end
						van:Remove() 
					end 					
				end 
	timer.Simple(300,function() if van:IsValid() then van.Think() end end)	
	
	for i = 1, math.random(0, 6) do
		local itemtbl = {}
		for itemclass,data in pairs(CIVRP_Item_Data) do
			table.insert(itemtbl,itemclass)
		end	
		local selection = table.Random(itemtbl)
		local item = ents.Create("prop_physics")
		item:SetModel(CIVRP_Item_Data[selection].Model)
		item:SetPos(van:GetPos() + van:GetAngles():Forward() * (-5 * i) + Vector(0, 0, 15))
		item:Spawn()
		item:Activate()
		item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		item.ItemClass = selection
		table.insert(items, item)
	end
end