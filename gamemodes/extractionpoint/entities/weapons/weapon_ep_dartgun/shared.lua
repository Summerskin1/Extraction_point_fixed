if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"
SWEP.HoldTypeAim = "revolver"
if CLIENT then
   SWEP.PrintName			= "HE-12 Launcher"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 0

   SWEP.Icon = "VGUI/ep/sample"

   SWEP.DrawCrosshair   = false
   SWEP.WeaponDesc = "Fires explosive darts that stick\nto surfaces and detonate after\na few seconds"
   SWEP.PrimaryInstruction = "Fire darts"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(-20,-30,5)
   SWEP.LookPos = Vector(0,0,-1)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "%"

end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 4
SWEP.Primary.Damage = 38
SWEP.Primary.Delay = 0.12
SWEP.Primary.Cone = 0.019
SWEP.Primary.ClipSize = 5
SWEP.Primary.ClipMax = 180
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 4
SWEP.Primary.MaxClips       = 4

SWEP.BodyDamage = 38
SWEP.HeadDamage = 76

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.015
SWEP.NormalCone = 0.025
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-2, 4, 2)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2
SWEP.ReloadCritStart	= 0.8
SWEP.ReloadCritEnd		= 1.0
SWEP.ReloadAnimLength	= 2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_SMG1.Double" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end


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
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	if (!SERVER) then return end;

	local ent = ents.Create ("ep_dart");

	ent.Parent = self.Owner
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 24);
	ent:SetAngles(self.Owner:GetAimVector():Angle());
	ent:Spawn();

	local phys = ent:GetPhysicsObject();
	if self:GetScoped() then
		phys:SetVelocity(ent:GetForward() * 2200+VectorRand()*50)
	else
		phys:SetVelocity(ent:GetForward() * 2200+VectorRand()*150)
	end
	self:TakePrimaryAmmo( 1 )
end
