if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "shotgun"

if CLIENT then
   SWEP.PrintName			= "Combat 92"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "A high powered semi-auto combat rifle"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(40,35,10)
   SWEP.LookPos = Vector(3,0,6)
   SWEP.IconLetter = "t"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 5
SWEP.Primary.Damage = 45
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.025
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 48
SWEP.Primary.DefaultClip = 48
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 5
SWEP.Primary.MaxClips       = 5

SWEP.BodyDamage = 36
SWEP.HeadDamage = 56

SWEP.ScopeInTime = 0.3
SWEP.ZoomAmt = 1.6
SWEP.ZoomCone = 0.001
SWEP.NormalCone = 0.025
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 1.5
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 3.2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_ELITE.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas.mdl"
