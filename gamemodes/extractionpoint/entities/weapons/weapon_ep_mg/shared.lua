if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "shotgun"

if CLIENT then
   SWEP.PrintName			= "SSW.138 Machine Gun"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Heavy machine gun\nPenetrates thin walls\nIt's heavy design\nslows you down."
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(45,33,10)
   SWEP.LookPos = Vector(7,0,7)
   SWEP.IconLetter = "z"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 2.5
SWEP.Primary.Damage = 19
SWEP.Primary.Delay = 0.07
SWEP.Primary.Cone = 0.09
SWEP.Primary.ClipSize = 100
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 2
SWEP.Primary.MaxClips       = 2

SWEP.BodyDamage = 20
SWEP.HeadDamage = 32

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0.018
SWEP.NormalCone = 0.07
SWEP.ZoomSensitivity = 4

SWEP.SpeedMult = 0.7

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 5
SWEP.ReloadCritStart	= 3.2
SWEP.ReloadCritEnd		= 3.4
SWEP.ReloadAnimLength	= 5.6
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_AR2.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.PenTimes			= 10 -- How many yimes to jump through a brush to try to find air (Times this by PenStr to get how far through a brush a rail can travel)
SWEP.PenWalls			= 2  -- The ammount of brushes to pass through if no player or NPC is hit. (Most walls are two brushes.)
SWEP.PenStr				= 8 -- The jumps inside the wall you want to make before checking if out of the wall (Keep it between 8 - 16 , The higher the more chance for inacuricies.)

SWEP.Tracer				= "mg_tracer"


function SWEP:ShootRail( dmg, recoil, numbul, cone )

	local Dir
	local trace_normal = bit.bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, CONTENTS_DETAIL, 402653442, CONTENTS_WATER)
	local trace_walls = bit.bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_HITBOX, 402653442)
	local bul = {}
	local tr = {}
	local free = false
	local curPens = 0
	local curWalls = 0

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01

   sp = self.Owner:GetShootPos()
   Dir = (self.Owner:EyeAngles() + Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 25):Forward()


	tr.start = sp
	tr.endpos = tr.start + Dir * 16384
	tr.filter = self.Owner
	tr.mask = trace_normal

	local trace = util.TraceLine(tr)

	bul.Num = numbul
	bul.Src = sp
	bul.Dir = Dir
	bul.Spread 	= Vector(0, 0, 0)
	bul.Tracer = 1
	bul.TracerName	= self.Tracer or "Tracer"
	bul.Force	= 10
	bul.Damage = dmg
	bul.CallBack = function(att, tr, dmginfo)
		trace = tr
	end


	self.Owner:FireBullets(bul)
	ent = trace.Entity

	--if not ent:IsNPC() and not ent:IsPlayer() then
		while (curPens < self.PenTimes and not free) do
			curPens = curPens + 1
			tr.start = trace.HitPos
			tr.endpos = tr.start + (Dir * self.PenStr)
			tr.filter = self.Owner
			tr.mask = trace_walls

			trace = util.TraceLine(tr)
			tr.start = trace.HitPos
			tr.endpos = tr.start + Dir * 0.1
			tr.filter = self.Owner
			tr.mask = MASK_SHOT

			trace = util.TraceLine(tr) -- run ANOTHER trace to check whether we've penetrated a surface or not
			if not trace.Hit then
				free = true
				curWalls = curWalls + 1 -- increase the walls penertrated

				bul.Num = numbul
				bul.Src = trace.HitPos
				bul.Dir = Dir
				bul.Spread 	= Vector(0, 0, 0)
				bul.Tracer = 0
				bul.Force	= 10
				bul.Damage = dmg
				self.Owner:FireBullets(bul)

				-- Smoke trail from penertrations and succsive pens.
				tr.start = trace.HitPos  --USed for wall pen smoke trails and successive wall pens
				tr.endpos = tr.start + (Dir * 1000) --Max trace rance is shortened for successive pens
				tr.filter = self.Owner
				tr.mask = trace_normal

				trace = util.TraceLine(tr)
				ent = trace.Entity
				if SERVER then
					local ed = EffectData()
					ed:SetOrigin(trace.HitPos)
					ed:SetStart(tr.start)
					ed:SetEntity(self)
					util.Effect( "mg_tracer_wall", ed, true, true )
				end
				if (curWalls < self.PenWalls) then -- Just run a trace check incase two wall brushes are touching. (try not to make PenWalls too high)
					if not ent:IsNPC() and not ent:IsPlayer() then
						free = false
						curPens = 0
					end
				end

			end

		end
	--end
	tr.mask = trace_normal

	self.Owner:MuzzleFlash()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
end


function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, 200 )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), 200)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() then
		self:ShootRail( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone )
	else
		self:ShootRail( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone )
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
