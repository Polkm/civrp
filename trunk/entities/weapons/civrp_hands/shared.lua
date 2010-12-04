if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "melee"
	SWEP.IconLetter			= "I"
end
if CLIENT then
	SWEP.DrawAmmo			= false
	SWEP.EntViewModelFOV	= 64
	SWEP.EntViewModelFlip	= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.Author				= "Noobulater"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.EntViewModel		= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Primary.ReloadSpeed = 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 0.2

SWEP.Throwing = nil
SWEP.LoadedAmmo = 0

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
	self:GetOwner():SelectItem(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
	if SERVER then
		self.Owner:DrawViewModel(false)
	end
end

function SWEP:Reload()
	if self:GetNextSecondaryFire() > CurTime() then return end
	self:CycleSelect()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:CycleSelect()
	if SERVER then
		if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class == nil then
			for i = 1, table.Count(self:GetOwner().ItemData) - 1 do
				if self:GetOwner().ItemData["SELECTED"] + 1 >= table.Count(self:GetOwner().ItemData) - 1 then
					self:GetOwner().ItemData["SELECTED"] = 1
				else
					self:GetOwner().ItemData["SELECTED"] = self:GetOwner().ItemData["SELECTED"] + 1
				end		
				if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class != nil then
					self:LoadWeapon(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
					CIVRP_SELECTED_Update(self:GetOwner())
					break	
				end
			end
		else
			if self:GetOwner().ItemData["SELECTED"] + 1 >= table.Count(self:GetOwner().ItemData) - 1 then
				self:GetOwner().ItemData["SELECTED"] = 1
			else
				self:GetOwner().ItemData["SELECTED"] = self:GetOwner().ItemData["SELECTED"] + 1
			end	
			self:LoadWeapon(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
			CIVRP_SELECTED_Update(self:GetOwner())			
		end
	end
end

function SWEP:LoadWeapon(itemtbl)
	if itemtbl != nil then 
		if itemtbl.WEAPONDATA != nil then 
			self.Primary.Recoil			= itemtbl.WEAPONDATA.Recoil || 0
			self.Primary.Damage			= itemtbl.WEAPONDATA.Damage || -1
			self.Primary.NumShots		= itemtbl.WEAPONDATA.NumShots || 1
			self.Primary.Cone			= itemtbl.WEAPONDATA.Cone || 0
			self.Primary.Delay			= itemtbl.WEAPONDATA.Delay || 0
			self.Primary.ClipSize		= itemtbl.WEAPONDATA.ClipSize || -1
			self.Primary.LoadedBullets	= itemtbl.WEAPONDATA.LoadedBullets || itemtbl.WEAPONDATA.ClipSize || -1
			self.Primary.ReloadSpeed  = itemtbl.WEAPONDATA.ReloadSpeed || 0
			self.Primary.DefaultClip	= -1
			
			self.Primary.Automatic		= itemtbl.WEAPONDATA.Automatic || false
			self.Primary.Ammo			= itemtbl.WEAPONDATA.AmmoType || "none"
			--if ( SinglePlayer() && CLIENT ) || CLIENT then
				self.DrawAmmo = itemtbl.WEAPONDATA.DrawAmmo || false
			--end
		end
	else
		self.Primary.Recoil			= 0
		self.Primary.Damage			= -1
		self.Primary.NumShots		= 1
		self.Primary.Cone			= 0
		self.Primary.Delay			= 0.0
		self.Primary.ClipSize		= -1
		self.Primary.DefaultClip	= -1
		self.Primary.LoadedBullets	= -1
		
		self.Primary.ReloadSpeed = 0 
		
		self.Primary.Automatic		= false
		self.Primary.Ammo			= "none"
	end
	self:SetClip1(self.Primary.LoadedBullets)
end

function SWEP:CustomReload()
	if self:GetNWBool("reloading") then return false end
	if SERVER then
		self:SetNWBool("reloading", true)
	end
	self:GetOwner():RestartGesture(self:GetOwner():Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RELOAD))
	self:SetNextPrimaryFire(CurTime() + self.Primary.ReloadSpeed)
	self:SetNextSecondaryFire(CurTime() + self.Primary.ReloadSpeed)
	if self.Primary.ReloadSpeed > 0 then
		timer.Simple(self.Primary.ReloadSpeed, function() if self:IsValid() then self:LoadClip() end end)
	else
		self:LoadClip()
	end
end

function SWEP:LoadClip()
	if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
		if SERVER then
			self:GetOwner():RemoveAmmo(self.Primary.ClipSize - self.Weapon:Clip1()  ,self.Primary.Ammo )
		end	
		self.Weapon:SetClip1(self.Primary.ClipSize)
	else
		self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
		if SERVER then
			self:GetOwner():RemoveAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo),self.Primary.Ammo)
		end
	end
	self:SetNWBool("reloading", false)
	self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].WEAPONDATA.LoadedBullets = self.Weapon:Clip1()--self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].WEAPONDATA.ClipSize
	return true
end

function SWEP:Holster()
	if CLIENT then
		self.EntViewModel:SetNoDraw(true)
	end
	return true
end

function SWEP:Think()
	if self.Throwing != nil then
		if input.IsMouseDown(MOUSE_RIGHT) then
			self.Throwing = self.Throwing + 1
		elseif !input.IsMouseDown(MOUSE_RIGHT) then
			return
		end
	end
end

function SWEP:CanPrimaryAttack()
	return true
end
function SWEP:CanSecondaryAttack()
	return true
end
function SWEP:PrimaryAttack()
	if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class != nil then
		--PrintTable(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
		if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].FireFunction(self:GetOwner(), self, self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]]) then
			self:GetOwner():RemoveItem(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class, 1)
		end	 
	end
end

function SWEP:SecondaryAttack()
	if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class != nil then
		if SERVER then
			if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].SpawnFunction != nil then
				local data = self:GetOwner().SpawnFunction(self)
			else
				local entity = ents.Create("prop_physics")
				entity:SetModel(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Model)
				entity.ItemClass = self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class
				entity.ItemTable = self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]]
				entity:SetAngles(self:GetOwner():GetAngles() + self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldAngle)
				entity:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAngles():Forward() * (self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.x) + self:GetOwner():GetAngles():Up() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.y + self:GetOwner():GetAngles():Right() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.z )
				entity:Spawn()
				entity:Activate()
				entity:SetOwner(nil)
				entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				if entity:GetPhysicsObject():IsValid() then
					entity:GetPhysicsObject():Wake()
					entity:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
					entity:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetAngles():Forward() * (entity:GetPhysicsObject():GetMass() * 100))
				end
				self:GetOwner():RemoveItem(strItem, 1, self:GetOwner().ItemData["SELECTED"])
			end
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self.Throwing = nil
	else
		if SERVER then
			local trace = self.Owner:GetEyeTrace()
			if trace.Hit && trace.HitNonWorld && trace.HitPos:Distance(self.Owner:GetPos()) < 200 then
				local strItem = trace.Entity.ItemClass or trace.Entity:GetClass() 
				if CIVRP_Item_Data[strItem] != nil then
					self:GetOwner():AddItem(strItem, 1, trace.Entity.ItemTable) 
					trace.Entity:Remove()
				end
			end
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	end
end

if CLIENT then
	SWEP.EntViewModel = ClientsideModel('models/healthvial.mdl', RENDERGROUP_OPAQUE)
	SWEP.EntViewModel:SetModel('models/healthvial.mdl')
	SWEP.EntViewModel:Spawn()
	SWEP.EntViewModel:SetNoDraw(true)
	local beforeAngles = Angle(0, 0, 0)
	local beforeVectors = Vector(0, 0, 0)
	function SWEP:CalcView(ply, origin, angles, fov)
		local view = {}
		view.origin = origin
		view.angles = angles
		view.fov = fov
		if LocalPlayer().ItemData != nil then
			local tblWeaponData = LocalPlayer().ItemData[self:GetOwner().ItemData["SELECTED"]] || "empty"
			if tblWeaponData != "empty"	then
				if tblWeaponData.CalcView != nil then
					local data = tblWeaponData.CalcView(ply, origin, angles, fov)
				else
					self.EntViewModel:SetNoDraw(false)
					self.EntViewModel:SetModel(tblWeaponData.Model)
				--	beforeVectors = self.EntViewModel:GetPos()
					self.EntViewModel:SetPos(origin + angles:Forward() * tblWeaponData.HoldPos.x + angles:Up() * tblWeaponData.HoldPos.y + angles:Right() * tblWeaponData.HoldPos.z)
				--	if LocalPlayer():GetVelocity():Length() != 0 && LocalPlayer():OnGround() then
					--	self.EntViewModel:SetPos(LerpVector( 0.5,beforeVectors,self.EntViewModel:GetPos()))
					--end
					beforeAngles = self.EntViewModel:GetAngles()
					self.EntViewModel:SetAngles(Angle(angles.p, angles.y, angles.r))
					self.EntViewModel:SetAngles(self.EntViewModel:LocalToWorldAngles(tblWeaponData.HoldAngle))
					self.EntViewModel:SetAngles(LerpAngle(tblWeaponData.LerpDegree, beforeAngles, self.EntViewModel:GetAngles()))
				end
			else
				self.EntViewModel:SetNoDraw(true)
			end
		end
		return view
	end
	
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}
		if LocalPlayer().ItemData != nil then
			local tblWeaponData = LocalPlayer().ItemData[LocalPlayer().ItemData["SELECTED"]] || "empty"
			if tblWeaponData != "empty"	and tblWeaponData.WEAPONDATA != nil then
				self.AmmoDisplay.Draw = true
				self.AmmoDisplay.PrimaryClip = LocalPlayer():GetActiveWeapon():Clip1()
				self.AmmoDisplay.PrimaryAmmo = LocalPlayer():GetAmmoCount(tblWeaponData.WEAPONDATA.AmmoType)
			else
				self.AmmoDisplay.Draw = false
			end
		end
		return self.AmmoDisplay
	end
	
	function SWEP:GetTracerOrigin()
		 return self.EntViewModel:GetPos()
	end
end
