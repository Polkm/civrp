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