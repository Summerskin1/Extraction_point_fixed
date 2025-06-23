if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"
SWEP.HoldTypeAim = "revolver"

if CLIENT then
   SWEP.PrintName			= "Machine Pistol"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "A fast firing machine pistol"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(50,30,10)
   SWEP.LookPos = Vector(12,0,3)
   SWEP.IconLetter = "d"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 0.9
SWEP.Primary.Damage = 18
SWEP.Primary.Delay = 0.04
SWEP.Primary.Cone = 0.028
SWEP.Primary.ClipSize = 20
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 4
SWEP.Primary.MaxClips       = 4

SWEP.BodyDamage = 8
SWEP.HeadDamage = 16

SWEP.ScopeInTime = 0.15
SWEP.ZoomAmt = 1.2
SWEP.ZoomCone = 0.016
SWEP.NormalCone = 0.028
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-6.5, 1, -6.2)
SWEP.ZoomRot = Angle(-10,0,-20)

SWEP.RestPos = Vector(-3.5, 1, -3.2)
SWEP.RestRot = Angle(-5,0,-10)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 1.8
SWEP.ReloadCritStart	= 1.0
SWEP.ReloadCritEnd		= 1.15
SWEP.ReloadAnimLength	= 2.0
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_glock.Single" )
SWEP.Primary.Sound2			= Sound( "Weapon_usp.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() then
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone+(self.Weapon:Clip1()*0.005) )
	else
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone+(self.Weapon:Clip1()*0.005) )
	end
	self.Owner:LagCompensation( false )
	local recoil = self.Primary.Recoil
	if self:GetScoped() then
		recoil = recoil/2
	end
	if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	self:TakePrimaryAmmo( 1 )
end
