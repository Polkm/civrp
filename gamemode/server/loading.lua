CIVRP_Enviorment_Data = {}
CIVRP_Enviorment_Data_Quad1 = {}
CIVRP_Enviorment_Data_Quad2 = {}
CIVRP_Enviorment_Data_Quad3 = {}
CIVRP_Enviorment_Data_Quad4 = {}

for i = 1, CIVRP_ENVIORMENTSIZE do 
	local vx = math.random(-15600, 15600)
	local vy = math.random(-15600, 15600)
	local ay = math.random(0, 360)
	local tbl = {}
	for num,data in pairs(CIVRP_Enviorment_Models) do
		if data.Generated then
			table.insert(tbl,num)
		end
	end
	local mdl = math.random(1, table.Count(tbl))
	
	--This is the code it would take to convert this sytem to a grided system
	--[[
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
	]]
	table.insert(CIVRP_Enviorment_Data, {Vector = Vector(vx, vy, 128), Model = mdl, Angle = Angle(0, ay, 0)})
	if vx >= 0 && vy  >= 0 then
		table.insert(CIVRP_Enviorment_Data_Quad1,{Vector = Vector(vx,vy,128),Model = mdl,Angle = Angle(0,ay,0)})
	elseif vx < 0 && vy  >= 0 then
		table.insert(CIVRP_Enviorment_Data_Quad2,{Vector = Vector(vx,vy,128),Model = mdl,Angle = Angle(0,ay,0)})
	elseif vx < 0 && vy  < 0 then
		table.insert(CIVRP_Enviorment_Data_Quad3,{Vector = Vector(vx,vy,128),Model = mdl,Angle = Angle(0,ay,0)})
	elseif vx >= 0 && vy  < 0 then
		table.insert(CIVRP_Enviorment_Data_Quad4,{Vector = Vector(vx,vy,128),Model = mdl,Angle = Angle(0,ay,0)})
	end
end

local ENCRYPTIONTBL = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"}

ENCRYPTION = string.Implode("",{table.Random(ENCRYPTIONTBL),table.Random(ENCRYPTIONTBL),table.Random(ENCRYPTIONTBL),table.Random(ENCRYPTIONTBL)})

local LOADING_QUENED_DATA = {}

function CIVRP_SendData(ply) 
	local tbl = {}
	for _, data in pairs(CIVRP_Enviorment_Data) do 
		if tbl[tostring(data.Model)] == nil then
			tbl[tostring(data.Model)] = {}
		end
		table.insert(tbl[tostring(data.Model)],{Vector = data.Vector,Angle = data.Angle})
	end
	local timerz = 0
	local str = ""
	local number = 0
	local exploded = nil
	local vect1 = ""
	local vect2 = ""
	for mdl,dt in pairs(tbl) do
		for _,data in pairs(dt) do
			if data.Vector.x < 0 then
				vect1 = "-"..CompressInteger(math.abs(data.Vector.x))
			else
				vect1 = CompressInteger(math.abs(data.Vector.x))
			end
			if data.Vector.y < 0 then
				vect2 = "-"..CompressInteger(math.abs(data.Vector.y))
			else
				vect2 = CompressInteger(math.abs(data.Vector.y))
			end
			str = string.Implode("'",{str,vect1..","..vect2.."/"..CompressInteger(math.abs(data.Angle.y))})
			vect1 = nil
			vect2 = nil
		end
		exploded = string.Explode("'",str)
		table.remove(exploded,1)
		if table.Count(exploded) <= 18 then
			--timer.Simple(
			umsg.Start("CIVRP_UpdateEnviorment", ply)
				umsg.Long( tonumber(mdl) )
				umsg.String(str)
			umsg.End()	
			--table.insert(LOADING_QUENED_DATA)
			str = ""
		else
			for i = 1,math.Round(table.Count(exploded)/18) do 
				str = string.Implode("'",{exploded[1],exploded[2],exploded[3],exploded[4],exploded[5],exploded[6],exploded[7],exploded[8],exploded[9],exploded[10],exploded[11],exploded[12],exploded[13],exploded[14],exploded[15],exploded[16],exploded[17],exploded[18],})
				str = "'"..str
				table.remove(exploded,18) table.remove(exploded,17) table.remove(exploded,16) table.remove(exploded,15) table.remove(exploded,14) table.remove(exploded,13)
				table.remove(exploded,12) table.remove(exploded,11) table.remove(exploded,10) table.remove(exploded,9) table.remove(exploded,8) table.remove(exploded,7) 
				table.remove(exploded,6) table.remove(exploded,5) table.remove(exploded,4) table.remove(exploded,3) table.remove(exploded,2) table.remove(exploded,1)
				umsg.Start("CIVRP_UpdateEnviorment", ply)
					umsg.Long( tonumber(mdl) )
					umsg.String(str)
				umsg.End()	
			end
			str = ""
			for k,v in pairs(exploded) do 
				str = string.Implode("'",{str,v})
			end
			if str != "" then
				umsg.Start("CIVRP_UpdateEnviorment", ply)
					umsg.Long( tonumber(mdl) )
					umsg.String(str)
				umsg.End()	
				str = ""
			end
		end
	end
	
end

function CIVRP_CreateSVCLObject(vector,angle,model)	
	table.insert(CIVRP_Enviorment_Data, {Vector = vector, Model = model, Angle = angle})
	if vector.x >= 0 && vector.y  >= 0 then
		table.insert(CIVRP_Enviorment_Data_Quad1,{Vector = vector,Model = model,Angle = angle})
	elseif vector.x < 0 && vector.y  >= 0 then
		table.insert(CIVRP_Enviorment_Data_Quad2,{Vector = vector,Model = model,Angle = angle})
	elseif vector.x < 0 && vector.y  < 0 then
		table.insert(CIVRP_Enviorment_Data_Quad3,{Vector = vector,Model = model,Angle = angle})
	elseif vector.x >= 0 && vector.y  < 0 then
		table.insert(CIVRP_Enviorment_Data_Quad4,{Vector = vector,Model = model,Angle = angle})
	end
	for _,ply in pairs(player.GetAll()) do
		umsg.Start("CIVRP_CreateSVCLObject", ply)
			umsg.Vector(vector)
			umsg.Angle(angle)
			umsg.Long(model)
		umsg.End()	
	end
end

function CIVRP_SendEncryption(ply) 
	umsg.Start("CIVRP_EncryptionCode", self)
		umsg.String(ENCRYPTION)
	umsg.End()	
end

function GM:PlayerInitialSpawn(ply)
	timer.Simple(1, function() CIVRP_SendEncryption(ENCRYPTION) end)
	timer.Simple(1, function() CIVRP_SendData(ply) end)
	ply.ItemData = {}
	ply.ItemData["SELECTED"] = 1
	for i = 1, 10 do
		ply.ItemData[i] = {}
	end
end

function CIVRP_EnableProp(ply,Model,Vect,Ang,Encryption)
	local str = string.Explode("/",Ang)
	table.remove(str,1)
	local angle = Angle(tonumber(str[1]),tonumber(str[2]),tonumber(str[3]))
	str = string.Explode("/",Vect)
	table.remove(str,1)
	local vector = Vector(tonumber(str[1]),tonumber(str[2]),tonumber(str[3]))
	if Encryption != ENCRYPTION then return false end
	if ply:GetPos():Distance(vector) >= CIVRP_SOLIDDISTANCE then return false end
		if vector.x >= 0 && vector.y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad1) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Enviorment_Models[data.Model].Model)
					entity:SetAngles(data.Angle)
					entity:Spawn()
					entity:Activate()
					entity:DrawShadow(false)
					if entity:GetPhysicsObject():IsValid() then
						entity:GetPhysicsObject():EnableMotion(false)
					end
					entity.Think = function() 
										if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
											entity:Remove()
											data.InUse = false
											return false
										end
										timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
									end
					timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
					data.InUse = true	
				end
			end
		elseif vector.x < 0 && vector.y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad2) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Enviorment_Models[data.Model].Model)
					entity:SetAngles(data.Angle)
					entity:Spawn()
					entity:Activate()
					entity:DrawShadow(false)
					if entity:GetPhysicsObject():IsValid() then
						entity:GetPhysicsObject():EnableMotion(false)
					end
					entity.Think = function() 
										if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
											entity:Remove()
											data.InUse = false
											return false
										end
										timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
									end
					timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
					data.InUse = true	
				end
			end		
		elseif vector.x < 0 && vector.y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad3) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Enviorment_Models[data.Model].Model)
					entity:SetAngles(data.Angle)
					entity:Spawn()
					entity:Activate()
					entity:DrawShadow(false)
					if entity:GetPhysicsObject():IsValid() then
						entity:GetPhysicsObject():EnableMotion(false)
					end
					entity.Think = function() 
										if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
											entity:Remove()
											data.InUse = false
											return false
										end
										timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
									end
					timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
					data.InUse = true	
				end
			end		
		elseif vector.x >= 0 && vector.y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad4) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Enviorment_Models[data.Model].Model)
					entity:SetAngles(data.Angle)
					entity:Spawn()
					entity:Activate()
					entity:DrawShadow(false)
					if entity:GetPhysicsObject():IsValid() then
						entity:GetPhysicsObject():EnableMotion(false)
					end
					entity.Think = function() 
										if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
											entity:Remove()
											data.InUse = false
											return false
										end
										timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
									end
					timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
					data.InUse = true	
				end
			end
		end	
end
concommand.Add("CIVRP_EnableProp",function(ply,cmd,args) CIVRP_EnableProp(ply,tonumber(args[1]),tostring(args[2]),tostring(args[3]),tostring(args[4])) end)

--[[
function GM:Think() 
	for _,ply in pairs(player.GetAll()) do
		if ply:GetPos().x >= 0 && ply:GetPos().y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad1) do
				if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
					CIVRP_Determine_Solid(ply,data)
					break
				end
			end
		elseif ply:GetPos().x < 0 && ply:GetPos().y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad2) do
				if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
					CIVRP_Determine_Solid(ply,data)
					break
				end
			end		
		elseif ply:GetPos().x < 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad3) do
				if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
					CIVRP_Determine_Solid(ply,data)
					break
				end
			end		
		elseif ply:GetPos().x >= 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad4) do
				if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then 
					CIVRP_Determine_Solid(ply,data)
					break
				end
			end
		end	
	end
end

function CIVRP_Determine_Solid(ply,data)
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Enviorment_Models[data.Model].Model)
					entity:SetAngles(data.Angle)
					entity:Spawn()
					entity:Activate()
					entity:DrawShadow(false)
					if entity:GetPhysicsObject():IsValid() then
						entity:GetPhysicsObject():EnableMotion(false)
					end
					entity.Think = function() 
										if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
											entity:Remove()
											data.InUse = false
											return false
										end
										timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
									end
					timer.Simple(5,function() if entity:IsValid() then entity.Think() end end)
					data.InUse = true	

end]]
--[[
local vecPlyPos
function GM:Tick()
	for _, ply in pairs(player.GetAll()) do
		vecPlyPos = ply:GetPos()
		for _, data in pairs(CIVRP_Enviorment_Data) do
			if vecPlyPos:Distance(data.Vector) <= CIVRP_SOLIDDISTANCE && !data.InUse then
				local entity = ents.Create("prop_physics") 
				entity:SetPos(data.Vector)
				entity:SetModel(CIVRP_Foilage_Models[data.Model])
				entity:SetAngles(data.Angle)
				entity:Spawn()
				entity:Activate()
				if entity:GetPhysicsObject():IsValid() then
					entity:GetPhysicsObject():EnableMotion(false)
				end
				entity.Think = function() 
									if ply:GetPos():Distance(data.Vector) >= CIVRP_SOLIDDISTANCE then
										entity:Remove()
										data.InUse = false
										return false
									end
									timer.Simple(0.5,function() if entity:IsValid() then entity.Think() end end)
								end
				timer.Simple(0.5,function() if entity:IsValid() then entity.Think() end end)
				data.InUse = true
			end
		end
	end
end
]]