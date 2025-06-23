if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "shotgun"
SWEP.HoldTypeAim = "smg"

if CLIENT then
   SWEP.PrintName			= "'SpitFire' SMG"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "SMG with ricocheting rounds"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(60,40,10)
   SWEP.LookPos = Vector(12,0,5)
   SWEP.IconLetter = "q"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 1.2
SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 0.06
SWEP.Primary.Cone = 0.045
SWEP.Primary.ClipSize = 40
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 7
SWEP.Primary.MaxClips       = 7

SWEP.BodyDamage = 11
SWEP.HeadDamage = 22

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.4
SWEP.ZoomCone = 0.02
SWEP.NormalCone = 0.1
SWEP.ZoomSensitivity = 2
SWEP.defaultAcc = 0.08
SWEP.defaultZoo = 0.024

SWEP.ZoomPos = Vector(-6.5, -2, 3.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 2.1
SWEP.ReloadCritEnd		= 2.3
SWEP.ReloadAnimLength	= 3.5
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "NPC_FloorTurret.ShotSounds" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.Tracer				= "ricochet_trail"

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01

   local dir = Vector(0,0,0)
   local origin = Vector(0,0,0)
   local norm = Vector(0,0,0)
   local hitply = false


   local bullet = {}
   bullet.Num    = numbul

	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector( cone, cone, 0 )
	bullet.Tracer = 1
	bullet.TracerName = self.Tracer or "Tracer"
	bullet.Force  = 10
	bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)
		origin = tr.HitPos
		norm = tr.HitNormal
		local ang = (tr.StartPos - tr.HitPos):Angle()
		ang:RotateAroundAxis(norm,180)
		dir = ang:Forward()
		if tr.Entity:IsPlayer() then
			hitply = true
		end
	end
   self.Owner:FireBullets( bullet )

   local rico = {}
   rico.Num    = 1

	 rico.Src    = origin
	 rico.Dir    = dir
	rico.Spread = Vector( 0.1, 0.1, 0 )
	rico.Tracer = 0
	rico.TracerName = self.Tracer or "Tracer"
	rico.Force  = 10
	rico.Damage = dmg*1.5
	rico.Callback = function(att, tr, dmginfo)
		if SERVER then
			local ed = EffectData()
			ed:SetStart(tr.StartPos)
			ed:SetOrigin(tr.HitPos)
			ed:SetEntity(NULL)
			util.Effect( self.Tracer or "Tracer", ed, true, true )
		end
	end

	if !hitply then
		self.Owner:FireBullets( rico )
	end

end
