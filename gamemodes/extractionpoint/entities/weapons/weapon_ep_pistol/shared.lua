if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldTypeAim = "revolver"
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "32c Light Pistol"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"

   SWEP.DrawCrosshair   = false

   SWEP.WeaponDesc = "Standard issue pistol\nIt's lightweight design\nlets you move faster"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(15,24,3)
   SWEP.LookPos = Vector(2,0,4)
   SWEP.IconLetter = "a"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 1
SWEP.Primary.Damage = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.019
SWEP.Primary.ClipSize = 13
SWEP.Primary.ClipMax = 180
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 18
SWEP.HeadDamage = 36


SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.01
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 1.5

SWEP.SpeedMult = 1.2

SWEP.RestPos = Vector(-2, -5, -1)
SWEP.RestRot = Angle(0,-3,0)
SWEP.ZoomPos = Vector(-4, 5,-5)
SWEP.ZoomRot = Angle(0,0,-60)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 1.6
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 3.2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_p228.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 62
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"

--SWEP.Tracer				= "small_tracer"
