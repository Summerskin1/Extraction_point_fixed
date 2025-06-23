if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "duel"

if CLIENT then
   SWEP.PrintName			= "Dual 16-HPs"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   
   SWEP.DrawCrosshair   = false
   SWEP.WeaponDesc = "Dual machine pistols\nDual crosshair's"
   SWEP.PrimaryInstruction = "Fire left pistol"
   SWEP.SecondaryInstruction = "Fire right pistol"
   SWEP.CamPos = Vector(0,0,40)
   SWEP.LookPos = Vector(0,0,1)
   SWEP.IconLetter = "s"
   
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 1.5
SWEP.Primary.Damage = 20
SWEP.Primary.Delay = 0.12
SWEP.Primary.Cone = 0.12
SWEP.Primary.ClipSize = 18
SWEP.Secondary.ClipSize = 18
SWEP.Secondary.DefaultClip = 18
SWEP.Primary.DefaultClip = 18
SWEP.Primary.ClipMax = 180
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 18
SWEP.HeadDamage = 36

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.5
SWEP.ZoomCone = 0.015
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-5.5, -4, 1)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 4
SWEP.ReloadCritStart	= 1.6
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 4
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_SMG1.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 80
SWEP.ViewModel			= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite.mdl"

SWEP.PrimaryAnim = ACT_VM_SECONDARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK

SWEP.Tracer = "tracer"

if CLIENT then

CROSSHAIR_GHOST = Color( 200, 150, 50, 150 )
CROSSHAIR_SWAT = Color( 150, 150, 200, 150 )

	function SWEP:DrawCross()
	--Won't be here forever, just testing.
		self:DrawFastReloadBar()
	
		--gets the center of the screen
		--set the drawcolor
		local gap = 0
		--local gap = self.Primary.Cone*ScrW()/2 + math.Clamp(self.Weapon:GetNextPrimaryFire() - CurTime(), 0, 20)*50
		if self:GetScoped() then
			gap = self.ZoomCone*ScrW()/(2/self.ZoomAmt)
		else
			gap = self.NormalCone*ScrW()/2
		end
		local length = gap + ScrW()/256
		
		--Turn them into ints to prevent ugly drawing.
		gap = math.floor(gap)
		length = math.floor(length)
		
		--draw the crosshair
		if self.Owner:Team() == TEAM_GHOST then
			surface.SetDrawColor( CROSSHAIR_GHOST )
			local offset = math.floor(ScrW()/256)
			gap = math.Clamp(gap, offset*2.1, 500)
			local width = math.floor(math.Clamp(gap/2, offset, 500))
			local x = math.floor(ScrW() / 2)-math.floor(ScrW() / 100)
			local y = math.floor(ScrH() / 2)
			local leftpos = x - gap
			local rightpos = x + gap
			--Left
			surface.DrawLine( leftpos, y, leftpos - offset, y )
			surface.DrawLine( leftpos, y + width, leftpos, y - width )
			surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
			surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )
				
			--Right
			surface.DrawLine( rightpos, y, rightpos + offset, y )
			surface.DrawLine( rightpos, y + width, rightpos, y - width )
			surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
			surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )
			local x = math.floor(ScrW() / 2)+math.floor(ScrW() / 100)
			local y = math.floor(ScrH() / 2)
			local leftpos = x - gap
			local rightpos = x + gap
			surface.DrawLine( leftpos, y, leftpos - offset, y )
			surface.DrawLine( leftpos, y + width, leftpos, y - width )
			surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
			surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )
				
			--Right
			surface.DrawLine( rightpos, y, rightpos + offset, y )
			surface.DrawLine( rightpos, y + width, rightpos, y - width )
			surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
			surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )
		else
			surface.SetDrawColor( CROSSHAIR_SWAT )
			local x = math.floor(ScrW() / 2)-math.floor(ScrW() / 100)
			local y = math.floor(ScrH() / 2)
			surface.DrawLine( x - gap, y, x - length, y )
			surface.DrawLine( x, y + gap, x, y + length )
			surface.DrawLine( x + gap, y, x + length, y )
			local x = math.floor(ScrW() / 2)+math.floor(ScrW() / 100)
			local y = math.floor(ScrH() / 2)
			surface.DrawLine( x - gap, y, x - length, y )
			surface.DrawLine( x, y + gap, x, y + length )
			surface.DrawLine( x + gap, y, x + length, y )
		end
		
	end

	function SWEP:DrawHUD()
		local clip = self.Weapon:Clip1()
		local clip2= self.Weapon:Clip2()
		self:DrawAmmo(clip .. " ◊ " .. clip2)
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
		surface.DrawRect(x+wide*0.1, y+tall*0.7, wide*0.8*amt, tall*0.05 )
		
		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.7, wide*0.8, tall*0.05 )
		amt = self:Clip2()/self.Primary.ClipSize
		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.75, wide*0.8*amt, tall*0.05 )
		
		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.75, wide*0.8, tall*0.05 )
		
		if self.Primary.MaxClips < 9 then
			for i=0,(self.Primary.Clips-1) do
				if self.Primary.Clips > i then
					surface.SetDrawColor( light )
					surface.DrawRect(x+tall*(i/10)+wide*0.1, y+tall*0.8, tall*0.1, tall*0.1 )
				end
				surface.SetDrawColor( dark )
				surface.DrawOutlinedRect(x+tall*(i/10)+wide*0.1, y+tall*0.8, tall*0.1, tall*0.1 )
			end
		else
		
		end
		
	end
end

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay/2 )
	
	if not self:CanPrimaryAttack() then return end
	
	self.ViewModelFlip		= true
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone, true )
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	self.Owner:GetViewModel():SetPlaybackRate(2)
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

function SWEP:SecondaryAttack(worldsnd)

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay/2 )
	
	if not self:CanSecondaryAttack() then return end
	
	self.ViewModelFlip		= false
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone, false )
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	self.Owner:GetViewModel():SetPlaybackRate(2)
	self.Owner:LagCompensation( false )
	local recoil = self.Primary.Recoil
	if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	self:TakeSecondaryAmmo( 1 )
end

function SWEP:CanSecondaryAttack()
   if self.Weapon:Clip2() <= 0 then 
	   if CLIENT and LocalPlayer() == self.Owner then
		  self:EmitSound( self.DrySound )
		  self:SetNextSecondaryFire(CurTime()+1)
	   end
      return false
   end
   if self.Reloading then
      return false
	 end
   return true
end

function SWEP:CanPrimaryAttack()
   if self.Weapon:Clip1() <= 0 then 
	   if CLIENT and LocalPlayer() == self.Owner then
		  self:EmitSound( self.DrySound )
		  self:SetNextPrimaryFire(CurTime()+1)
	   end
      return false
   end
   if self.Reloading then
      return false
	 end
   return true
end

function SWEP:FinishReload()
	self.Reloading = false
	self:SetClip1(self.Primary.ClipSize)
	self:SetClip2(self.Primary.ClipSize)
	self.ReloadFailed = false
	self.Primary.Clips = self.Primary.Clips - 1
	self.FinishReloadTime = CurTime()
end
function SWEP:ShootBullet( dmg, recoil, numbul, cone, left )


   --self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end
   
   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   

   bullet.Src    = self.Owner:GetShootPos()
   
	local dir = self.Owner:GetAimVector()
	local ang = dir:Angle()
	local flatang = Angle(0,ang.y,0)
	flatang.p = 0
   if left then
		flatang= flatang+(Angle(0,1.5,0))
		--bullet.Dir    = (self.Owner:GetAimVector():Angle()):RotateAroundAxis( self.Owner:GetAimVector():GetNormal(), 5 ):Forward()
   else
		flatang= flatang+(Angle(0,-1.5,0))
		--bullet.Dir    = self.Owner:GetAimVector()+Angle(0,-1.5,0):Forward()
   end
   flatang:RotateAroundAxis( ang:Right(), -ang.p ) 
   bullet.Dir = flatang:Forward()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 1
   bullet.Damage = dmg

   self.Owner:FireBullets( bullet )
end