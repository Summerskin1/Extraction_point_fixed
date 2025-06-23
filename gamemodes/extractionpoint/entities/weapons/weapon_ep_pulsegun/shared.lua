if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName			= "XP1 PulseGun"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Fires advanced energy based projectiles"
   SWEP.PrimaryInstruction = "Fire high frequency pulse"
   SWEP.SecondaryInstruction = "Fire unstable pulse core"
   SWEP.CamPos = Vector(45,25,10)
   SWEP.LookPos = Vector(3,0,6)
   SWEP.IconLetter = "e" --F is healdart
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 0.2
SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 0.09
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 42
SWEP.Primary.ClipMax = 42
SWEP.Primary.DefaultClip = 42
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 5
SWEP.Primary.MaxClips       = 5

SWEP.BodyDamage = 40
SWEP.HeadDamage = 110

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0
SWEP.NormalCone = 0
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-3.0, -6, 0.5)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 4.2
SWEP.ReloadCritStart	= 1.5
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 3
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130
--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "npc/strider/strider_minigun.wav" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_aug.mdl"
--SWEP.ViewModel			= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"

SWEP.Tracer				= "pulse_tracer"

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim =  ACT_VM_RELOAD

SWEP.Distance = 100000

function SWEP:SecondaryAttack(worldsnd)


	if not self:CanPrimaryAttack() or self.Weapon:Clip1() < 11 then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay*10 )

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		self.Weapon:EmitSound( "npc/scanner/cbot_discharge1.wav", self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		sound.Play("npc/scanner/cbot_discharge1.wav", self:GetPos(), self.Primary.SoundLevel)
	end

	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	if (!SERVER) then return end;

	local tr = self.Owner:GetEyeTrace()

	trace = util.TraceLine(tr)
	local ent = ents.Create ("ep_pulse_bomb");


 	ent.Parent = self.Owner
	ent:SetCreator(self.Owner)
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 0+self.Owner:GetAngles():Right()*13 + self.Owner:GetAngles():Up()*-4);
	local tr = self.Owner:GetEyeTrace()
	ent:SetAngles((tr.HitPos-ent:GetPos()):Angle());
	ent:Spawn();

	local phys = ent:GetPhysicsObject();
	phys:SetVelocity(ent:GetForward() * 1100)

	self:TakePrimaryAmmo( 11 )
end


function SWEP:ShootBullet( dmg, recoil, numbul, cone )
	cone = cone + (self.Weapon:Clip1()*0.001)
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01
	local bullet = {}
	bullet.Num    = 1

	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector( cone, cone, 0 )
	bullet.Tracer = 1
	bullet.TracerName = self.Tracer
	bullet.Force  = 200
	bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)

		--util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 150, 30 )
		local effectdata = EffectData()
		effectdata:SetStart( tr.HitPos )
		effectdata:SetOrigin( tr.HitPos )
		--util.Effect( "Explosion", effectdata )
	end

   self.Owner:FireBullets( bullet )
end
