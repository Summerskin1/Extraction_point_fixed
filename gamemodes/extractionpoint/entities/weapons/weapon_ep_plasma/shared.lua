if SERVER then
	AddCSLuaFile( "shared.lua" )
	resource.AddFile( "sound/ep/plasma_bounce.wav" )
	resource.AddFile( "sound/ep/plasma_fire.wav" )
	resource.AddFile( "sound/ep/plasma_hit.wav" )
	resource.AddFile( "sound/ep/plasma_phaseout.wav" )
end

SWEP.HoldType			= "physgun"

if CLIENT then
   SWEP.PrintName			= "Plasma Gun"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 0

   SWEP.Icon = "VGUI/ep/sample"

   SWEP.DrawCrosshair   = false

   SWEP.WeaponDesc = "Fires plasma projectiles the deal\nimpact and splash damage.\nBounces off walls!"
   SWEP.PrimaryInstruction = "Fire Plasma Ball"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "!"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 8.2
SWEP.Primary.Damage = 38
SWEP.Primary.Delay = 0.3
SWEP.Primary.Cone = 0.019
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 180
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 38
SWEP.HeadDamage = 76

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.015
SWEP.NormalCone = 0.025
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-5.5, -4, 1)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 5
SWEP.ReloadCritStart	= 0.3
SWEP.ReloadCritEnd		= 0.4
SWEP.ReloadAnimLength	= 3.2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "ep/plasma_fire.wav" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel			= "models/weapons/w_physics.mdl"

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end

	if (!SERVER) then return end;

	sp = self.Owner:GetShootPos()
	Dir = self.Owner:GetAimVector():Angle():Forward()
	local tr ={}
	tr.start = sp
	tr.endpos = tr.start + Dir * 4
	tr.filter = self.Owner
	tr.mask = trace_normal

	trace = util.TraceLine(tr)

	local ent = ents.Create ("ep_plasma_projectile");

	ent.Parent = self.Owner
	ent:SetPos(trace.HitPos+(Dir*-1));
	ent:SetAngles(self.Owner:GetAimVector():Angle());
	ent:Spawn();

	local phys = ent:GetPhysicsObject();
	phys:SetVelocity(ent:GetForward() * 3200)

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
