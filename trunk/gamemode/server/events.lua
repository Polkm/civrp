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
