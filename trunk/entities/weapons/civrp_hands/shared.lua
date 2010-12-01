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
SWEP.Primary.Delay			= 0.2
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

function SWEP:Think()

end
	
function SWEP:PrimaryAttack()
	if self:GetOwner().WeaponData != nil then
		if self:GetOwner().WeaponData.Function(self:GetOwner()) then
			self:GetOwner().WeaponData = nil
			SendUsrMsg("CIVRP_Weapon_Data_Update", self:GetOwner(), {"empty"})
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetOwner().WeaponData != nil then
		if SERVER then
			local entity = ents.Create("prop_physics")
			entity:SetModel(self:GetOwner().WeaponData.Model)
			entity.ItemClass = self:GetOwner().WeaponData.Class
			entity:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAngles():Forward() * 50 + Vector(0, 0, 10))
			entity:Spawn()
			--entity:Activate()
			--entity:SetOwner(nil)
			--if entity:GetPhysicsObject():IsValid() then
				--entity:GetPhysicsObject():Wake()
			--end
			self:GetOwner().WeaponData = nil
			SendUsrMsg("CIVRP_Weapon_Data_Update", self:GetOwner(), {"empty"})
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	else
		if SERVER then
			local trace = self.Owner:GetEyeTrace()
			if trace.Hit && trace.HitNonWorld then
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
	
	function SWEP:CalcView(ply, origin, angles, fov) 
		local view = {}
		view.origin = origin
		view.angles = angles
		view.fov = fov
		if LocalPlayer().WeaponData != nil then
			self.EntViewModel:SetNoDraw(false)
			self.EntViewModel:SetModel(LocalPlayer().WeaponData.Model)
			self.EntViewModel:SetPos(origin + angles:Forward() * 15 + angles:Up() * -15 + angles:Right() * 8)
			self.EntViewModel:SetAngles(LerpAngle(0.2, self.EntViewModel:GetAngles(), Angle(angles.p, angles.y, angles.r)))
		else
			self.EntViewModel:SetNoDraw(true)
		end
		return view
	end
	
	usermessage.Hook("CIVRP_Weapon_Data_Update", function(usrMsg)
		LocalPlayer().WeaponData = CIVRP_Item_Data[usrMsg:ReadString()]
	end)
end
