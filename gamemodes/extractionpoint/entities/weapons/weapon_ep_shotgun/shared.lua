if SERVER then
   AddCSLuaFile( "shared.lua" )
	resource.AddFile( "sound/ep/shotgun_fire2.wav" )
end

SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName			= "X-2 Shotgun"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   
   SWEP.DrawCrosshair	= false
   
   SWEP.WeaponDesc = "Powerful Pump-Action shotgun"
   SWEP.PrimaryInstruction = "Fire shell"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(40,40,10)
   SWEP.LookPos = Vector(7,0,5)
   SWEP.IconLetter = "k"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "buckshot" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 20
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 13
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 0.08
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 30
SWEP.Primary.MaxClips = 0
SWEP.Primary.Clips = 0
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 14
SWEP.HeadDamage = 32

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.1
SWEP.ZoomCone = 0.03
SWEP.NormalCone = 0.11
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-5.7, -10, 2)

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
SWEP.Primary.Sound			= Sound( "ep/shotgun_fire2.wav" )
SWEP.Primary.Sound2			= Sound( "" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Tracer				= "shotgun_tracer"

if CLIENT then
	function SWEP:DrawHUD()
		local clip = self.Weapon:Clip1()
		local ammo = self.Weapon:Ammo1()
		self:DrawAmmo(clip .. " ◊ " .. ammo)
		self:DrawCross()
	end	
end

function SWEP:Reload()
	if self.dt.Reloading then return end

	if self:GetScoped( ) then
		self:SecondaryAttack()
	end
	
	if not IsFirstTimePredicted() then return end
   
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
	  
		if self:StartReload() then
			return
		end
	end
end

function SWEP:StartReload()
	if self.dt.Reloading then
			return false
	end

	if not IsFirstTimePredicted() then return false end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	   
	local ply = self.Owner
	   
	if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
		return false
	end

	local wep = self.Weapon
	   
	if wep:Clip1() >= self.Primary.ClipSize then 
		return false 
	end

	wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

	self.reloadtimer =	CurTime() + wep:SequenceDuration()

	self.dt.Reloading = true

	return true
end

function SWEP:PerformReload()
	local ply = self.Owner
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*1.2 )

	if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

	local wep = self.Weapon

	if wep:Clip1() >= self.Primary.ClipSize then return end

	self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
	self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )

	wep:SendWeaponAnim(ACT_VM_RELOAD)

	self.reloadtimer = CurTime() + wep:SequenceDuration()
end

function SWEP:FinishReload()
	self.dt.Reloading = false
	self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   
	self.reloadtimer = CurTime() + self.Weapon:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound( "Weapon_Shotgun.Empty" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		return false
	end
	return true
end

function SWEP:Think()
	if self.dt.Reloading and IsFirstTimePredicted() then
		if self.Owner:KeyDown(IN_ATTACK) then
			self:FinishReload()
			return
		end
	  
		if self.reloadtimer <= CurTime() then
	
			if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self:FinishReload()
			elseif self.Weapon:Clip1() < self.Primary.ClipSize then
				self:PerformReload()
			else
				self:FinishReload()
			end
			return			  
		end
	end
end

function SWEP:Deploy()
	self.dt.Reloading = false
	self.reloadtimer = 0
	self:SetScoped( false )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW ) 
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
		end
	end
end



function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	local vm = self.Owner:GetViewModel()
	--vm:SetPlaybackRate(0.7)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end
   
   numbul = numbul or 1
   cone	  = cone   or 0.01

   local bullet = {}
   bullet.Num	 = 1

   bullet.Src	 = self.Owner:GetShootPos()
   if self:GetScoped() then
		bullet.Dir	  = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0, 0, 0 )
   else
		bullet.Dir	  = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.NormalCone, self.NormalCone, 0 )
   end
   local norm
   local dist
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force	 = 3
   bullet.Damage = dmg
   bullet.Callback = function(ply, tr, dmg)
	norm = tr.Normal
	dist = tr.Length
   end
   self.Owner:FireBullets( bullet )
   local bul = {}
	   bul.Num	 = numbul-1

	   bul.Src	 = self.Owner:GetShootPos()
		--bul.Dir	  = self.Owner:GetAimVector()
	  bul.Dir	  = norm
	   bul.Spread = Vector( self.Primary.Cone, self.Primary.Cone, 0 )
	   bul.Tracer = 1
	   bul.TracerName = self.Tracer or "tracer"
	   bul.Force	 = 10
	   bul.Damage = dmg
   self.Owner:FireBullets(bul)
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 1, "Reloading")
	self:NetworkVar( "Bool", 0, "Scoped" )
end
	--scales damage based on distance
function SWEP.ScaleDamage( ply, hitgroup, dmginfo )
	if not SERVER or not dmginfo:IsBulletDamage() then return end
	
	local att = dmginfo:GetAttacker()
	if not att or not att:IsPlayer() then return end
	
	local wep = att:GetActiveWeapon()
	if not wep or wep:GetClass() ~= "weapon_ep_shotgun" then return end
	
	local len = ply:GetPos():Distance( att:GetPos() )
	local scale = math.max( math.min( 1.0, ( 2000 - len )/1000 ), 0.3 )
	dmginfo:ScaleDamage( scale )
end
hook.Add( "ScalePlayerDamage", "GaussScaleDamage", SWEP.ScaleDamage )
