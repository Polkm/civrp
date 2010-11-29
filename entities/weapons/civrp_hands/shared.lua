if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "melee"
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= false
	SWEP.EntViewModelFOV		= 64
	SWEP.EntViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.Author			= "Noobulater"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.EntViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

SWEP.WeaponData = nil

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay			= 1

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
	if (SERVER) then
		self.Owner:DrawViewModel(false)
	end
end

function SWEP:Reload()

end

function SWEP:Think()

end
	
function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()
	if self.WeaponData != nil then
		if (SERVER) then
			local entity = ents.Create("prop_physics")
			entity:SetModel(self.WeaponData.Model)
			print(self.WeaponData.Class)
			entity:SetPos(self:GetOwner():GetAngles():Forward() * 50)
			entity:Spawn()
			entity:Activate()
			if entity:GetPhysicsObject():IsValid() then
				entity:GetPhysicsObject():Wake()
			end	
			print(entity)
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self.WeaponData = nil
	else
		local trace = self.Owner:GetEyeTrace()
		if trace.Hit && trace.HitNonWorld then
			if trace.Entity:GetClass() == "item_healthvial" then
				self.WeaponData = {Class = trace.Entity:GetClass(), Model = trace.Entity:GetModel()}
				if (SERVER) then
					trace.Entity:Remove()
				elseif (CLIENT) then
					--CIVRP_Load_Weapon("item_healthvial")
				end
			end
		end
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	end
end

if (CLIENT) then

SWEP.EntViewModel = ClientsideModel('models/healthvial.mdl', RENDERGROUP_OPAQUE)
SWEP.EntViewModel:SetModel('models/healthvial.mdl')
SWEP.EntViewModel:Spawn()
SWEP.EntViewModel:SetNoDraw(true)

function SWEP:CalcView( ply,  origin,  angles,  fov ) 
	local view = {}
    view.origin = origin
    view.angles = angles
    view.fov = fov
	if self.WeaponData != nil then
		self.EntViewModel:SetNoDraw(false)
		self.EntViewModel:SetModel(self.WeaponData.Model)
		self.EntViewModel:SetPos(origin + angles:Forward() * 20 + angles:Up() * -17 + angles:Right() * 8)
		self.EntViewModel:SetAngles(Angle(angles.p,angles.y,angles.r))
	end
    return view
end

end
