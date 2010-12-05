ENCRYPTION = nil
ENVIORMENT_LOADED = false

CIVRP_Enviorment_Data = {}
CIVRP_Chunk_Data = {}

function GM:Initialize( )
	--[[if file.Exists("CIVRP/CURRENT_FOREST.txt") then
		local contents = file.Read("CIVRP/CURRENT_FOREST.txt")
		CIVRP_Enviorment_Data_Temp = util.TableToKeyValues(contents)
	end]]
end

function CIVRP_EncryptionCode(umsg)
	local info = umsg:ReadString()
	ENCRYPTION = info
end
usermessage.Hook('CIVRP_EncryptionCode', CIVRP_EncryptionCode)

function CIVRP_CreateSVCLObject(umsg)
	local vector = umsg:ReadVector()
	local angle = umsg:ReadAngle()
	local model = umsg:ReadLong()
	local intX = math.floor(vector.x / CIVRP_CHUNKSIZE)
	local intY = math.floor(vector.y / CIVRP_CHUNKSIZE)
	CIVRP_Enviorment_Data[intX] = CIVRP_Enviorment_Data[intX] or {}
	CIVRP_Enviorment_Data[intX][intY] = CIVRP_Enviorment_Data[intX][intY] or {}
	CIVRP_Chunk_Data[intX] = CIVRP_Chunk_Data[intX] or {}
	CIVRP_Chunk_Data[intX][intY] = CIVRP_Chunk_Data[intX][intY] or {}
	CIVRP_Chunk_Data[intX][intY].Spawned = false
	table.insert(CIVRP_Enviorment_Data[intX][intY], {Vector = vector, Model = CIVRP_Enviorment_Models[model], Angle = angle})
	if !ENVIORMENT_LOADED then
		ENVIORMENT_LOADED = true
	end
end
usermessage.Hook('CIVRP_CreateSVCLObject',CIVRP_CreateSVCLObject)

local entCount = 0
function CIVRP_UpdateEnviorment(umsg)
	local model = umsg:ReadLong()
	local info = umsg:ReadString()
	local exploded = string.Explode("'",info)
	table.remove(exploded,1)
	for num,str in pairs(exploded) do
		if str != nil then
			
			local expstring = string.Explode("/", str)
			local exppstring = string.Explode(",", expstring[1])
			local vect1str = string.ToTable(exppstring[1])
			local vect2str = string.ToTable(exppstring[2])
			local vect1sign = vect1str[1]

			if vect1str[1] == "-" then
				table.remove(vect1str,1)
			else
				vect1sign = ""
			end
			local vect1abs = ""
			for i = 1, table.Count(vect1str) do
				vect1abs = vect1abs..tostring(vect1str[i])
			end
			local vect2sign = vect2str[1]
			if vect2str[1] == "-" then
				table.remove(vect2str,1)
			else
				vect2sign = ""
			end
			local vect2abs = ""
			for i = 1, table.Count(vect2str) do
				if vect2str[i] != nil then
					vect2abs = vect2abs..tostring(vect2str[i])
				end
			end
			local vecPos = Vector(tonumber(vect1sign..DecompressInteger(vect1abs)), tonumber(vect2sign..DecompressInteger(vect2abs)), 128)
			
			local intSX = math.floor(vecPos.x / CIVRP_SUPERCHUNKSIZE)
			local intSY = math.floor(vecPos.y / CIVRP_SUPERCHUNKSIZE)
			local intX = math.floor(vecPos.x / CIVRP_CHUNKSIZE)
			local intY = math.floor(vecPos.y / CIVRP_CHUNKSIZE)
			
			CIVRP_Enviorment_Data[intSX] = CIVRP_Enviorment_Data[intSX] or {}
			CIVRP_Enviorment_Data[intSX][intSY] = CIVRP_Enviorment_Data[intSX][intSY] or {}
			CIVRP_Enviorment_Data[intSX][intSY][intX] = CIVRP_Enviorment_Data[intSX][intSY][intX] or {}
			CIVRP_Enviorment_Data[intSX][intSY][intX][intY] = CIVRP_Enviorment_Data[intSX][intSY][intX][intY] or {}
			
			CIVRP_Chunk_Data[intSX] = CIVRP_Chunk_Data[intSX] or {}
			CIVRP_Chunk_Data[intSX][intSY] = CIVRP_Chunk_Data[intSX][intSY] or {}
			CIVRP_Chunk_Data[intSX][intSY][intX] = CIVRP_Chunk_Data[intSX][intSY][intX] or {}
			CIVRP_Chunk_Data[intSX][intSY][intX][intY] = CIVRP_Chunk_Data[intSX][intSY][intX][intY] or {}
			CIVRP_Chunk_Data[intSX][intSY][intX][intY].Spawned = false

			table.insert(CIVRP_Enviorment_Data[intSX][intSY][intX][intY], {Vector = vecPos, Model = CIVRP_Enviorment_Models[model], Angle = Angle(0, tonumber(DecompressInteger(expstring[2])), 0)})
			entCount = entCount + 1
		end
	end
	if entCount >= CIVRP_ENVIORMENTSIZE and !ENVIORMENT_LOADED then
		ENVIORMENT_LOADED = true
	end
end
usermessage.Hook('CIVRP_UpdateEnviorment', CIVRP_UpdateEnviorment)

local vecPlyPos
local intHalfSuperChunk
local intHalfChunk
local vecChunkPos = Vector(0, 0, 0)
local intDistance
local clientProps = 0

function GM:Think()
	if !ENVIORMENT_LOADED then return end
	vecPlyPos = LocalPlayer():GetPos()
	intHalfSuperChunk = intHalfSuperChunk or math.sqrt(math.pow(CIVRP_SUPERCHUNKSIZE, 2) * 2)
	intHalfChunk = intHalfChunk or math.sqrt(math.pow(CIVRP_CHUNKSIZE, 2) * 2)
	for sx, ysTable in pairs(CIVRP_Enviorment_Data) do
		if math.abs(((sx * CIVRP_SUPERCHUNKSIZE) + intHalfSuperChunk) - vecPlyPos.x) <= CIVRP_SOLIDDISTANCE + intHalfSuperChunk then
			for sy, xsTable in pairs(ysTable) do
				if math.abs(((sy * CIVRP_SUPERCHUNKSIZE) + intHalfSuperChunk) - vecPlyPos.y) <= CIVRP_SOLIDDISTANCE + intHalfSuperChunk then
					for x, yTable in pairs(xsTable) do
						if math.abs(((x * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.x) <= CIVRP_SOLIDDISTANCE + intHalfChunk then
							for y, dataTable in pairs(yTable) do
								if math.abs(((y * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.y) <= CIVRP_SOLIDDISTANCE + intHalfChunk then
									for _, data in pairs(dataTable) do
										if data.NextThink == nil || data.NextThink <= CurTime() then
											if data.Model.Solid then
												if data.NextThink != nil && data.NextThink <= CurTime()  then
													--print("Waited")
												end
												intDistance = vecPlyPos:Distance(data.Vector)
												if intDistance <= CIVRP_FADEDISTANCE then
													if data.entity != nil then
														--data.entity:SetColor(255, 255, 255, math.Clamp((CIVRP_FADEDISTANCE - intDistance) / 2, 0, 255))
														if intDistance < CIVRP_SOLIDDISTANCE then
															if !data.entity.DONE then
																--data.entity:SetNoDraw(true)
																RunConsoleCommand("CIVRP_EnableProp", data.Model.ID, tostring("/"..data.Vector.x.."/"..data.Vector.y.."/"..data.Vector.z),tostring("/"..data.Angle.p.."/"..data.Angle.y.."/"..data.Angle.r),tostring(ENCRYPTION))
																data.entity.DONE = true
															end
														else
															if data.entity.DONE then
																data.entity:SetNoDraw(false)
																data.entity.DONE = false
															end
														end
													end
												end
												data.NextThink = nil
												if intDistance <= CIVRP_FADEDISTANCE * (2/3) && intDistance > CIVRP_FADEDISTANCE * (1/3)  then
													data.NextThink = CurTime() + 3
													--print("Waiting")
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


local boolSpawned = false
local intTimerInc = 0
function AddRemoveModelsECKTY()
	timer.Simple(1, function()  AddRemoveModelsECKTY() end)
	if !ENVIORMENT_LOADED then return end
	vecPlyPos = LocalPlayer():GetPos()
	intHalfSuperChunk = intHalfSuperChunk or math.sqrt(math.pow(CIVRP_SUPERCHUNKSIZE, 2) * 2)
	intHalfChunk = intHalfChunk or math.sqrt(math.pow(CIVRP_CHUNKSIZE, 2) * 2)
	for sx, ysTable in pairs(CIVRP_Enviorment_Data) do
		--if math.abs(((sx * CIVRP_SUPERCHUNKSIZE) + intHalfSuperChunk) - vecPlyPos.x) <= CIVRP_FADEDISTANCE + intHalfSuperChunk then
			for sy, xsTable in pairs(ysTable) do
				--if math.abs(((sy * CIVRP_SUPERCHUNKSIZE) + intHalfSuperChunk) - vecPlyPos.y) <= CIVRP_FADEDISTANCE + intHalfSuperChunk then
					for x, yTable in pairs(xsTable) do
						for y, dataTable in pairs(yTable) do
							vecChunkPos = Vector(((x * CIVRP_CHUNKSIZE) + intHalfChunk), ((y * CIVRP_CHUNKSIZE) + intHalfChunk), 0)
							intDistance = vecPlyPos:Distance(vecChunkPos)
							boolSpawned = CIVRP_Chunk_Data[sx][sy][x][y].Spawned
							if intDistance <= CIVRP_FADEDISTANCE + intHalfChunk && !boolSpawned then
								intTimerInc = 0
								for _, data in pairs(dataTable) do
									if data.entity == nil && clientProps < 2000 then
										timer.Simple(0.1 * intTimerInc, function()
											--This is a little cheeper then using prop_physics
											local entity = ClientsideModel(data.Model.Model, RENDERGROUP_OPAQUE)
											entity:SetPos(data.Vector)
											entity:SetAngles(data.Angle)
											entity:Spawn()
											--entity:SetNoDraw(true)
											data.entity = entity
										end)
										clientProps = clientProps + 1
										intTimerInc = intTimerInc + 1
									end
									CIVRP_Chunk_Data[sx][sy][x][y].Spawned = true
								end
							elseif intDistance > CIVRP_FADEDISTANCE + intHalfChunk && boolSpawned then
								for _, data in pairs(dataTable) do
									if data.entity != nil then
										data.entity:Remove()
										data.entity = nil
										clientProps = clientProps - 1
									end
								end
								CIVRP_Chunk_Data[sx][sy][x][y].Spawned = false
							end
						end
					end
				--end
			end
		--end
	end
	
	--print(clientProps)
	--[[
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		if math.abs(((x * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.x) <= CIVRP_FADEDISTANCE + intHalfChunk then
			for y, dataTable in pairs(yTable) do
				if math.abs(((y * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.y) <= CIVRP_FADEDISTANCE + intHalfChunk then
					for _, data in pairs(dataTable) do
						intDistance = vecPlyPos:Distance(data.Vector)
						if intDistance <= CIVRP_FADEDISTANCE then
							if data.entity == nil && clientProps < 2000 then
								--This is a little cheeper then using prop_physics
								local entity = ClientsideModel(data.Model.Model, RENDERGROUP_OPAQUE)
								entity:SetPos(data.Vector)
								entity:SetAngles(data.Angle)
								entity:Spawn()
								data.entity = entity
								clientProps = clientProps + 1
							end
						elseif intDistance > CIVRP_FADEDISTANCE and data.entity != nil then
							data.entity:Remove()
							data.entity = nil
							clientProps = clientProps - 1
						end
					end
				end
			end
		end
	end
	]]
end
AddRemoveModelsECKTY()

	--[[
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		vecChunkPos.x = ((x * CIVRP_CHUNKSIZE) + intHalfChunk)
		if math.abs(vecChunkPos.x - vecPlyPos.x) <= CIVRP_FADEDISTANCE + intHalfChunk then
			for y, dataTable in pairs(yTable) do
				vecChunkPos.y = ((y * CIVRP_CHUNKSIZE) + intHalfChunk)
				if math.abs(vecChunkPos.y - vecPlyPos.y) <= CIVRP_FADEDISTANCE + intHalfChunk then
					intDistance = vecPlyPos:Distance(vecChunkPos)
					if intDistance <= CIVRP_FADEDISTANCE + intHalfChunk and CIVRP_Chunk_Data[x][y].Spawned == false then
						for _, data in pairs(dataTable) do
							if data.entity == nil && clientProps < 2000 then
								--This is a little cheeper then using prop_physics
								local entity = ClientsideModel(data.Model.Model, RENDERGROUP_OPAQUE)
								entity:SetPos(data.Vector)
								entity:SetAngles(data.Angle)
								entity:Spawn()
								data.entity = entity
								clientProps = clientProps + 1
							end
						end
						print("shitsspawning " .. x .. " " .. y)
						CIVRP_Chunk_Data[x][y].Spawned = true
					end
				elseif  math.abs(vecChunkPos.y - vecPlyPos.y) < CIVRP_FADEDISTANCE + intHalfChunk then
					if CIVRP_Chunk_Data[x][y].Spawned then
						for _, data in pairs(dataTable) do
							if data.entity != nil then
								data.entity:Remove()
								data.entity = nil
								clientProps = clientProps - 1
							end
						end
						CIVRP_Chunk_Data[x][y].Spawned = false
					end
				end
			end
		else
			for y, dataTable in pairs(yTable) do
				if CIVRP_Chunk_Data[x][y].Spawned then
					for _, data in pairs(dataTable) do
						if data.entity != nil then
							data.entity:Remove()
							data.entity = nil
							clientProps = clientProps - 1
						end
					end
					CIVRP_Chunk_Data[x][y].Spawned = false
				end
			end
			
		end
	end
	]]
	--PrintTable(CIVRP_Chunk_Data)
	--print("-----------")