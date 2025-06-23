if SERVER then
   AddCSLuaFile( "shared.lua" )
	resource.AddFile( "sound/ep/shotgun_fire_orig.wav" )
end

SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName			= "MK-900 Shotgun"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"

   SWEP.DrawCrosshair	= false

   SWEP.WeaponDesc = "Powerful slug firing pump action.\nCripples foes struck."
   SWEP.PrimaryInstruction = "Fire slug"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(40,40,10)
   SWEP.LookPos = Vector(7,0,5)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "("
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "buckshot" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 12
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.23
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 7
SWEP.Primary.ClipMax = 40
SWEP.Primary.MaxClips = 0
SWEP.Primary.Clips = 0
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 14
SWEP.HeadDamage = 32

SWEP.ScopeInTime = 0.25
SWEP.ZoomAmt = 1.15
SWEP.ZoomCone = 0.01
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 1.5

SWEP.RestPos = Vector(-5, 5, -1)
SWEP.RestRot = Angle(0,-1,-5)
SWEP.ZoomPos = Vector(-8.7, -3,0)
SWEP.ZoomRot = Angle(0,0,-15)

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
SWEP.Primary.Sound			= Sound( "ep/shotgun_fire_orig.wav" )
SWEP.Primary.Sound2			= Sound( "" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 45
SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.HasPumped			= true

SWEP.Tracer				= "boomer_tracer"

if CLIENT then

	function SWEP:DrawHUD()
		local clip = self.Weapon:Clip1()
		local ammo = self.Weapon:Ammo1()
		self:DrawAmmo(clip .. " ◊ " .. ammo)
		self:DrawCross()
	end
	function SWEP:DrawDetails(x, y, wide, tall, alpha, selected)
		--local alphamod = math.Rand(0.5,0.8) -- make it flicker.
		local alphamod = 0.7
		local dark, light
		if self.Owner:Team() == TEAM_SWAT then
			dark = Color( 30, 40, 60, alpha/2 )
			if selected then
				light = Color(170, 200, 250, alpha*alphamod)
			else
				light = Color(90, 120, 170, alpha*alphamod)
			end
		else
			dark = Color( 30, 30, 30, alpha/2 )
			if selected then
				light = Color(255, 220, 100, alpha*alphamod)
			else
				light = Color(160, 150, 70, alpha*alphamod)
			end
		end
		surface.SetDrawColor( dark )
		--surface.DrawRect(x, y, wide, tall )
		surface.SetDrawColor( dark )
		--surface.DrawOutlinedRect(x, y, wide, tall)
		if self.IconFont == "EP_Wepfont2" then
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y-25+tall*0.25, light, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y+tall*0.25, light, TEXT_ALIGN_CENTER )
		end
		local amt = self:Clip1()/self.Primary.ClipSize
		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.7, wide*0.8*amt, tall*0.1 )

		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.7, wide*0.8, tall*0.1 )

		amt = self:Ammo1()/(self.Primary.DefaultClip-self.Primary.ClipSize)
		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.8, wide*0.8*amt, tall*0.1 )

		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.8, wide*0.8, tall*0.1 )

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
	//self.HasPumped = false
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

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
	if not self.HasPumped and self:GetNextPrimaryFire() + 0.4 < CurTime() then
		if not self.dt.Reloading then
			self.HasPumped = true;
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
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

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul


   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 1
   bullet.Damage = dmg
   bullet.Callback = function(ply, tr, dmg)
	norm = tr.Normal
	dist = tr.Length

	if tr.Entity and tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() then
		if SERVER then
			player_manager.RunClass( tr.Entity, "SlowDebuff", 1.5 )
		end
	end
   end

   self.Owner:FireBullets( bullet )
   self.HasPumped = false;
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
