if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "shotgun"

if CLIENT then
   SWEP.PrintName			= "Sniper"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Standard issue sniper rifle"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(60,40,10)
   SWEP.LookPos = Vector(12,0,5)
   SWEP.IconLetter = "n"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 4
SWEP.Primary.Damage = 55
SWEP.Primary.Delay = 1.2
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 4
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 55
SWEP.HeadDamage = 110

SWEP.ScopeInTime = 0.3
SWEP.ZoomAmt = 3
SWEP.ZoomCone = 0.002
SWEP.NormalCone = 0.005
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-1, 7, 3)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 1.2
SWEP.ReloadCritEnd		= 1.3
SWEP.ReloadAnimLength	= 3.1
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_SCOUT.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Tracer				= "snipe_smoke"
