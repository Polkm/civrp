ENCRYPTION = nil

CIVRP_Enviorment_Data = {}

function CIVRP_EncryptionCode(umsg)
	local info = umsg:ReadString()
	ENCRYPTION = info
end
usermessage.Hook('CIVRP_EncryptionCode', CIVRP_EncryptionCode)

function CIVRP_UpdateEnviorment(umsg)
	local model = umsg:ReadLong()
	local info = umsg:ReadString()
	local exploded = string.Explode("|",info)
	table.remove(exploded,1)
	for num,str in pairs(exploded) do
		if str != nil then
			local expstring = string.Explode("/", str)
			local exppstring = string.Explode(",", expstring[1])
			local vecPos = Vector(tonumber(exppstring[1]), tonumber(exppstring[2]), 128)
			local intX = math.floor(vecPos.x / CIVRP_CHUNKSIZE)
			local intY = math.floor(vecPos.y / CIVRP_CHUNKSIZE)
			CIVRP_Enviorment_Data[intX] = CIVRP_Enviorment_Data[intX] or {}
			CIVRP_Enviorment_Data[intX][intY] = CIVRP_Enviorment_Data[intX][intY] or {}
			table.insert(CIVRP_Enviorment_Data[intX][intY], {Vector = vecPos, Model = model, Angle = Angle(0, tonumber(expstring[2]), 0)})
		end
	end
end
usermessage.Hook('CIVRP_UpdateEnviorment', CIVRP_UpdateEnviorment)

local vecPlyPos
local intHalfChunk
local intDistance
local clientProps = 0
function GM:Think()
	vecPlyPos = LocalPlayer():GetPos()
	intHalfChunk = (CIVRP_CHUNKSIZE / 2)
	for x, yTable in pairs(CIVRP_Enviorment_Data) do
		if math.abs(((x * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.x) <= CIVRP_FADEDISTANCE + intHalfChunk then
			for y, dataTable in pairs(yTable) do
				if math.abs(((y * CIVRP_CHUNKSIZE) + intHalfChunk) - vecPlyPos.y) <= CIVRP_FADEDISTANCE + intHalfChunk then
					for _, data in pairs(dataTable) do
						intDistance = vecPlyPos:Distance(data.Vector)
						
						if intDistance <= CIVRP_FADEDISTANCE then
							
							if data.entity == nil && clientProps < 2000 then
								--This is a little cheeper then using prop_physics
								local entity = ClientsideModel(CIVRP_Foilage_Models[data.Model], RENDERGROUP_OPAQUE)
								entity:SetPos(data.Vector)
								entity:SetAngles(data.Angle)
								entity:Spawn()
								data.entity = entity
								clientProps = clientProps + 1
							end
							
							if data.entity != nil then
								data.entity:SetColor(255, 255, 255, math.Clamp((CIVRP_FADEDISTANCE - intDistance) / 2, 0, 255))
								
								if intDistance < CIVRP_SOLIDDISTANCE && data.Model < 11 then
									--data.entity:SetNoDraw(true)
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
	--print(clientProps)
end