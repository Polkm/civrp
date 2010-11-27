ENCRYPTION = nil

CIVRP_Enviorment_Data = {}


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
			
			table.insert(CIVRP_Enviorment_Data,{Vector = Vector(exppstring[1],exppstring[2],128),Model = model,Angle = Angle(0,expstring[2],0)})
		end
	end
end
usermessage.Hook('CIVRP_UpdateEnviorment', CIVRP_UpdateEnviorment)

function GM:Tick()
	--Make sure not to get this more then you need to
	local vecPlyPos = LocalPlayer():GetPos()
	for _, data in pairs(CIVRP_Enviorment_Data) do
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
		elseif intDistance > CIVRP_FADEDISTANCE and data.entity != nil then
			data.entity:Remove()
			data.entity = nil
		end
	end
end