if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "smg"

if CLIENT then
   SWEP.PrintName			= "Prism Beam"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc = "Fires an incredibly accurate beam\nalternatively a deadly scatter shot"
   SWEP.PrimaryInstruction = "Fire an accurate beam"
   SWEP.SecondaryInstruction = "Fire a fragmented beam"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.CamPos = Vector(-60,-40,10)
   SWEP.LookPos = Vector(5,0,2.5)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = ":"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 3.5
SWEP.Primary.Damage = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 4
SWEP.Primary.MaxClips       = 4

SWEP.BodyDamage = 21
SWEP.HeadDamage = 24

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.0
SWEP.ZoomCone = 0.09
SWEP.NormalCone = 0.01
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 2
SWEP.ReloadCritEnd		= 2.2
SWEP.ReloadAnimLength	= 1.5
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "npc/combine_gunship/attack_start2.wav" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60
SWEP.ViewModel			= "models/weapons/c_irifle.mdl"
SWEP.WorldModel			= "models/weapons/w_irifle.mdl"

SWEP.Tracer				= "laser"

if CLIENT then

	function SWEP:DrawHUD()
		self:DrawAmmo()
		self:DrawCross()
		
		local gap = self.ZoomCone*ScrW()/(2/self.ZoomAmt)
		
		--Turn them into ints to prevent ugly drawing.
		gap = math.floor(gap)
		
		--draw the second crosshair
		
		local dark = Color(80,80,80,255)
		local x = math.floor(ScrW() / 2)
		local y = math.floor(ScrH() / 2)
		local offset = math.floor(ScrW()/256)
		gap = math.Clamp(gap, offset*2.1, 500)
		local width = math.floor(math.Clamp(gap/2, offset, 500))
		local leftpos = math.floor(x - gap)
		local rightpos = math.floor(x + gap)
		
		local color = CROSSHAIR_GHOST
		if self.Owner:Team() == TEAM_SWAT then
		color = CROSSHAIR_SWAT
		end
	
		--Left
		draw.RoundedBox( 1, leftpos-offset-1, y - 1, offset+2, 3, color ) 
		draw.RoundedBox( 1, leftpos-1, y - width - 1, 3, width*2+2, color ) 
		draw.RoundedBox( 1, leftpos-1, y - width - 1, offset+2, 3, color ) 
		draw.RoundedBox( 1, leftpos-1, y + width - 1, offset+2, 3, color ) 
				
		surface.SetDrawColor( dark )
		surface.DrawLine( leftpos, y, leftpos - offset, y )
		surface.DrawLine( leftpos, y + width, leftpos, y - width )
		surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
		surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )
		
		--Right
		draw.RoundedBox( 1, rightpos-1, y - 1, offset+2, 3, color ) 
		draw.RoundedBox( 1, rightpos-1, y - width - 1, 3, width*2+2, color ) 
		draw.RoundedBox( 1, rightpos-offset-1, y - width - 1, offset+2, 3, color ) 
		draw.RoundedBox( 1, rightpos-offset-1, y + width - 1, offset+3, 3, color ) 
				
		surface.SetDrawColor( dark )
		surface.DrawLine( rightpos, y, rightpos + offset, y )
		surface.DrawLine( rightpos, y + width, rightpos, y - width )
		surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
		surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )
		
		--Centre
		if self.Owner:Team() == TEAM_GHOST then
			draw.RoundedBox( 2, x-2, y-2, 5, 5, color ) 
			draw.RoundedBox( 2, x-1, y-1, 3, 3, dark )
		else
			draw.RoundedBox( 2, x-2, y-2, 5, 5, dark ) 
			draw.RoundedBox( 2, x-1, y-1, 3, 3, color )
		end
	end
	
end

--[[function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end
   
   numbul = numbul or 1
   cone   = cone   or 0.01
	cosmult = math.Rand(3,7)
	sinmult = math.Rand(3,7)
	cosmod = math.Rand(0,7)
	sinmod = math.Rand(0,7)
	for bul=1,numbul do
	   local bullet = {}
	   bullet.Num    = 1
	   

	   bullet.Src    = self.Owner:GetShootPos()
	   xmod = cone*math.cos(sinmod+(bul/12)*sinmult)
	   ymod = cone*math.cos(cosmod+(bul/12)*cosmult)
	   zmod = cone*math.cos((bul/10)*cosmult)
	   bullet.Dir    = (self.Owner:GetAimVector():Angle()+Angle(xmod*50,ymod*50,0)):Forward()
	   bullet.Spread = Vector( 0, 0, 0 )
	   bullet.Tracer = 1
	   bullet.TracerName = self.Tracer or "Tracer"
	   bullet.Force  = 10
	   bullet.Damage = dmg
		
	   self.Owner:FireBullets( bullet )
   end
end]]--

function SWEP:SecondaryAttack(worldsnd)

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay*5 )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*5 )
	
	if not self:CanSecondaryAttack() then return end
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		self:EmitSound(Sound("npc/dog/dog_pneumatic1.wav"),100,math.random(130,150)) 
		self:EmitSound(Sound("weapons/ar2/fire1.wav"),100,math.random(130,150)) 
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		sound.Play(Sound("npc/dog/dog_pneumatic1.wav"), self:GetPos(), self.Primary.SoundLevel)
		sound.Play(Sound("weapons/ar2/fire1.wav"), self.Primary.SoundLevel)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	self:ShootBullet( self.Primary.Damage*0.7, self.Primary.Recoil, 5, self.ZoomCone )
	self.Owner:LagCompensation( false )
	local recoil = self.Primary.Recoil
	recoil = recoil*5
	if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	self:TakePrimaryAmmo( 5 )
end

function SWEP:CanSecondaryAttack()

   if self.Weapon:Clip1() < 5 then 
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   if self.Reloading then
      self:DryFire(self.SetNextPrimaryFire)
      return false
	 end
   return true
end