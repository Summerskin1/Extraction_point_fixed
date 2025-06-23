if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName			= "Spaz Shotgun"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 2

   SWEP.Icon = "VGUI/ep/sample"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 7.1
SWEP.Primary.Damage = 11
SWEP.Primary.Delay = 0.65
SWEP.Primary.Cone = 0.10
SWEP.Primary.NumShots = 8
SWEP.Primary.ClipSize = 8
SWEP.Primary.ClipMax = 48
SWEP.Primary.DefaultClip = 48
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 11
SWEP.HeadDamage = 25

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_shotgun.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"