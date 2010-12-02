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

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
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
	if SERVER then
		self.Owner:DrawViewModel(false)
	end
end

function SWEP:Reload()

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
	if self:GetOwner().WeaponData != nil then
		if self:GetOwner().WeaponData.FireFunction(self:GetOwner(), self, self:GetOwner().WeaponData) then
			self:GetOwner().WeaponData = nil
			SendUsrMsg("CIVRP_Weapon_Data_Update", self:GetOwner(), {"empty"})
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetOwner().WeaponData != nil then
		if SERVER then
			if self:GetOwner().SpawnFunction != nil then
				local data = self:GetOwner().SpawnFunction(self)
			else
				local entity = ents.Create("prop_physics")
				entity:SetModel(self:GetOwner().WeaponData.Model)
				entity.ItemClass = self:GetOwner().WeaponData.Class
				entity:SetAngles(self:GetOwner():GetAngles() + self:GetOwner().WeaponData.HoldAngle)
				entity:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAngles():Forward() * (self:GetOwner().WeaponData.HoldPos.x) + self:GetOwner():GetAngles():Up() * self:GetOwner().WeaponData.HoldPos.y + self:GetOwner():GetAngles():Right() * self:GetOwner().WeaponData.HoldPos.z )
				entity:Spawn()
				entity:Activate()
				entity:SetOwner(nil)
				entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				if entity:GetPhysicsObject():IsValid() then
					entity:GetPhysicsObject():Wake()
					entity:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
					entity:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetAngles():Forward() *(entity:GetPhysicsObject():GetMass() * 100))
				end
			end
			self:GetOwner().WeaponData = nil
			SendUsrMsg("CIVRP_Weapon_Data_Update", self:GetOwner(), {"empty"})
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self.Throwing = nil
	else
		if SERVER then
			local trace = self.Owner:GetEyeTrace()
			if trace.Hit && trace.HitNonWorld && trace.HitPos:Distance(self.Owner:GetPos()) < 200 then
				local tblItem = CIVRP_Item_Data[trace.Entity:GetClass()] or CIVRP_Item_Data[trace.Entity.ItemClass]
				if tblItem != nil then
					self:GetOwner().WeaponData = tblItem
					trace.Entity:Remove()
					SendUsrMsg("CIVRP_Weapon_Data_Update", self:GetOwner(), {tblItem.Class})
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
	local beforeVectors = Vector(0,0,0)
	function SWEP:CalcView(ply, origin, angles, fov)
		local view = {}
		view.origin = origin
		view.angles = angles
		view.fov = fov
		local tblWeaponData = LocalPlayer().WeaponData
		if tblWeaponData != nil then
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
		return view
	end
	
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}
		local tblWeaponData = LocalPlayer().WeaponData
		if tblWeaponData != nil and tblWeaponData.AmmoType != nil then
			PrintTable(tblWeaponData)
			self.AmmoDisplay.Draw = true
			self.AmmoDisplay.PrimaryClip = tblWeaponData.LoadedAmmo
			self.AmmoDisplay.PrimaryAmmo = LocalPlayer():GetAmmoCount(tblWeaponData.AmmoType)
		else
			self.AmmoDisplay.Draw = false
		end
		return self.AmmoDisplay
	end
	
	usermessage.Hook("CIVRP_Weapon_Data_Update", function(usrMsg)
		LocalPlayer().WeaponData = CIVRP_Item_Data[usrMsg:ReadString()]
	end)
end
