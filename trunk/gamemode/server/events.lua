function CIVRP_CreateEvent()
	if (player.GetAll() == nil || table.Count(player.GetAll()) <= 0) then 
		timer.Simple(10, function() CIVRP_CreateEvent() end)
		return
	end
	local ply = table.Random(player.GetAll())
	local tbl = {}
	for _, data in pairs(CIVRP_Events) do
		if data.Condition(ply) then
			local intChance = data.Chance or 100
			intChance = 100 / math.Clamp(intChance, 0, 100)
			if math.random(1, (intChance or 100)) == 1 then
				table.insert(tbl, _)
			end
		end
	end
	if table.Count(tbl) >= 1 then
		local randomtbl = table.Random(tbl)
		CIVRP_Events[randomtbl].Function(ply)
		if (SinglePlayer()) then
			ply:ChatPrint(tostring(randomtbl) .. " Has spawned near you!")
		end
		--CIVRP_Events["Ambush"].Function(ply)
	else
		timer.Simple(1, function() CIVRP_CreateEvent() end)
	end
	local delay = 0
	if (SinglePlayer()) then
		delay = 20
	else
		delay = math.Round(math.random(35, 45) * GetPlayerFactor())
	end
	print(delay)
	timer.Simple(delay, function() CIVRP_CreateEvent() end)
end

hook.Add("Initialize", "initializing_threat_systems", function()
--	if CIVRP_DIFFICULTY != "Peacefull" then --No baddies for peace lovers
		timer.Simple(10, function() CIVRP_CreateEvent() end)
	--end
end)

CIVRP_Events = {}

function GM:EntityTakeDamage( ent, inflictor, attacker, amount )
	if (ent.DamageAllowed && attcker:IsPlayer()) then
		if (ent:Health() && ent:Health() >= 0) then
			local tblWeaponData = attacker.ItemData[self:GetOwner().ItemData["SELECTED"]] or "empty"
			if (tblWeaponData != "empty" && tblWeaponData.WEAPONDATA.Damage > 0)then
				ent:SetHealth(ent:Health() - tblWeaponData.WEAPONDATA.Damage)
			else
				ent:SetHealth(ent:Health() - 20)
			end
		else
			if (ent.DropItems) then
				for _,v in pairs(ent.DropItems) do
					local NewObj = nil
					for i = 1, (v.Amount or 1) do
						if (v.ItemClass) then
							local Item = CIVRP_Item_Data[v.ItemClass]
							NewObj = CreateCustomProp(Item.Model, true, false)
							NewObj.ItemClass = v.ItemClass
						else
							NewObj = CreateCustomProp(v.Model, true, false)
						end
						if (ValidEntity(NewObj)) then
							NewObj:SetPos(ent:GetPos() + (v.Offset or Vector(0, 0, 30)))
							NewObj:SetVelocity(Vector(math.random(0, 100), math.random(0, 100) ,math.random(0, 100)))
							timer.Simple(30, function() -- Used to clean up prop if it still valid
								if (ValidEntity(NewObj)) then
									NewObj:Remove()
								end
							end)
						end
					end
				end
			end
			ent:Remove()
		end
	end
 end
