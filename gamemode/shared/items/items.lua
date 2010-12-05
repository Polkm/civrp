
CIVRP_Item_Data = {}
CIVRP_Item_Data["item_healthvial"] = {Class = "item_healthvial", Model = "models/healthvial.mdl"}
CIVRP_Item_Data["item_healthvial"].HoldPos = Vector(15, -15, 8)
CIVRP_Item_Data["item_healthvial"].HoldAngle = Angle(0, 0, 0)
CIVRP_Item_Data["item_healthvial"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_healthvial"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_healthvial"].FireFunction = function(plyUser, swepWeapon, tblItem)
	local worked = RestorHealth(plyUser, 20)
	if worked then PlaySound(plyUser, "items/smallmedkit1.wav", 70) end
	return worked
end

CIVRP_Item_Data["item_healthkit"] = {Class = "item_healthkit", Model = "models/Items/HealthKit.mdl"}
CIVRP_Item_Data["item_healthkit"].HoldPos = Vector(15, -4, 1) -- Forward,Up,Right
CIVRP_Item_Data["item_healthkit"].HoldAngle = Angle(90, 180, 0)
CIVRP_Item_Data["item_healthkit"].LerpDegree = .5 -- Percent
CIVRP_Item_Data["item_healthkit"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_healthkit"].FireFunction = function(plyUser, swepWeapon, tblItem)
	local worked = RestorHealth(plyUser, 50)
	if worked then PlaySound(plyUser, "items/smallmedkit1.wav", 70) end
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
	plyUser:GiveAmmo(20, "pistol")
	PlaySound(plyUser, "items/ammo_pickup.wav", 70) 
	return true
end

CIVRP_Item_Data["item_ammo_smg1"] = {Class = "item_ammo_smg1", Model = "models/items/boxmrounds.mdl"}
CIVRP_Item_Data["item_ammo_smg1"].HoldPos = Vector(20, -18, 1) -- Forward,Up,Right
CIVRP_Item_Data["item_ammo_smg1"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["item_ammo_smg1"].LerpDegree = .5 -- Percent
CIVRP_Item_Data["item_ammo_smg1"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_ammo_smg1"].FireFunction = function(plyUser, swepWeapon, tblItem)
	plyUser:GiveAmmo(45, "smg1")
	PlaySound(plyUser, "items/ammo_pickup.wav", 70) 
	return true
end

CIVRP_Item_Data["item_box_buckshot"] = {Class = "item_box_buckshot", Model = "models/items/boxbuckshot.mdl"}
CIVRP_Item_Data["item_box_buckshot"].HoldPos = Vector(20, -16, 12) -- Forward,Up,Right
CIVRP_Item_Data["item_box_buckshot"].HoldAngle = Angle(0, 135, 0)
CIVRP_Item_Data["item_box_buckshot"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["item_box_buckshot"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_box_buckshot"].FireFunction = function(plyUser, swepWeapon, tblItem)
	plyUser:GiveAmmo(10, "buckshot")
	PlaySound(plyUser, "items/ammo_pickup.wav", 70) 
	return true
end

CIVRP_Item_Data["item_ammo_ar2"] = {Class = "item_ammo_ar2", Model = "models/items/combine_rifle_cartridge01.mdl"}
CIVRP_Item_Data["item_ammo_ar2"].HoldPos = Vector(20, -15, 15) -- Forward,Up,Right
CIVRP_Item_Data["item_ammo_ar2"].HoldAngle = Angle(90, 180, 0)
CIVRP_Item_Data["item_ammo_ar2"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_ammo_ar2"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_ammo_ar2"].FireFunction = function(plyUser, swepWeapon, tblItem)
	plyUser:GiveAmmo(30, "ar2")
	PlaySound(plyUser, "items/ammo_pickup.wav", 70) 
	return true
end

CIVRP_Item_Data["item_flare"] = {Class = "item_flare", Model = "models/props_junk/flare.mdl"}
CIVRP_Item_Data["item_flare"].HoldPos = Vector(20, -10, 8) -- Forward,Up,Right
CIVRP_Item_Data["item_flare"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["item_flare"].LerpDegree = .2 -- Percent
CIVRP_Item_Data["item_flare"].BobScale = .3 -- Percent
CIVRP_Item_Data["item_flare"].FireFunction = function(plyUser, swepWeapon, tblItem)
	if SERVER then
		local entity = ents.Create("prop_physics")
		entity:SetModel(tblItem.Model)
		entity:SetAngles(plyUser:GetAngles() + tblItem.HoldAngle)
		entity:SetPos(plyUser:GetShootPos() + plyUser:GetAngles():Forward() * (tblItem.HoldPos.x) + plyUser:GetAngles():Up() * tblItem.HoldPos.y + plyUser:GetAngles():Right() * tblItem.HoldPos.z )
		entity:Spawn()
		entity:Activate()
		entity:SetSkin(2)
		entity:SetOwner(nil)
		entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		if entity:GetPhysicsObject():IsValid() then
			entity:GetPhysicsObject():Wake()
			entity:GetPhysicsObject():SetVelocity(plyUser:GetVelocity())
			entity:GetPhysicsObject():ApplyForceCenter(plyUser:GetAngles():Forward() *(entity:GetPhysicsObject():GetMass() * 1000))
		end
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
	return true
end

CIVRP_Item_Data["weapon_pistol"] = {Class = "weapon_pistol", Model = "models/weapons/W_pistol.mdl"}
CIVRP_Item_Data["weapon_pistol"].HoldPos = Vector(15, -8, 8)
CIVRP_Item_Data["weapon_pistol"].MuzzlePos = Vector(7, 0, 0)
CIVRP_Item_Data["weapon_pistol"].HoldAngle = Angle(0, 180, 0)
CIVRP_Item_Data["weapon_pistol"].LerpDegree = .3 -- Percent
CIVRP_Item_Data["weapon_pistol"].BobScale = .3 -- Percent
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS = {}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Idle"] = {{Pos = Vector(15, -8, 8), Ang = Angle(0, 180, 0)},}
CIVRP_Item_Data["weapon_pistol"].ANIMATIONS["Fire"] = {{Pos = Vector(15, -8, 8), Ang = Angle(0, 190, 0)},}
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
		FireBullets(plyUser, tblItem.WEAPONDATA.NumShots, tblItem.WEAPONDATA.Cone, tblItem.WEAPONDATA.Damage)
		if SERVER then
			PlaySound(plyUser, "weapons/pistol/pistol_fire2.wav")
			plyUser:MuzzleFlash()
		end
		if CLIENT or SinglePlayer() then
			local effectdata = EffectData()
			effectdata:SetOrigin(swepWeapon:GetViewModelMuzzlePostion())
			effectdata:SetAngle(plyUser:GetAngles())
			effectdata:SetScale(.5)
			util.Effect("MuzzleEffect", effectdata)
			swepWeapon:PlayCustomAnimation("Fire")
		end
	end
	return false
end
