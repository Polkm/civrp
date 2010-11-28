ENCRYPTION = nil
ENVIORMENT_LOADED = false

CIVRP_Enviorment_Data = {}
CIVRP_Chunk_Data = {}

function CIVRP_EncryptionCode(umsg)
	local info = umsg:ReadString()
	ENCRYPTION = info
end
usermessage.Hook('CIVRP_EncryptionCode', CIVRP_EncryptionCode)

local entCount = 0
function CIVRP_UpdateEnviorment(umsg)
	local model = umsg:ReadLong()
	local info = umsg:ReadString()
	local exploded = string.Explode("|",info)
	table.remove(exploded, 1)
	for num,str in pairs(exploded) do
		if str != nil then
			local expstring = string.Explode("/", str)
			local exppstring = string.Explode(",", expstring[1])
			local vecPos = Vector(tonumber(exppstring[1]), tonumber(exppstring[2]), 128)
			local intX = math.floor(vecPos.x / CIVRP_CHUNKSIZE)
			local intY = math.floor(vecPos.y / CIVRP_CHUNKSIZE)
			CIVRP_Enviorment_Data[intX] = CIVRP_Enviorment_Data[intX] or {}
			CIVRP_Enviorment_Data[intX][intY] = CIVRP_Enviorment_Data[intX][intY] or {}
			CIVRP_Chunk_Data[intX] = CIVRP_Chunk_Data[intX] or {}
			CIVRP_Chunk_Data[intX][intY] = CIVRP_Chunk_Data[intX][intY] or {}
			CIVRP_Chunk_Data[intX][intY].Spawned = false
			table.insert(CIVRP_Enviorment_Data[intX][intY], {Vector = vecPos, Model = CIVRP_Enviorment_Models[model], Angle = Angle(0, tonumber(expstring[2]), 0)})
			entCount = entCount + 1
		end
	end
	if entCount >= CIVRP_ENVIORMENTSIZE and !ENVIORMENT_LOADED then
		ENVIORMENT_LOADED = true
		print("-------ENVIORMENT LOADED-------")
	end
end
usermessage.Hook('CIVRP_UpdateEnviorment', CIVRP_UpdateEnviorment)

local vecPlyPos
local intHalfChunk
local vecChunkPos = Vector(0, 0, 0)
local intDistance
local clientProps = 0
function GM:Think()
	if !ENVIORMENT_LOADED then return end
	
	vecPlyPos = LocalPlayer():GetPos()
	intHalfChunk = (CIVRP_CHUNKSIZE / 2)
	
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		if math.abs(((x * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.x) <= CIVRP_SOLIDDISTANCE + intHalfChunk then
			for y, dataTable in pairs(yTable) do
				if math.abs(((y * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.y) <= CIVRP_SOLIDDISTANCE + intHalfChunk then
					for _, data in pairs(dataTable) do
						intDistance = vecPlyPos:Distance(data.Vector)
						if intDistance <= CIVRP_FADEDISTANCE then
							if data.entity != nil then
								--data.entity:SetColor(255, 255, 255, math.Clamp((CIVRP_FADEDISTANCE - intDistance) / 2, 0, 255))
								if intDistance < CIVRP_SOLIDDISTANCE && data.Model.Solid then
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
					end
				end
			end
		end
	end
	
	
end

local boolSpawned = false
function AddRemoveModelsECKTY()
	timer.Simple(1, function()  AddRemoveModelsECKTY() end)
	if !ENVIORMENT_LOADED then return end
	
	vecPlyPos = LocalPlayer():GetPos()
	intHalfChunk = (CIVRP_CHUNKSIZE / 2)
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		for y, dataTable in pairs(yTable) do
			vecChunkPos = Vector(((x * CIVRP_CHUNKSIZE) + intHalfChunk), ((y * CIVRP_CHUNKSIZE) + intHalfChunk), 0)
			intDistance = vecPlyPos:Distance(vecChunkPos)
			boolSpawned = CIVRP_Chunk_Data[x][y].Spawned
			if intDistance <= CIVRP_FADEDISTANCE + intHalfChunk && !boolSpawned then
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
					CIVRP_Chunk_Data[x][y].Spawned = true
				end
			elseif intDistance > CIVRP_FADEDISTANCE + intHalfChunk && boolSpawned then
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