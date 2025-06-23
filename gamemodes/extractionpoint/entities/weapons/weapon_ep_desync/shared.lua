if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Revolver"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   
   SWEP.DrawCrosshair   = false
   
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 3
SWEP.Primary.Damage = 39
SWEP.Primary.Delay = 0.2
SWEP.Primary.Cone = 0.017
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = false

SWEP.Primary.Clips       	= 2
SWEP.Primary.MaxClips       = 2

SWEP.BodyDamage = 53
SWEP.HeadDamage = 106

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.009
SWEP.NormalCone = 0.017
SWEP.ZoomSensitivity = 1.5

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 4
SWEP.ReloadCritStart	= 2.5
SWEP.ReloadCritEnd		= 2.7
SWEP.ReloadAnimLength	= 4
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

SWEP.ZoomPos = Vector(-3.0, -6, 0.5)

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"


function SWEP:Reload()
	if IsFirstTimePredicted() then
		if !self.ReloadDown then
			if SERVER then
				print("Reload hit (SERVER)")
			end
			if CLIENT then
				print("Reload hit (CLIENT)")
			end
		end
	end
	self.ReloadDown = true
end

function SWEP:Think()
	if !self.Owner:KeyDown( IN_RELOAD ) then
		self.ReloadDown = false
	end
end