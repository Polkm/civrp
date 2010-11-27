ENCRYPTION = nil

CIVRP_Enviorment_Data = {}

CIVRP_FADEDISTANCE = 2000


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

function GM:Think()
	for _,data in pairs(CIVRP_Enviorment_Data) do
		if LocalPlayer():GetPos():Distance(data.Vector) < CIVRP_FADEDISTANCE && !data.InUse then
			local entity = ents.Create("prop_physics") 
			entity:SetPos(data.Vector)
			entity:SetModel(CIVRP_Foilage_Models[data.Model])
			entity:SetAngles(data.Angle)
			entity:Spawn()
			entity.Think = function() 
								if LocalPlayer():GetPos():Distance(data.Vector) < CIVRP_SOLIDDISTANCE then
									entity:SetNoDraw(true)
									if !entity.DONE && data.Model < 11 then
										RunConsoleCommand("CIVRP_EnableProp",data.Model,tostring("/"..data.Vector.x.."/"..data.Vector.y.."/"..data.Vector.z),tostring("/"..data.Angle.p.."/"..data.Angle.y.."/"..data.Angle.r),tostring(ENCRYPTION))
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
								timer.Simple(1,function() if entity:IsValid() then entity.Think() end end)
							end
			timer.Simple(1,function() if entity:IsValid() then entity.Think() end end)
			data.InUse = true
		end
	end
end