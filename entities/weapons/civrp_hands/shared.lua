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
SWEP.Primary.Range = 100
SWEP.Primary.ReloadSpeed = 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 2

SWEP.Throwing = nil
SWEP.LoadedAmmo = 0

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
	if self:GetOwner().ItemData != nil then
		self:GetOwner():SelectItem(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
	end
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
			
			self.Primary.Range = itemtbl.WEAPONDATA.Range || 100
			
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
	if self:GetNextSecondaryFire() > CurTime() then return false end
	if self.Throwing then
		if CLIENT then
			if input.IsMouseDown(MOUSE_RIGHT) then
				self.Throwing = self.Throwing + 1
			elseif !input.IsMouseDown(MOUSE_RIGHT) || self.Throwing >= 100 then
				if LocalPlayer().ItemData[self:GetOwner().ItemData["SELECTED"]].Lit != nil then
					LocalPlayer().ItemData[self:GetOwner().ItemData["SELECTED"]].Lit = nil 
				end
				self.Throwing = self.Throwing + 1
				RunConsoleCommand("CIVRP_DropItem",math.Round((self.Throwing/15)*10)/10)
				self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
				self.Throwing = nil
				return
			end
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
	if self:GetOwner().ItemData == nil then self:GetOwner().ItemData = {} return false end
	if self:GetOwner().ItemData["SELECTED"] != nil then
		if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class != nil then
			--PrintTable(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]])
			if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].FireFunction(self:GetOwner(), self, self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]]) then
				if SERVER then
					self:GetOwner():RemoveItem(self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class, 1)
				end
			end	 
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetOwner().ItemData == nil then self:GetOwner().ItemData = {} return false end
	if self:GetOwner().ItemData["SELECTED"] != nil then
		if self:GetOwner().ItemData && self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Class != nil then
			self.Throwing = 1
		else
			local trace = self.Owner:GetEyeTrace()
			if trace.Hit && trace.HitNonWorld && trace.HitPos:Distance(self.Owner:GetPos()) < 200 then
				if SERVER then
					local strItem = trace.Entity.ItemClass or trace.Entity:GetClass() 
					if CIVRP_Item_Data[strItem] != nil then
						self:GetOwner():AddItem(strItem, 1, trace.Entity.ItemTable) 
						trace.Entity:Remove()
					end
				end
				self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
			end
		end
	end
end

local function DropItem(self,force)
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
						entity:GetPhysicsObject():ApplyForceCenter(self:GetOwner():EyeAngles():Forward() * (100 * force))
					end
					if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Lit != nil then
						self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].Lit(entity)
					end
					self:GetOwner():RemoveItem(strItem, 1, self:GetOwner().ItemData["SELECTED"])
				end
			end
		end

concommand.Add("CIVRP_DropItem",function(ply,cmd,args) DropItem(ply:GetActiveWeapon(),args[1]) end)

function SWEP:GetViewModelPostion()
	return self:GetOwner():GetShootPos() +
		self:GetOwner():GetAngles():Forward() * (self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.x) +
		self:GetOwner():GetAngles():Up() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.y +
		self:GetOwner():GetAngles():Right() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].HoldPos.z
end

function SWEP:GetViewModelMuzzlePostion()
	if self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].MuzzlePos then
		return self:GetViewModelPostion() +
			self:GetOwner():GetAngles():Forward() * (self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].MuzzlePos.x) +
			self:GetOwner():GetAngles():Up() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].MuzzlePos.y +
			self:GetOwner():GetAngles():Right() * self:GetOwner().ItemData[self:GetOwner().ItemData["SELECTED"]].MuzzlePos.z
	else
		return self:GetViewModelPostion()
	end
end

function SWEP:PlayCustomAnimation(strAnimation)
	if CLIENT then
		self.EntViewModel.AnimationTable = LocalPlayer().ItemData[self:GetOwner().ItemData["SELECTED"]].ANIMATIONS[strAnimation]
		self.EntViewModel.AnimationStartTime = CurTime()
		self.EntViewModel.AnimationFrame = 1
	else
		SendUsrMsg("CIVRP_PlayWeaponAnimation", self:GetOwner(), {strAnimation})
	end
end

if CLIENT then
	SWEP.EntViewModel = ClientsideModel('models/healthvial.mdl', RENDERGROUP_OPAQUE)
	SWEP.EntViewModel:SetModel('models/healthvial.mdl')
	SWEP.EntViewModel:Spawn()
	SWEP.EntViewModel:SetNoDraw(true)
	SWEP.EntViewModel.AnimationTable = {}
	SWEP.EntViewModel.AnimationFrame = 0
	SWEP.EntViewModel.AnimationStartTime = 0
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
					self.EntViewModel:SetNoDraw(false)
					self.EntViewModel:SetModel(tblWeaponData.Model)
					local tagertAngles = tblWeaponData.HoldAngle
					local tagertPosition = tblWeaponData.HoldPos
					if self.EntViewModel.AnimationTable != nil && self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame] != nil then
						tagertAngles = self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame].Angle
						tagertPosition = self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame].Pos
						local percent = ((CurTime()-self.EntViewModel.AnimationStartTime)/self.EntViewModel.AnimationTable.Time)
						local percentframe = 0
						local timeperframe = 0 
							timeperframe = ((self.EntViewModel.AnimationTable.Time)/(table.Count(self.EntViewModel.AnimationTable)-1))
							percentframe = ((CurTime()-self.EntViewModel.AnimationStartTime)-(timeperframe*(self.EntViewModel.AnimationFrame-1)))/timeperframe
						local subangle = Angle(0,0,0)
						local subpos = Vector(0,0,0)
						if self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame + 1] != nil then
							subangle = self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame + 1].Angle
							subpos = self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame + 1].Pos
						else
							subangle = tblWeaponData.HoldAngle
							subpos = tblWeaponData.HoldPos
						end
						local difpos = (tagertPosition - subpos)
						local difangle = (tagertAngles - subangle)
						tagertAngles = tagertAngles - difangle * percentframe
						tagertPosition = tagertPosition - difpos * percentframe
						if self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame + 1] != nil then
							self.EntViewModel.AnimationFrame = math.floor(((CurTime()-self.EntViewModel.AnimationStartTime)/timeperframe)) + 1
						else
							tagertAngles = tblWeaponData.HoldAngle
							tagertPosition = tblWeaponData.HoldPos
						end
					end					
					if self.Throwing != nil then
						tagertPosition = tagertPosition + Vector(-1 *self.Throwing/50,-1 *self.Throwing/50,self.Throwing/50)
					end
					--beforeVectors = self.EntViewModel:GetPos()
					self.EntViewModel:SetPos(origin + angles:Forward() * tagertPosition.x + angles:Up() * tagertPosition.y + angles:Right() * tagertPosition.z)
					--if LocalPlayer():GetVelocity():Length() != 0 && LocalPlayer():OnGround() then
					--self.EntViewModel:SetPos(LerpVector( 0.5,beforeVectors,self.EntViewModel:GetPos()))
					--end
					if self.EntViewModel.AnimationTable != nil  && self.EntViewModel.AnimationTable[self.EntViewModel.AnimationFrame] != nil then
						--PrintTable(self.EntViewModel.AnimationTable[1])
					end
					beforeAngles = self.EntViewModel:GetAngles()
					self.EntViewModel:SetAngles(Angle(angles.p, angles.y, angles.r))
					self.EntViewModel:SetAngles(self.EntViewModel:LocalToWorldAngles(tagertAngles))
					self.EntViewModel:SetAngles(LerpAngle(tblWeaponData.LerpDegree, beforeAngles, self.EntViewModel:GetAngles()))
					--print(beforeAngles, self.EntViewModel:GetAngles())
					if self.EntViewModel.AnimationTable != nil then
						if !self.EntViewModel.AnimationTable.Time || CurTime() - self.EntViewModel.AnimationStartTime >= self.EntViewModel.AnimationTable.Time then
							self.EntViewModel.AnimationTable = nil
						end
					end
				if tblWeaponData.CalcView != nil then
					local data = tblWeaponData.CalcView(ply, self, origin, angles, fov, tblWeaponData,tagertPosition,tagertAngles)
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
			if tblWeaponData != "empty"	and tblWeaponData.WEAPONDATA != nil && tblWeaponData.WEAPONDATA.AmmoType != "none" then
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
	
	function CIVRP_PlayWeaponAnimation(umsg)
		LocalPlayer():GetActiveWeapon():PlayCustomAnimation(umsg:ReadString())
	end
	usermessage.Hook('CIVRP_PlayWeaponAnimation', CIVRP_PlayWeaponAnimation)
end
