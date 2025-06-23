if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "shotgun"
SWEP.HoldTypeAim = "smg"

if CLIENT then
   SWEP.PrintName			= ".MKV SMG"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Standard issue sub-machine gun"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(60,40,10)
   SWEP.LookPos = Vector(12,0,5)
   SWEP.IconLetter = "x"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 0.5
SWEP.Primary.Damage = 18
SWEP.Primary.Delay = 0.05
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 32
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 11
SWEP.HeadDamage = 22

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.4
SWEP.ZoomCone = 0.024
SWEP.NormalCone = 0.04
SWEP.ZoomSensitivity = 2
SWEP.defaultAcc = 0.06
SWEP.defaultZoo = 0.024

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 2.1
SWEP.ReloadCritEnd		= 2.3
SWEP.ReloadAnimLength	= 3.2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_MAC10.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5.mdl"

SWEP.Tracer				= "mp5_tracer"

SWEP.LastFire			= 0
SWEP.CurrentAccuracy		= 0.2

function SWEP:Think()
	if !(CurTime() < self.LastFire+self.Primary.Delay*5) then
		self.CurrentAccuracy = math.Clamp(self.CurrentAccuracy-0.1,0.2,3)
	end
	self.NormalCone = self.defaultAcc*self.CurrentAccuracy
	self.ZoomCone = self.defaultZoo*self.CurrentAccuracy
	if !self.Owner:KeyDown( IN_RELOAD ) then
		self.ReloadDown = false
	end
	if self.Reloading == true then
		if CLIENT then
			if self.ReloadLength < self.DrawTime - self.ReloadStart then
				net.Start("ReloadResult")
				net.WriteEntity(self.Weapon)
				net.WriteBit(true)
				net.SendToServer()
				self.Weapon:CritReload()
			end
		end
	end
end

function SWEP:PrimaryAttack(worldsnd)

	if not self:CanPrimaryAttack() then return end
	if IsFirstTimePredicted() then
	end
	self.CurrentAccuracy = math.Clamp(self.CurrentAccuracy+0.08,0,2)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		if self.Primary.Sound2 then
			self.Weapon:EmitSound( self.Primary.Sound2, self.Primary.SoundLevel )
		end
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		if self.Primary.Sound2 then
			sound.Play(self.Primary.Sound2, self:GetPos(), self.Primary.SoundLevel)
		end
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() then
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone )
	else
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone )
	end
	self.Owner:LagCompensation( false )
	local recoil = self.Primary.Recoil*self.CurrentAccuracy
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
	self.LastFire = CurTime()
end
