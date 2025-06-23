if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "shotgun"

if CLIENT then
   SWEP.PrintName			= "'Vector' AR"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Fires bullets faster the\nlonger you hold the trigger"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(40,30,10)
   SWEP.LookPos = Vector(2,0,6)
   SWEP.IconLetter = "w"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 3
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.16
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 11
SWEP.HeadDamage = 22

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.4
SWEP.ZoomCone = 0.01
SWEP.NormalCone = 0.05
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-4, -2, 1)

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
SWEP.Primary.Sound			= Sound( "Weapon_Famas.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

--SWEP.Tracer				= "small_tracer"

SWEP.LastFire			= 0
SWEP.CurrentDelay		= SWEP.Primary.Delay


function SWEP:PrimaryAttack(worldsnd)

	if not self:CanPrimaryAttack() then return end
	if IsFirstTimePredicted() then
		if CurTime() < self.LastFire+self.Primary.Delay*1.1 then
			self.CurrentDelay = math.Clamp(self.CurrentDelay-0.01,0.08,1)
		else
			self.CurrentDelay = self.Primary.Delay
		end
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.CurrentDelay )

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
	self.LastFire = CurTime()
end
