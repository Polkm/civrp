ENCRYPTION = nil

CIVRP_Enviorment_Data = {}
CIVRP_Enviorment_Data_Quad1 = {}
CIVRP_Enviorment_Data_Quad2 = {}
CIVRP_Enviorment_Data_Quad3 = {}
CIVRP_Enviorment_Data_Quad4 = {}


function CIVRP_EncryptionCode( umsg )
	local info = umsg:ReadString()
	ENCRYPTION = info
end
usermessage.Hook('CIVRP_EncryptionCode', CIVRP_EncryptionCode)

function CIVRP_UpdateEnviorment( umsg )
	local model = umsg:ReadLong()
	local info = umsg:ReadString()
	local exploded = string.Explode("|",info)
	table.remove(exploded,1)
	for num,str in pairs(exploded) do
		if str != nil then
			local expstring = string.Explode("/",str)
			local exppstring = string.Explode(",",expstring[1])
			local vecPos = Vector(tonumber(exppstring[1]), tonumber(exppstring[2]), 128)
			local intX = math.floor(vecPos.x / CIVRP_CHUNKSIZE)
			local intY = math.floor(vecPos.y / CIVRP_CHUNKSIZE)
			CIVRP_Enviorment_Data[intX] = CIVRP_Enviorment_Data[intX] or {}
			CIVRP_Enviorment_Data[intX][intY] = CIVRP_Enviorment_Data[intX][intY] or {}
			table.insert(CIVRP_Enviorment_Data[intX][intY], {Vector = vecPos, Model = model, Angle = Angle(0, tonumber(expstring[2]), 0)})
			--[[
			if tonumber(exppstring[1]) >= 0 && tonumber(exppstring[2])  >= 0 then
				table.insert(CIVRP_Enviorment_Data_Quad1,{Vector = Vector(tonumber(exppstring[1]),tonumber(exppstring[2]),128),Model = model,Angle = Angle(0,tonumber(expstring[2]),0)})
			elseif tonumber(exppstring[1]) < 0 && tonumber(exppstring[2])  >= 0 then
				table.insert(CIVRP_Enviorment_Data_Quad2,{Vector = Vector(tonumber(exppstring[1]),tonumber(exppstring[2]),128),Model = model,Angle = Angle(0,tonumber(expstring[2]),0)})
			elseif tonumber(exppstring[1]) < 0 && tonumber(exppstring[2])  < 0 then
				table.insert(CIVRP_Enviorment_Data_Quad3,{Vector = Vector(tonumber(exppstring[1]),tonumber(exppstring[2]),128),Model = model,Angle = Angle(0,tonumber(expstring[2]),0)})
			elseif tonumber(exppstring[1]) >= 0 && tonumber(exppstring[2])  < 0 then
				table.insert(CIVRP_Enviorment_Data_Quad4,{Vector = Vector(tonumber(exppstring[1]),tonumber(exppstring[2]),128),Model = model,Angle = Angle(0,tonumber(expstring[2]),0)})
			end
			]]
		end
	end
end
usermessage.Hook('CIVRP_UpdateEnviorment', CIVRP_UpdateEnviorment)

function GM:Tick()
	--[[
	if LocalPlayer():GetPos().x >= 0 && LocalPlayer():GetPos().y >= 0 then
		for _,data in pairs(CIVRP_Enviorment_Data_Quad1) do
			CIVRP_Determine_Solid(data)
		end
	elseif LocalPlayer():GetPos().x < 0 && LocalPlayer():GetPos().y >= 0 then
		for _,data in pairs(CIVRP_Enviorment_Data_Quad2) do
			CIVRP_Determine_Solid(data)
		end		
	elseif LocalPlayer():GetPos().x < 0 && LocalPlayer():GetPos().y < 0 then
		for _,data in pairs(CIVRP_Enviorment_Data_Quad3) do
			CIVRP_Determine_Solid(data)
		end		
	elseif LocalPlayer():GetPos().x >= 0 && LocalPlayer():GetPos().y < 0 then
		for _,data in pairs(CIVRP_Enviorment_Data_Quad4) do
			CIVRP_Determine_Solid(data)
		end
	end
	]]
	
	--Make sure not to get this more then you need to
	
	local vecPlyPos = LocalPlayer():GetPos()
	local intCount = 0
	--print(table.Count(CIVRP_Enviorment_Data))
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		if math.abs(((x * CIVRP_CHUNKSIZE) + (CIVRP_CHUNKSIZE / 2)) - vecPlyPos.x) <= CIVRP_FADEDISTANCE + (CIVRP_CHUNKSIZE / 2) then
			intCount = intCount + 1
			for y, dataTable in pairs(yTable) do
				if math.abs(((y * CIVRP_CHUNKSIZE) + (CIVRP_CHUNKSIZE / 2)) - vecPlyPos.y) <= CIVRP_FADEDISTANCE + (CIVRP_CHUNKSIZE / 2) then
					for _, data in pairs(dataTable) do
						local intDistance = vecPlyPos:Distance(data.Vector)
						if intDistance <= CIVRP_FADEDISTANCE then
							if data.entity == nil then
								--This is a little cheeper then using prop_physics
								local entity = ClientsideModel(CIVRP_Foilage_Models[data.Model], RENDERGROUP_OPAQUE)
								entity:SetPos(data.Vector)
								entity:SetAngles(data.Angle)
								entity:Spawn()
								data.entity = entity
							end
							data.entity:SetColor(255, 255, 255, math.Clamp((CIVRP_FADEDISTANCE - intDistance) / 2, 0, 255))
							
							if intDistance < CIVRP_SOLIDDISTANCE && data.Model < 11 then
								if !data.entity.DONE then
									RunConsoleCommand("CIVRP_EnableProp",data.Model,tostring("/"..data.Vector.x.."/"..data.Vector.y.."/"..data.Vector.z),tostring("/"..data.Angle.p.."/"..data.Angle.y.."/"..data.Angle.r),tostring(ENCRYPTION))
									data.entity.DONE = true
								end
							else
								if data.entity.DONE then
									data.entity:SetNoDraw(false)
									data.entity.DONE = false
								end
							end
							
						elseif intDistance > CIVRP_FADEDISTANCE and data.entity != nil then
							data.entity:Remove()
							data.entity = nil
						end
					end
				end
			end
		end
	end
	print(intCount)
	
end


--[[
function CIVRP_Determine_Solid(data)
	if LocalPlayer():GetPos():Distance(data.Vector) < CIVRP_FADEDISTANCE && !data.InUse then
		local entity = ClientsideModel(CIVRP_Foilage_Models[data.Model], RENDERGROUP_OPAQUE)
		entity:SetPos(data.Vector)
		entity:SetModel(CIVRP_Foilage_Models[data.Model])
		entity:SetAngles(data.Angle)
		entity:Spawn()
		entity.Think = function() 
							if LocalPlayer():GetPos():Distance(data.Vector) < CIVRP_SOLIDDISTANCE && data.Model < 11 then
								entity:SetNoDraw(true)
								if !entity.DONE then
								--	RunConsoleCommand("CIVRP_EnableProp",data.Model,tostring("/"..data.Vector.x.."/"..data.Vector.y.."/"..data.Vector.z),tostring("/"..data.Angle.p.."/"..data.Angle.y.."/"..data.Angle.r),tostring(ENCRYPTION))
									entity.DONE = true
								end
							else
								entity:SetNoDraw(false)
								entity.DONE = false
							end
							if LocalPlayer():GetPos():Distance(data.Vector) >= CIVRP_FADEDISTANCE then
								entity:Remove()
								data.InUse = false
								return false
							end
							timer.Simple(.5,function() if entity:IsValid() then entity.Think() end end)
						end
		timer.Simple(.5,function() if entity:IsValid() then entity.Think() end end)
		data.InUse = true
	end
end
]]