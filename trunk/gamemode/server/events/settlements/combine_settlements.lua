CIVRP_Events["Combine_Settlement01"] = {}
CIVRP_Events["Combine_Settlement01"].ProgressRate = 250
CIVRP_Events["Combine_Settlement01"].EventKey = "Combine_Settlement01"
CIVRP_Events["Combine_Settlement01"].Objects = {}
CIVRP_Events["Combine_Settlement01"].Npcs = {}
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
CIVRP_Events["Combine_Settlement01"].Tech[1] = function(tblDataTableTable)
	local thumper = ents.Create("prop_thumper")
	thumper:SetPos(tblDataTableTable.Center)
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
	table.insert(tblDataTableTable.Objects, thumper)
	
	local crate = CreateCustomProp("models/items/ammocrate_ar2.mdl", true, true)
	crate:SetPos(thumper:GetPos() + thumper:GetAngles():Right() * 120 + thumper:GetAngles():Up() * 50)
	crate:SetAngles(Angle(0,thumper:GetAngles().y - 90,0))
	crate.Removelevel = 4
	table.insert(tblDataTableTable.Objects, crate)

	local SupplyList = {"item_healthvial","item_ammo_smg1","item_ammo_ar2","item_ammo_smg1_grenade","item_ammo_ar2_altfire", "weapon_frag",}
	local itemtbl = {}
	for itemclass,data in pairs(CIVRP_Item_Data) do
		table.insert(itemtbl, itemclass)
	end	
	local selection = table.Random(itemtbl)
	local number = math.random(2,3)
	for i = 1, number do
		local item = CreateCustomProp(CIVRP_Item_Data[selection].Model, false, false)
		item:SetAngles(crate:GetAngles())
		local width = Vector(item:OBBMaxs().x,item:OBBMaxs().y,0) - Vector(item:OBBMins().x,item:OBBMins().y,0)
		item:SetPos(crate:GetPos() + crate:GetAngles():Up()  * 30 + crate:GetAngles():Up()  * 20 * i + crate:GetAngles():Right() * -10 * i + crate:GetAngles():Right() * 20 + width + crate:GetAngles():Forward() * -10 )
		item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		item.ItemClass = selection
	end
end

CIVRP_Events["Combine_Settlement01"].Tech[2] = function(tblDataTableTable)
	for i = 1, math.random(4, 14) do
		local distance = math.random(490, 510)
		local angle = math.random(0, 360)
		local cade = CreateCustomProp("models/props_combine/combine_barricade_short01a.mdl", false, true)
		cade:SetPos(tblDataTableTable.Center + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		cade:SetAngles((cade:GetPos() - tblDataTableTable.Center):Angle())
		cade:SetPos(cade:GetPos() + Vector(0,0,30))
		cade.RemoveLevel = 4
		table.insert(tblDataTableTable.Objects, cade)
	end
end

CIVRP_Events["Combine_Settlement01"].Tech[3] = function(tblDataTableTable)
	for i = 1, math.random(1, 3) do
		local distance = math.random(450, 480)
		local angle = math.random(0, 360)
		local turret = ents.Create("npc_turret_floor")
		turret:SetPos(tblDataTableTable.Center + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		turret:SetAngles((turret:GetPos() - tblDataTableTable.Center):Angle())
		turret:SetPos(turret:GetPos() + Vector(0, 0, 30))
		turret:Spawn()
		turret:DropToFloor()
		table.insert(tblDataTableTable.Npcs, turret)
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
end

CIVRP_Events["Combine_Settlement01"].Function = function(ply)	
	local tblDataTable = CIVRP_Events["Combine_Settlement01"]
	tblDataTable.Center = Vector(math.random(-14000, 14000), math.random(-14000, 14000), 128)
	
	local apc = ents.Create( "prop_vehicle_apc" )
	apc:SetKeyValue( "model", "models/combine_apc.mdl" )
	apc:SetKeyValue( "vehiclescript", "scripts/vehicles/apc_npc.txt" )
	apc:SetKeyValue( "actionScale", "1" )
	apc:SetPos( tblDataTable.Center )
	apc:SetAngles(Angle(0,math.random(0,360),0))
	apc:Spawn()
	apc:SetName( "Combine_apc" .. apc:EntIndex() )
	apc:Activate()
	table.insert(tblDataTable.Objects, apc)
	
	local apc_driver = ents.Create( "npc_apcdriver" )
	apc_driver:SetKeyValue( "vehicle", "Combine_apc" .. apc:EntIndex() )
	apc_driver:SetName( "Combine_apc" .. apc:EntIndex() .. "_driver" )
	apc_driver:SetPos( tblDataTable.Center )
	apc_driver:Spawn()
	apc_driver:Activate()
	
	tblDataTable.Leader = ents.Create("npc_combine_s")
	tblDataTable.Leader:SetPos(apc:GetPos() + apc:GetAngles():Right() * -200)
	tblDataTable.Leader:SetModel("models/combine_super_soldier.mdl")
	tblDataTable.Leader:SetAngles(Angle(0, math.random(0, 360), 0))
	
	local Weapons = {"weapon_ar2", "weapon_smg1",}
	tblDataTable.Leader:SetKeyValue("additionalequipment", table.Random(Weapons))
	
	tblDataTable.Leader:Spawn()
	tblDataTable.Leader:Activate()
	
	local Minions = {}
	Minions.Type = {}
	Minions.Type[1] = {Class = "npc_combine_s", Weapons = {"weapon_ar2", "weapon_smg1", "weapon_shotgun"},}
	Minions.Number = math.random(1, 2)
	
	local npcs = {}
	for i = 1, Minions.Number do
		local MinionSelection = table.Random(Minions.Type)
		local npc = ents.Create(MinionSelection.Class)
		npc:SetPos(tblDataTable.Leader:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0))
		if MinionSelection.Weapons != nil then
			npc:SetKeyValue("additionalequipment", table.Random(MinionSelection.Weapons))
		end
		npc:Spawn()		
		npc:Activate()
		table.insert(tblDataTable.Npcs, npc)
	end

	CIVRP_Register_Settlement(tblDataTable)
end