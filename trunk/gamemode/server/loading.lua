CIVRP_Enviorment_Data = {}

for i = 1,2000 do 
	table.insert(CIVRP_Enviorment_Data,{Vector = Vector(math.random(-10000,10000),math.random(-10000,10000),128),Model = math.random(1,table.Count(CIVRP_Foilage_Models)),Angle = Angle(0,math.random(0,360),0)})
end



function CIVRP_SendData(ply) 
	local tbl = {}
	for _,data in pairs(CIVRP_Enviorment_Data) do 
		if tbl[data.Model] == nil then
			tbl[data.Model] = {}
		end
		table.insert(tbl[data.Model],{Vector = data.Vector,Angle = data.Angle})
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
					umsg.Long( mdl )
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
						umsg.Long( mdl )
						umsg.String(str)
					umsg.End()	
				end
				str = ""
				PrintTable(exploded)
				for k,v in pairs(exploded) do 
					str = string.Implode("|",{str,v})
				end
				umsg.Start("CIVRP_UpdateEnviorment", self)
					umsg.Long( mdl )
					umsg.String(str)
				umsg.End()	
				str = ""
			end
	end
	
end

function GM:PlayerInitialSpawn(ply)
	CIVRP_SendData(ply)
end

function GM:Think() 
	for _,ply in pairs(player.GetAll()) do
		for _,data in pairs(CIVRP_Enviorment_Data) do
			if ply:GetPos():Distance(data.Vector) < CIVRP_SOLIDDISTANCE && !data.InUse then
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