
CIVRP_Item_Data = {}
CIVRP_Item_Data["item_healthvial"] = {Class = "item_healthvial", Model = "models/healthvial.mdl"}
CIVRP_Item_Data["item_healthvial"].HoldPos = Vector(15, -15, 8)
CIVRP_Item_Data["item_healthvial"].HoldAngle = Angle(0, 0, 0)
CIVRP_Item_Data["item_healthvial"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_healthvial"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_healthvial"].FireFunction = function(plyUser, swepWeapon, tblItem)
	local worked = plyUser:RestoreHealth(20)
	if worked then plyUser:PlaySound("items/smallmedkit1.wav", 70) end
	return worked
end

CIVRP_Item_Data["item_metalprop"] = {Class = "item_metalprop", Model = "models/Gibs/Scanner_gib02.mdl"}
CIVRP_Item_Data["item_metalprop"].HoldPos = Vector(12, -5, 5)
CIVRP_Item_Data["item_metalprop"].HoldAngle = Angle(0, 180, 90)
CIVRP_Item_Data["item_metalprop"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_metalprop"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_metalprop"].FireFunction = function(plyUser, swepWeapon, tblItem)
	return false -- for later?
end

CIVRP_Item_Data["item_healthkit"] = {Class = "item_healthkit", Model = "models/Items/HealthKit.mdl"}
CIVRP_Item_Data["item_healthkit"].HoldPos = Vector(15, -4, 1) -- Forward,Up,Right
CIVRP_Item_Data["item_healthkit"].HoldAngle = Angle(90, 180, 0)
CIVRP_Item_Data["item_healthkit"].LerpDegree = .5 -- Percent
CIVRP_Item_Data["item_healthkit"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_healthkit"].FireFunction = function(plyUser, swepWeapon, tblItem)
	local worked = plyUser:RestoreHealth(20)
	if worked then plyUser:PlaySound("items/smallmedkit1.wav", 70) end
	return worked
end
--[[Example
CIVRP_Item_Data["item_healthkit"].SpawnFunction  = function(self)-- Self is the swep
	local entity = ents.Create("prop_physics")
	entity:SetModel(self:GetOwner().ItemData.Model)
	entity.ItemClass = self:GetOwner().ItemData.Class
	entity:SetAngles(Angle(-90,self:GetOwner():GetAngles().y,self:GetOwner():GetAngles().r))
	entity:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAngles():Forward() * self:GetOwner().ItemData.HoldPos.x + self:GetOwner():GetAngles():Up() * self:GetOwner().ItemData.HoldPos.y + self:GetOwner():GetAngles():Right() * self:GetOwner().ItemData.HoldPos.z )
	entity:Spawn()
	entity:Activate()
	entity:SetOwner(nil)
	entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if entity:GetPhysicsObject():IsValid() then
		entity:GetPhysicsObject():Wake()
		entity:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
		entity:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetAngles():Forward() *(entity:GetPhysicsObject():GetMass() * 100))
	end
	return entity
end]]

CIVRP_Item_Data["item_ammo_pistol"] = {Class = "item_ammo_pistol", Model = "models/items/boxsrounds.mdl"}
CIVRP_Item_Data["item_ammo_pistol"].HoldPos = Vector(20, -17, 1) -- Forward,Up,Right
CIVRP_Item_Data["item_ammo_pistol"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["item_ammo_pistol"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["item_ammo_pistol"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_ammo_pistol"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		plyUser:GiveAmmo(20, "pistol")
	end
	plyUser:PlaySound("items/ammo_pickup.wav", 70)
	return true
end

CIVRP_Item_Data["item_ammo_smg1"] = {Class = "item_ammo_smg1", Model = "models/items/boxmrounds.mdl"}
CIVRP_Item_Data["item_ammo_smg1"].HoldPos = Vector(20, -18, 1) -- Forward,Up,Right
CIVRP_Item_Data["item_ammo_smg1"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["item_ammo_smg1"].LerpDegree = .5 -- Percent
CIVRP_Item_Data["item_ammo_smg1"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_ammo_smg1"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		plyUser:GiveAmmo(45, "smg1")
	end
	plyUser:PlaySound("items/ammo_pickup.wav", 70)
	return true
end

CIVRP_Item_Data["item_box_buckshot"] = {Class = "item_box_buckshot", Model = "models/items/boxbuckshot.mdl"}
CIVRP_Item_Data["item_box_buckshot"].HoldPos = Vector(20, -16, 12) -- Forward,Up,Right
CIVRP_Item_Data["item_box_buckshot"].HoldAngle = Angle(0, 135, 0)
CIVRP_Item_Data["item_box_buckshot"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["item_box_buckshot"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_box_buckshot"].FireFunction = function(plyUser, swepWeapon, tblItem)
	plyUser:GiveAmmo(10, "buckshot")
	plyUser:PlaySound("items/ammo_pickup.wav", 70)
	return true
end

CIVRP_Item_Data["item_ammo_ar2"] = {Class = "item_ammo_ar2", Model = "models/items/combine_rifle_cartridge01.mdl"}
CIVRP_Item_Data["item_ammo_ar2"].HoldPos = Vector(20, -15, 15) -- Forward,Up,Right
CIVRP_Item_Data["item_ammo_ar2"].HoldAngle = Angle(90, 180, 0)
CIVRP_Item_Data["item_ammo_ar2"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_ammo_ar2"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_ammo_ar2"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		plyUser:GiveAmmo(30, "ar2")
	end
	plyUser:PlaySound("items/ammo_pickup.wav", 70)
	return true
end

CIVRP_Item_Data["item_flare"] = {Class = "item_flare", Model = "models/props_junk/flare.mdl"}
CIVRP_Item_Data["item_flare"].HoldPos = Vector(20, -10, 8) -- Forward,Up,Right
CIVRP_Item_Data["item_flare"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["item_flare"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_flare"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_flare"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		tblItem.Lit = function(entity) 		
			entity.Flare = ents.Create("env_flare")
			entity.Flare:SetParent(entity)
			entity.Flare:SetAngles(Angle(entity:GetAngles().p + 90,entity:GetAngles().y,entity:GetAngles().r))
			entity.Flare:SetPos(entity:GetPos() + entity:GetAngles():Up() * 6)
			entity.Flare:SetKeyValue("scale","10")
			--entity.Flare:SetKeyValue("spawnflags","2")
			entity.Flare:SetNoDraw(true)
			entity.Flare:Spawn()
			entity.Flare:Fire('Start', '240', 0)
			timer.Simple(300, function() if entity.Flare:IsValid() then entity.Flare:Remove() end if entity:IsValid() then entity:Remove() end end)
		end
	else
		if !tblItem.Lit then
			tblItem.Lit = true
		end
	end
	return false
end
CIVRP_Item_Data["item_flare"].CalcView = function(ply,swepWeapon, origin, angles, fov, tblWeaponData,tagertPosition,tagertAngles)-- Self is the swep
	if tblWeaponData.Lit then
		
		local effectdata = EffectData() 
		effectdata:SetOrigin(origin + angles:Forward() * tagertPosition.x + angles:Up() * tagertPosition.y + angles:Right() * tagertPosition.z) 
 		effectdata:SetAngle( tagertAngles:Forward() ) 
 		effectdata:SetScale( .2 ) 

		tblWeaponData.SmokeTimer = tblWeaponData.SmokeTimer or 0

		if ( tblWeaponData.SmokeTimer > CurTime() ) then return end
		
		tblWeaponData.SmokeTimer = CurTime() + 0.0001

		local vOffset = (origin + angles:Forward() * tagertPosition.x + angles:Up() * tagertPosition.y  + angles:Right() * tagertPosition.z  + angles:Right() * -1 + angles:Up() * 7 + angles:Forward() * -2)

		local emitter = ParticleEmitter( vOffset )
	
			local particle = emitter:Add( "particle/sparkles", vOffset )
			particle:SetVelocity(Vector(0,0,0))
			particle:SetGravity(Vector(0,0,0))
			particle:SetDieTime(math.random(1,1))
			particle:SetStartAlpha(math.random(40,50))
			particle:SetEndAlpha(0)
			particle:SetStartSize(0.1)
			particle:SetEndSize(0.4)
			particle:SetRoll(0)
			particle:SetRollDelta(0)
			particle:SetColor(250,200,200)
			particle:SetAirResistance(5)
	
			local particle = emitter:Add( "particles/smokey", vOffset )
			particle:SetVelocity(Vector(math.random(1,5),math.random(1,5),20))
			particle:SetGravity(Vector(5,5,3))
			particle:SetDieTime(math.random(2,2.5))
			particle:SetStartAlpha(math.random(40,50))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(1,2))
			particle:SetEndSize(math.random(3,4))
			particle:SetRoll(math.random(200,300))
			particle:SetRollDelta(math.random(-1,1))
			particle:SetColor(150,40,40)
			particle:SetAirResistance(5)
					
		emitter:Finish()
		
			local dlight = DynamicLight( swepWeapon:EntIndex() )
			if ( dlight ) then
				dlight.Pos = vOffset + Vector(0,0,10)
				dlight.r = 255
				dlight.g = 0
				dlight.b = 0
				dlight.Brightness = 1
				dlight.Decay = 256
				dlight.Size = 500
				dlight.DieTime = CurTime() + 0.3
		end
 	end
	return nil
end

--	models/props_junk/meathook001a.mdl
--harpoon 	models/props_junk/harpoon002a.mdl
--pan  models/props_interiors/pot02a.mdl
--pipe	models/props_c17/gaspipes006a.mdl
--2by4	models/props_debris/wood_board02a.mdl
--shotgun models/weapons/w_shotgun.mdl
--pole "models/props_c17/signpole001.mdl"

CIVRP_Item_Data["weapon_spear"] = {Class = "weapon_spear", Model = "models/props_junk/harpoon002a.mdl"}
CIVRP_Item_Data["weapon_spear"].HoldPos = Vector(-8, -4, 12)
CIVRP_Item_Data["weapon_spear"].HoldAngle = Angle(0, 0, -40)
CIVRP_Item_Data["weapon_spear"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_spear"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_spear"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_spear"].ANIMATIONS["Fire01"] = {Time = .6,
	{Pos = CIVRP_Item_Data["weapon_spear"].HoldPos, Angle = CIVRP_Item_Data["weapon_spear"].HoldAngle},
	{Pos = Vector(35, -4, 12), Angle = Angle(5, 20, -40)},
	{Pos = Vector(45, -4, 12), Angle = Angle(5, 20, -40)},
	{Pos = CIVRP_Item_Data["weapon_spear"].HoldPos,Angle = CIVRP_Item_Data["weapon_spear"].HoldAngle},
}
CIVRP_Item_Data["weapon_spear"].ANIMATIONS["Fire02"] = {Time = .6,
	{Pos = CIVRP_Item_Data["weapon_spear"].HoldPos, Angle = CIVRP_Item_Data["weapon_spear"].HoldAngle},
	{Pos = Vector(0, -12, 10), Angle = Angle(15, 10, 40)},
	{Pos = Vector(0, -14, 7), Angle = Angle(25, 6, 40)},
	{Pos = Vector(5, -12, 5), Angle = Angle(5, 3, 40)},
	{Pos = Vector(30, -10, 3), Angle = Angle(-25, 3, 40)},
	{Pos = CIVRP_Item_Data["weapon_spear"].HoldPos,Angle = CIVRP_Item_Data["weapon_spear"].HoldAngle},
}
CIVRP_Item_Data["weapon_spear"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.AmmoType = "none"
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.ClipSize = -1
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.LoadedBullets = 18
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Damage = 35 
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Cone = 0.02
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Delay = 1
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Range = 80
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.ReloadSpeed = 1
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.Automatic = false
CIVRP_Item_Data["weapon_spear"].WEAPONDATA.DrawAmmo = false
CIVRP_Item_Data["weapon_spear"].FireFunction = function(plyUser, swepWeapon, tblItem)
	local anim = math.random(1,2) 
	if SERVER then
		local tr = plyUser:GetEyeTrace()
		if tr.HitNonWorld then
			if tr.Entity:IsNPC() || tr.Entity:IsPlayer() then
				if anim == 2 then
					timer.Simple(.4,function() if tr.Entity:IsValid() then tr.Entity:TakeDamage(tblItem.WEAPONDATA.Damage) end end)
				else
					tr.Entity:TakeDamage(tblItem.WEAPONDATA.Damage) 
				end
			--	plyUser:PlaySound("physics/flesh/flesh_strider_impact_bullet"..table.Random({"1","2","3"})..".wav")
				plyUser:PlaySound("physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav")
			end
		else
			plyUser:PlaySound("weapons/iceaxe/iceaxe_swing1.wav")
		end
	end
	swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
	swepWeapon:PlayCustomAnimation("Fire0"..anim)
	return false
end

CIVRP_Item_Data["weapon_pole"] = {Class = "weapon_pole", Model = "models/props_c17/signpole001.mdl"}
CIVRP_Item_Data["weapon_pole"].HoldPos = Vector(20, -44, 5)
CIVRP_Item_Data["weapon_pole"].HoldAngle = Angle(0, 0, 15)
CIVRP_Item_Data["weapon_pole"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_pole"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_pole"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_pole"].ANIMATIONS["Fire01"] = {Time = .8,
	{Pos = CIVRP_Item_Data["weapon_pole"].HoldPos, Angle = CIVRP_Item_Data["weapon_pole"].HoldAngle},
	{Pos = Vector(30, -54, 45), Angle = Angle(45, -55, -90)},
	{Pos = Vector(28, -54, 35), Angle = Angle(45, -55, -90)},
	{Pos = Vector(25, -54, 25), Angle = Angle(25, 60, -90)},
	{Pos = CIVRP_Item_Data["weapon_pole"].HoldPos,Angle = CIVRP_Item_Data["weapon_pole"].HoldAngle},
}
CIVRP_Item_Data["weapon_pole"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.AmmoType = "none"
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.ClipSize = -1
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.LoadedBullets = 18
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Damage = 35 
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Cone = 0.02
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Delay = 1
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Range = 70
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.ReloadSpeed = 1
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.Automatic = false
CIVRP_Item_Data["weapon_pole"].WEAPONDATA.DrawAmmo = false
CIVRP_Item_Data["weapon_pole"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		local tr = plyUser:GetEyeTrace()
		if tr.HitNonWorld then
			if tr.Entity:IsNPC() || tr.Entity:IsPlayer() then
				tr.Entity:TakeDamage(tblItem.WEAPONDATA.Damage)
				plyUser:PlaySound("physics/metal/metal_solid_impact_hard"..table.Random({"1","4","5"})..".wav")
			end
		else
			plyUser:PlaySound("weapons/iceaxe/iceaxe_swing1.wav")
		end
	end
	swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
	swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,1))
	return false
end

CIVRP_Item_Data["weapon_crowbar"] = {Class = "weapon_crowbar", Model = "models/weapons/w_crowbar.mdl"}
CIVRP_Item_Data["weapon_crowbar"].HoldPos = Vector(15, -12, 8)
CIVRP_Item_Data["weapon_crowbar"].HoldAngle = Angle(90, 45, 0)
CIVRP_Item_Data["weapon_crowbar"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_crowbar"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_crowbar"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_crowbar"].ANIMATIONS["Fire01"] = {Time = 0.4,
	{Pos = Vector(13, -12, 8), Angle = CIVRP_Item_Data["weapon_crowbar"].HoldAngle},
	{Pos = Vector(35, -14, 3), Angle = Angle(150, 90, 50)},
	{Pos = Vector(13, -12, 8),Angle = CIVRP_Item_Data["weapon_crowbar"].HoldAngle},
}
CIVRP_Item_Data["weapon_crowbar"].ANIMATIONS["Fire02"] = {Time = 0.4,
	{Pos = CIVRP_Item_Data["weapon_crowbar"].HoldPos, Angle = CIVRP_Item_Data["weapon_crowbar"].HoldAngle},
	{Pos = Vector(35, -16, 10), Angle = Angle(170, 60, 00)},
	{Pos = CIVRP_Item_Data["weapon_crowbar"].HoldPos,Angle = CIVRP_Item_Data["weapon_crowbar"].HoldAngle},
}
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.AmmoType = "none"
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.ClipSize = -1
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.LoadedBullets = 18
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Damage = 15 
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Cone = 0.02
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Delay = 0.4
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Range = 60
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.ReloadSpeed = 1
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.Automatic = true
CIVRP_Item_Data["weapon_crowbar"].WEAPONDATA.DrawAmmo = false
CIVRP_Item_Data["weapon_crowbar"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		local tr = plyUser:GetEyeTrace()
		if tr.HitNonWorld then
			if tr.Entity:IsNPC() || tr.Entity:IsPlayer() then
				tr.Entity:TakeDamage(tblItem.WEAPONDATA.Damage)
				plyUser:PlaySound("physics/flesh/flesh_impact_bullet"..math.random(1,5)..".wav")
			end
		else
			plyUser:PlaySound("weapons/iceaxe/iceaxe_swing1.wav")
		end
	end
	swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
	swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,2))
	return false
end

CIVRP_Item_Data["weapon_pistol"] = {Class = "weapon_pistol", Model = "models/weapons/W_pistol.mdl"}
CIVRP_Item_Data["weapon_pistol"].HoldPos = Vector(15, -8, 8)
CIVRP_Item_Data["weapon_pistol"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["weapon_pistol"].MuzzlePos = Vector(7, 0, 0)
CIVRP_Item_Data["weapon_pistol"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_pistol"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Fire01"] = {Time = 0.15,{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle},{Pos = Vector(14, -8, 8), Angle = Angle(10, 190, 0),},{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle,}}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Fire02"] = {Time = 0.15,{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle},{Pos = Vector(14, -8, 8), Angle = Angle(10, 170, 0),},{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle,}}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Fire03"] = {Time = 0.15,{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle},{Pos = Vector(14, -8, 8), Angle = Angle(40, 190, 0),},{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle,}}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Fire04"] = {Time = 0.15,{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle},{Pos = Vector(14, -8, 8), Angle = Angle(40,170, 0),},{Pos = CIVRP_Item_Data["weapon_pistol"].HoldPos, Angle = CIVRP_Item_Data["weapon_pistol"].HoldAngle,}}
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.AmmoType = "pistol"
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.ClipSize = 18
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.LoadedBullets = 18
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.Damage = 10 
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.Cone = 0.02
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.Delay = 0.02
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.ReloadSpeed = 1
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.Automatic = false
CIVRP_Item_Data["weapon_pistol"].WEAPONDATA.DrawAmmo = true
CIVRP_Item_Data["weapon_pistol"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if swepWeapon:Clip1() <= 0 then
		swepWeapon:CustomReload()
	else
		swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
		swepWeapon:SetClip1(swepWeapon:Clip1() - 1)
		tblItem.WEAPONDATA.LoadedBullets = tblItem.WEAPONDATA.LoadedBullets - 1
		plyUser:CreateBullet(tblItem.WEAPONDATA.NumShots, tblItem.WEAPONDATA.Cone, tblItem.WEAPONDATA.Damage)
		if SERVER then
			plyUser:PlaySound("weapons/pistol/pistol_fire2.wav")
			plyUser:MuzzleFlash()
		end
		if CLIENT or SinglePlayer() then
			local effectdata = EffectData()
			effectdata:SetOrigin(swepWeapon:GetViewModelMuzzlePostion())
			effectdata:SetAngle(plyUser:GetAngles())
			effectdata:SetScale(.5)
			util.Effect("MuzzleEffect", effectdata)
			swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,4))
		end
	end
	return false
end


CIVRP_Item_Data["weapon_smg"] = {Class = "weapon_smg", Model = "models/weapons/w_smg1.mdl"}
CIVRP_Item_Data["weapon_smg"].HoldPos = Vector(18, -9, 7)
CIVRP_Item_Data["weapon_smg"].HoldAngle = Angle(0, 0, 0)
CIVRP_Item_Data["weapon_smg"].MuzzlePos = Vector(27, -4, 3)
CIVRP_Item_Data["weapon_smg"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_smg"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_smg"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_smg"].ANIMATIONS["Fire01"] = {Time = 0.15,{Pos = CIVRP_Item_Data["weapon_smg"].HoldPos, Angle = CIVRP_Item_Data["weapon_smg"].HoldAngle},
{Pos = Vector(17, -9, 7), Angle = Angle(3, 3, 0),},
{Pos = CIVRP_Item_Data["weapon_smg"].HoldPos, Angle = CIVRP_Item_Data["weapon_smg"].HoldAngle,}}
CIVRP_Item_Data["weapon_smg"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.AmmoType = "smg1"
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.ClipSize = 45
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.LoadedBullets = 45
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.Damage = 5 
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.Cone = 0.03
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.Delay = .1
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.ReloadSpeed = 1
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.Automatic = true
CIVRP_Item_Data["weapon_smg"].WEAPONDATA.DrawAmmo = true
CIVRP_Item_Data["weapon_smg"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if swepWeapon:Clip1() <= 0 then
		swepWeapon:CustomReload()
	else
		swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
		swepWeapon:SetClip1(swepWeapon:Clip1() - 1)
		tblItem.WEAPONDATA.LoadedBullets = tblItem.WEAPONDATA.LoadedBullets - 1
		plyUser:CreateBullet(tblItem.WEAPONDATA.NumShots, tblItem.WEAPONDATA.Cone, tblItem.WEAPONDATA.Damage)
		if SERVER then
			plyUser:PlaySound("weapons/smg1/smg1_fire1.wav")
			plyUser:MuzzleFlash()
		end
		if CLIENT or SinglePlayer() then
			local effectdata = EffectData()
			effectdata:SetOrigin(swepWeapon:GetViewModelMuzzlePostion())
			effectdata:SetAngle(plyUser:GetAngles())
			effectdata:SetScale(.5)
			util.Effect("MuzzleEffect", effectdata)
			swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,1))
		end
	end
	return false
end

CIVRP_Item_Data["weapon_shotgun"] = {Class = "weapon_shotgun", Model = "models/weapons/w_shotgun.mdl"}
CIVRP_Item_Data["weapon_shotgun"].HoldPos = Vector(15, -8, 6)
CIVRP_Item_Data["weapon_shotgun"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["weapon_shotgun"].MuzzlePos = Vector(35, 0, 3)
CIVRP_Item_Data["weapon_shotgun"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_shotgun"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_shotgun"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_shotgun"].ANIMATIONS["Fire01"] = {Time = 0.3,{Pos = CIVRP_Item_Data["weapon_shotgun"].HoldPos, Angle = CIVRP_Item_Data["weapon_shotgun"].HoldAngle},
{Pos = Vector(13, -7, 6), Angle = Angle(10, 190, 0),},
{Pos = CIVRP_Item_Data["weapon_shotgun"].HoldPos, Angle = CIVRP_Item_Data["weapon_shotgun"].HoldAngle,}}
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.AmmoType = "buckshot"
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.ClipSize = 6
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.LoadedBullets = 6
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.Damage = 10 
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.Cone = 0.1
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.Delay = .8
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.NumShots = 6
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.ReloadSpeed = 2
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.Automatic = true
CIVRP_Item_Data["weapon_shotgun"].WEAPONDATA.DrawAmmo = true
CIVRP_Item_Data["weapon_shotgun"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if swepWeapon:Clip1() <= 0 then
		swepWeapon:CustomReload()
	else
		swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
		swepWeapon:SetClip1(swepWeapon:Clip1() - 1)
		tblItem.WEAPONDATA.LoadedBullets = tblItem.WEAPONDATA.LoadedBullets - 1
		plyUser:CreateBullet(tblItem.WEAPONDATA.NumShots, tblItem.WEAPONDATA.Cone, tblItem.WEAPONDATA.Damage)
		if SERVER then
			plyUser:PlaySound("weapons/shotgun/shotgun_fire6.wav")
			plyUser:MuzzleFlash()
		end
		if CLIENT or SinglePlayer() then
			local effectdata = EffectData()
			effectdata:SetOrigin(swepWeapon:GetViewModelMuzzlePostion())
			effectdata:SetAngle(plyUser:GetAngles())
			effectdata:SetScale(.5)
			util.Effect("MuzzleEffect", effectdata)
			swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,1))
		end
	end
	return false
end

CIVRP_Item_Data["weapon_ar2"] = {Class = "weapon_ar2", Model = "models/weapons/w_IRifle.mdl"}
CIVRP_Item_Data["weapon_ar2"].HoldPos = Vector(18, -9, 7)
CIVRP_Item_Data["weapon_ar2"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["weapon_ar2"].MuzzlePos = Vector(27, 0, 3)
CIVRP_Item_Data["weapon_ar2"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_ar2"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_ar2"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_ar2"].ANIMATIONS["Fire01"] = {Time = 0.2,{Pos = CIVRP_Item_Data["weapon_ar2"].HoldPos, Angle = CIVRP_Item_Data["weapon_ar2"].HoldAngle},
{Pos = Vector(17, -9, 7), Angle = Angle(3, 183, 0),},
{Pos = CIVRP_Item_Data["weapon_ar2"].HoldPos, Angle = CIVRP_Item_Data["weapon_ar2"].HoldAngle,}}
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA = {}
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.NextFire = 0
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.AmmoType = "ar2"
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.ClipSize = 30
--This is for server side to keep track of the ammo when the weapon is not active
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.LoadedBullets = 30
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.Damage = 13 
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.Cone = 0.03
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.Recoil = 2
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.Delay = .14
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.NumShots = 1
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.ReloadSpeed = 1.5
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.Automatic = true
CIVRP_Item_Data["weapon_ar2"].WEAPONDATA.DrawAmmo = true
CIVRP_Item_Data["weapon_ar2"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if swepWeapon:Clip1() <= 0 then
		swepWeapon:CustomReload()
	else
		swepWeapon:SetNextPrimaryFire(CurTime() + tblItem.WEAPONDATA.Delay)
		swepWeapon:SetClip1(swepWeapon:Clip1() - 1)
		tblItem.WEAPONDATA.LoadedBullets = tblItem.WEAPONDATA.LoadedBullets - 1
		plyUser:CreateBullet(tblItem.WEAPONDATA.NumShots, tblItem.WEAPONDATA.Cone, tblItem.WEAPONDATA.Damage)
		if SERVER then
			plyUser:PlaySound("weapons/ar2/fire1.wav")
			plyUser:MuzzleFlash()
		end
		if CLIENT or SinglePlayer() then
			local effectdata = EffectData()
			effectdata:SetOrigin(swepWeapon:GetViewModelMuzzlePostion())
			effectdata:SetAngle(plyUser:GetAngles())
			effectdata:SetScale(.5)
			util.Effect("MuzzleEffect", effectdata)
			swepWeapon:PlayCustomAnimation("Fire0"..math.random(1,1))
		end
	end
	return false
end
