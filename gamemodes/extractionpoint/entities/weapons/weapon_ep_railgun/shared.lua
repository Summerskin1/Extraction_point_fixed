if SERVER then
	AddCSLuaFile( "shared.lua" )
	resource.AddFile( "sound/ep/railgun_charge.wav" )
	resource.AddFile( "sound/ep/railgun_fire.wav" )
	resource.AddFile( "sound/ep/railgun_fire_2.wav" )
	resource.AddFile( "sound/ep/railgun_fire_charge.wav" )
end

SWEP.HoldType = "shotgun"

if CLIENT then
   SWEP.PrintName			= "Railgun"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Penertrates any wall and\ndeals huge damage!\nDon't miss!"
   SWEP.PrimaryInstruction = "Fire a wall piercing round"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(50,40,10)
   SWEP.LookPos = Vector(12,0,7)
   SWEP.IconLetter = "r"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 5.5
SWEP.Primary.Damage = 90
SWEP.Primary.Delay = 0.9
SWEP.Primary.Cone = 0.000
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 10
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 8
SWEP.Primary.MaxClips       = 8

SWEP.BodyDamage = 90
SWEP.HeadDamage = 180

SWEP.ScopeInTime = 0.6
SWEP.ZoomAmt = 3.0
SWEP.ZoomCone = 0.00
SWEP.NormalCone = 0.005
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2
SWEP.ReloadCritStart	= 1.2
SWEP.ReloadCritEnd		= 1.3
SWEP.ReloadAnimLength	= 4
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 100

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "ep/rail_fire.wav" )
SWEP.Secondary.Sound		= Sound( "ep/rail_fire.wav" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60
SWEP.ViewModel			= "models/weapons/cstrike/c_snip_awp.mdl"
--SWEP.ViewModel			= "models/weapons/c_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"

SWEP.Tracer				= "rail_beam"

SWEP.PenTimes			= 10 -- How many yimes to jump through a brush to try to find air (Times this by PenStr to get how far through a brush a rail can travel)
SWEP.PenWalls			= 2  -- The ammount of brushes to pass through if no player or NPC is hit. (Most walls are two brushes.)
SWEP.PenStr				= 16 -- The jumps inside the wall you want to make before checking if out of the wall (Keep it between 8 - 16 , The higher the more chance for inacuricies.)

SWEP.WallUpdateTime		= 5.5
SWEP.WallLastUpdateTime = 0.0

function SWEP:ShootRail( dmg, recoil, numbul, cone )

	local Dir
	local trace_normal = bit.bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
	local trace_walls = bit.bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442)
	local bul = {}
	local tr = {}
	local free = false
	local curPens = 0
	local curWalls = 0

	if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01

   sp = self.Owner:GetShootPos()
   Dir = (self.Owner:EyeAngles() + Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 25):Forward()

	bul.Num = numbul
	bul.Src = sp
	bul.Dir = Dir
	bul.Spread 	= Vector(0, 0, 0)
	bul.Tracer = 1
	bul.TracerName	= self.Tracer or "Tracer"
	bul.Force	= 10
	bul.Damage = dmg


	self.Owner:FireBullets(bul)
	bul.Callback = nil

	tr.start = sp
	tr.endpos = tr.start + Dir * 16384
	tr.filter = self.Owner
	tr.mask = trace_normal
	tr.mins = Vector( -12, -12, -12 )
	tr.maxs = Vector( 12, 12, 12 )

	trace = util.TraceLine(tr)
	ent = trace.Entity

	--if not ent:IsNPC() and not ent:IsPlayer() then
		while (curPens < self.PenTimes and not free) do
			curPens = curPens + 1
			tr.start = trace.HitPos
			tr.endpos = tr.start + (Dir * self.PenStr)
			tr.filter = self.Owner
			tr.mask = trace_walls
			tr.mins = Vector( -12, -12, -12 )
			tr.maxs = Vector( 12, 12, 12 )

			trace = util.TraceLine(tr)
			tr.start = trace.HitPos
			tr.endpos = tr.start + Dir * 0.1
			tr.filter = self.Owner
			tr.mask = trace_normal
			tr.mins = Vector( -12, -12, -12 )
			tr.maxs = Vector( 12, 12, 12 )

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
				tr.mins = Vector( -12, -12, -12 )
				tr.maxs = Vector( 12, 12, 12 )

				trace = util.TraceLine(tr)
				ent = trace.Entity

				local ed = EffectData()
				ed:SetOrigin(trace.HitPos)
				ed:SetStart(tr.start)
				ed:SetEntity(self)
				util.Effect( "rail_beam_wall", ed, true, true )

				if (curWalls < self.PenWalls) then -- Just run a trace check incase two wall brushes are touching. (try not to make PenWalls too high)
					--if not ent:IsNPC() and not ent:IsPlayer() then
						free = false
						curPens = 0
					--end
				end

			end

		end
	--end
	tr.mask = trace_normal

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


function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end



	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, 100)
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), 140)
	end

	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() then
		self:ShootRail( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone )
	else
		self:ShootRail( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone )
	end
	self.Owner:LagCompensation( false )
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)

	self.Owner:MuzzleFlash()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
end
