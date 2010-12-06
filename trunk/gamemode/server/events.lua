function CIVRP_CreateEvent()
	local ply = table.Random(player.GetAll())
	local tbl = {}
	for _, data in pairs(CIVRP_Events) do
		if data.Condition(ply) then
			table.insert(tbl, _)
		end
	end
	if table.Count(tbl) >= 1 then
		CIVRP_Events[table.Random(tbl)].Function(ply)
		--CIVRP_Events["Ambush"].Function(ply)
	end
	local delay = math.Round(math.random(55, 65) * GetPlayerFactor())
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
	if (ent:GetClass() == "prop_physics" && ent.DamageAllowed)
		if (ent:Health() && ent:Health() >= 0) then
			ent:SetHealth(ent:Health() - 20)
		else
			if (ent.DropItems) then
				for _,v in pairs(ent.DropItems) do
					local NewObj = nil
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
			ent:Remove()
		end
	end
 end
