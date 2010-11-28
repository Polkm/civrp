CIVRP_Enviorment_Data = {}
CIVRP_Enviorment_Data_Quad1 = {}
CIVRP_Enviorment_Data_Quad2 = {}
CIVRP_Enviorment_Data_Quad3 = {}
CIVRP_Enviorment_Data_Quad4 = {}

for i = 1, CIVRP_ENVIORMENTSIZE do 
	local vx = math.random(-10000, 10000)
	local vy = math.random(-10000, 10000)
	local ay = math.random(0, 360)
	local mdl = math.random(1, table.Count(CIVRP_Foilage_Models))
	
	--This is the code it would take to convert this sytem to a grided system
	--[[
	local vecPos = Vector(vx, vy, 128)
	local intX = math.floor(vecPos.x / CIVRP_CHUNKSIZE)
	local intY = math.floor(vecPos.y / CIVRP_CHUNKSIZE)
	CIVRP_Enviorment_Data[intX] = CIVRP_Enviorment_Data[intX] or {}
	CIVRP_Enviorment_Data[intX][intY] = CIVRP_Enviorment_Data[intX][intY] or {}
	table.insert(CIVRP_Enviorment_Data[intX][intY], {Vector = vecPos, Model = mdl, Angle = Angle(0, ay, 0)})
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
	for mdl,dt in pairs(tbl) do
			for _,data in pairs(dt) do
				str = string.Implode("|",{str,(data.Vector.x)..","..(data.Vector.y).."/"..(data.Angle.y)})
			end
			exploded = string.Explode("|",str)
			table.remove(exploded,1)
			if table.Count(exploded) <= 12 then
				umsg.Start("CIVRP_UpdateEnviorment", self)
					umsg.Long( tonumber(mdl) )
					umsg.String(str)
				umsg.End()	
				str = ""
			else
				for i = 1,math.Round(table.Count(exploded)/12) do 
					str = string.Implode("|",{exploded[1],exploded[2],exploded[3],exploded[4],exploded[5],exploded[6],exploded[7],exploded[8],exploded[9],exploded[10],exploded[11],exploded[12],})
					str = "|"..str
					table.remove(exploded,12) table.remove(exploded,11) table.remove(exploded,10) table.remove(exploded,9) table.remove(exploded,8) table.remove(exploded,7) 
					table.remove(exploded,6) table.remove(exploded,5) table.remove(exploded,4) table.remove(exploded,3) table.remove(exploded,2) table.remove(exploded,1)
					umsg.Start("CIVRP_UpdateEnviorment", self)
						umsg.Long( tonumber(mdl) )
						umsg.String(str)
					umsg.End()	
				end
				str = ""
				PrintTable(exploded)
				for k,v in pairs(exploded) do 
					str = string.Implode("|",{str,v})
				end
				umsg.Start("CIVRP_UpdateEnviorment", self)
					umsg.Long( tonumber(mdl) )
					umsg.String(str)
				umsg.End()	
				str = ""
			end
	end
	
end

function CIVRP_SendEncryption(ply) 
	umsg.Start("CIVRP_EncryptionCode", self)
		umsg.String(ENCRYPTION)
	umsg.End()	
end

function GM:PlayerInitialSpawn(ply)
	timer.Simple(1,function() CIVRP_SendEncryption(ENCRYPTION) end )
	timer.Simple(1,function() CIVRP_SendData(ply) end )
	--timer.Simple(1, function() datastream.StreamToClients({ply}, "CIVRP_Enviorment", {CIVRP_Enviorment_Data}) end)
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
		if ply:GetPos().x >= 0 && ply:GetPos().y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad1) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Foilage_Models[data.Model])
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
		elseif ply:GetPos().x < 0 && ply:GetPos().y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad2) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Foilage_Models[data.Model])
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
		elseif ply:GetPos().x < 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad3) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Foilage_Models[data.Model])
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
		elseif ply:GetPos().x >= 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad4) do
				if data.Vector == vector && Model == data.Model && data.Angle == angle && !data.InUse then
					local entity = ents.Create("prop_physics") 
					entity:SetPos(data.Vector)
					entity:SetModel(CIVRP_Foilage_Models[data.Model])
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
				CIVRP_Determine_Solid(ply,data)
			end
		elseif ply:GetPos().x < 0 && ply:GetPos().y >= 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad2) do
				CIVRP_Determine_Solid(ply,data)
			end		
		elseif ply:GetPos().x < 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad3) do
				CIVRP_Determine_Solid(ply,data)
			end		
		elseif ply:GetPos().x >= 0 && ply:GetPos().y < 0 then
			for _,data in pairs(CIVRP_Enviorment_Data_Quad4) do
				CIVRP_Determine_Solid(ply,data)
			end
		end	
	end
end

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