if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldTypeAim = "revolver"
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Revolver"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"

   SWEP.DrawCrosshair   = false

   SWEP.WeaponDesc = "Standard high calibre revolver\n'Feeling lucky, Punk?'"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(40,30,5)
   SWEP.LookPos = Vector(7,0,1)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "$"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 3
SWEP.Primary.Damage = 70
SWEP.Primary.Delay = 0.15
SWEP.Primary.Cone = 0.017
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = false

SWEP.Primary.Clips       	= 4
SWEP.Primary.MaxClips       = 4

SWEP.BodyDamage = 45
SWEP.HeadDamage = 106

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.008
SWEP.NormalCone = 0.015
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

SWEP.ZoomPos = Vector(-3.0, -2, 0.7)

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"
