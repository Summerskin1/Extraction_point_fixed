
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

---- Extraction Point Fields

SWEP.BodyDamage = 1
SWEP.HeadDamage = 1

SWEP.ScopeInTime = 1
SWEP.ZoomAmt = 1
SWEP.ZoomCone = 1
SWEP.ZoomMoveSpeed = 150
SWEP.NormalCone = 0
SWEP.ZoomSensitivity = 1

SWEP.ZoomPos = Vector(-5.5, -4, 1)

SWEP.DrySound = Sound( "Weapon_Pistol.Empty" )

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2
SWEP.ReloadCritStart	= 0.2
SWEP.ReloadCritEnd		= 1.8
SWEP.ReloadAnimLength	= 1
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE


if CLIENT then  
   SWEP.Icon = "VGUI/ep/sample" -- placeholder
end

---- Extraction Point SWEP STUFF

SWEP.Base				= "weapon_base"

if CLIENT then
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.UseHands			= true
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= ""

SWEP.Category           = "ep"
SWEP.Spawnable          = false
SWEP.AdminSpawnable     = false

SWEP.IsGrenade = false

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Primary.Sound          = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil         = 15.5
SWEP.Primary.Damage         = 1
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 3.15

SWEP.Primary.ClipSize       = -1
SWEP.Primary.Clips       	= 5
SWEP.Primary.MaxClips       = 5
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipMax        = -1

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipMax      = -1

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4

CROSSHAIR_GHOST = Color( 200, 150, 50, 150 )
CROSSHAIR_SWAT = Color( 150, 150, 200, 150 )

--HUD Materials
if CLIENT then
	local params = {
		["$basetexture"] = "VGUI/ammo_icons/hud_ammo_clip_full",
		["$additive"] = 1,
		["$nocull"] = 1,
		["$translucent"] = 1,
		["$softedges"] = 1,
		["$edgesofsoftnessstart"] = 0.6,
		["$edgesofsoftnessend"] = 0.2,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1
	}
	SWEP.ClipFull 			= CreateMaterial("EP_ClipFull","UnlitGeneric",params)

	local params = {
		["$basetexture"] = "VGUI/ammo_icons/hud_ammo_clip_empty",
		["$additive"] = 1,
		["$nocull"] = 1,
		["$translucent"] = 1,
		["$softedges"] = 1,
		["$edgesofsoftnessstart"] = 0.6,
		["$edgesofsoftnessend"] = 0.2,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1
	}
	SWEP.ClipEmpty 			= CreateMaterial("EP_ClipEmpty","UnlitGeneric",params)
end
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD


-- crosshair
if CLIENT then

	function SWEP:DrawClips(x, y)
		//CLIPS CODE//
		if self.Owner:Team() == TEAM_GHOST then
			surface.SetDrawColor(CROSSHAIR_GHOST)
		else
			surface.SetDrawColor(CROSSHAIR_SWAT)
		end
			
		offset = ScrW()/128
		clipwidth = ScrW()/64
		if self.Primary.Clips > 5 then
			draw.DrawText( "x"..self.Primary.Clips,"EPAmmo", x + offset*2, y + offset, Color(220,220,220), TEXT_ALIGN_LEFT )
			surface.SetMaterial( self.ClipFull )
			surface.DrawTexturedRect(x + offset , y + offset, clipwidth, clipwidth )
		else
			for i=1,self.Primary.MaxClips do
				if i<=self.Primary.Clips then
					surface.SetMaterial( self.ClipFull )
				else
					surface.SetMaterial( self.ClipEmpty )
				end
				if i <= 5 then
					surface.DrawTexturedRect(x + ((offset)*i) , y + offset, clipwidth, clipwidth )
				end
			end
		end
	end
	
	function SWEP:DrawFastReloadBar()
		
		local critstart = (self.ReloadCritStart/self.ReloadLength)*self.ReloadWidth
		local critlength = ((self.ReloadCritEnd-self.ReloadCritStart)/self.ReloadLength)*self.ReloadWidth
		local reloadtime = 0
		local point = ((CurTime()-self:GetReloadstart())/self.ReloadLength)*self.ReloadWidth
		local x, y = ScrW() / 2.0, ScrH() / 2.0
		local boxwidth = 143
		//RELOADING BAR//

		if self.Reloading == true then

			x = ScrW()/2 - self.ReloadWidth/2
			y = ScrH()/2 + ScrH()/10
		
			surface.SetDrawColor( 220, 220, 220, 255)
			surface.DrawRect(x-1, y-1, self.ReloadWidth+2, 22 )
			if self.ReloadFailed == false then
				surface.SetDrawColor( 45, 45, 45, 255)
			else
				surface.SetDrawColor( 100+30*math.sin(CurTime()*20), 45, 45, 255)
				point = ((CurTime()-self:GetReloadstart()+self.ReloadLength)/(self.ReloadLength*2))*self.ReloadWidth
			end
			surface.DrawRect(x , y, self.ReloadWidth, 20 )

			surface.SetDrawColor( 170, 170, 170, 255)
			surface.DrawRect(x+critstart , y+2, critlength, 16 )
			if point < self.ReloadWidth then
				surface.SetDrawColor( 220, 220, 220, 255)
				surface.DrawRect(x+point , y+1, 2, 18 )
			end
		end

		//RELOADEND//
		if self.Reloading == false then

			x = ScrW()/2 - self.ReloadWidth/2
			y = ScrH()/2 + ScrH()/10
			
			local redmod = 0
			local whitemod = 0
			local alphamod = math.Clamp((self.FinishReloadTime+0.5-CurTime())*2, 0, 255)

			if self.LastReload == 0 then //Crit
				whitemod = 100
			end
			if self.LastReload == 1 then //Fail
				redmod = 55+30*math.sin(CurTime()*20)
			end

			surface.SetDrawColor( (220+redmod+whitemod)*alphamod, (220+whitemod)*alphamod, (220+whitemod)*alphamod, 255*alphamod)
			surface.DrawOutlinedRect(x-1, y-1, self.ReloadWidth+2, 22 )

			surface.SetDrawColor( (45+redmod+whitemod)*alphamod, (45+whitemod)*alphamod, (45+whitemod)*alphamod, 122*alphamod)
			surface.DrawRect(x , y, self.ReloadWidth, 20 )

			surface.SetDrawColor( (80+redmod+whitemod)*alphamod, (80+whitemod)*alphamod, (80+whitemod)*alphamod, 122*alphamod)
			surface.DrawRect(x+critstart , y+2, critlength, 16 )
			if self.LastReload == 0 then
				surface.SetDrawColor( (220+redmod+whitemod)*alphamod, (220+whitemod)*alphamod, (220+whitemod)*alphamod, 122*alphamod)
				surface.DrawRect(x+self.SuccessPoint , y+1, 2, 18 )
			end
		end
	end
	function SWEP:DrawCross()
	--Won't be here forever, just testing.
		self:DrawClips(ScrW()-ScrW()/8, ScrH()-ScrH()/8)
	
		--gets the center of the screen
		local x = math.floor(ScrW() / 2)
		local y = math.floor(ScrH() / 2)
		 
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
			if self:GetScoped( ) then
				local offset = math.floor(ScrW()/256)
				gap = math.Clamp(gap, offset*2.1, 500)
				local width = math.floor(math.Clamp(gap/2, offset, 500))
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
				
				--Centre
				draw.RoundedBox( 2, x-1, y-1, 3, 3, CROSSHAIR_GHOST ) 
			else
				local offset = math.floor(ScrW()/256)
				gap = math.Clamp(gap, offset*2.1, 500)
				local width = math.floor(math.Clamp(gap/2, offset, 500))
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
			end
		else
			surface.SetDrawColor( CROSSHAIR_SWAT )
			if self:GetScoped( ) then
				surface.DrawLine( x - gap, y, x - length, y )
				surface.DrawLine( x, y + gap, x, y + length )
				surface.DrawLine( x + gap, y, x + length, y )
				draw.RoundedBox( 2, x-1, y-1, 3, 3, CROSSHAIR_SWAT ) 
			else
				surface.DrawLine( x - gap, y, x - length, y )
				surface.DrawLine( x, y + gap, x, y + length )
				surface.DrawLine( x + gap, y, x + length, y )
			end
		end
		
	end

	function SWEP:DrawHUD()
		self:DrawCross()
	end
end

-- Shooting functions largely copied from weapon_cs_base
function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() then return end
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
	if self:GetScoped() then
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone )
	else
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone )
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

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() then return end
	if self:GetScoped( ) then
		self.Owner:SetFOV(75, self.ScopeInTime)
		self.Owner:SetRunSpeed(self.Owner:GetRunSpeed()*self.ZoomAmt)
		self:SetScoped( false )
	else
		self.Owner:SetFOV(math.floor(75/self.ZoomAmt), self.ScopeInTime)
		self.Owner:SetRunSpeed(self.Owner:GetRunSpeed()/self.ZoomAmt)
		self:SetScoped( true )
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.ScopeInTime)
end

function SWEP:AdjustMouseSensitivity()
	if self:GetScoped( ) then
		return 1/(self.ZoomAmt*self.ZoomSensitivity)
	else
		return 1
	end
end

function SWEP:Deploy()
	self:SetScoped( false )
end

function SWEP:Reload()
	if self:GetScoped( ) then
		self:SecondaryAttack()
	end
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Primary.Clips > 0 ) then
 
		self:DefaultReload( ACT_VM_RELOAD )
		self.Primary.Clips = self.Primary.Clips - 1
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        self.ReloadingTime = CurTime() + AnimationTime
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
 
	end
end






function SWEP:Initialize()
	self:SetScoped( false )
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Think()
	if !self.Owner:KeyDown( IN_RELOAD ) then
		self.ReloadDown = false
	end
	if self.Reloading == true then
		if self.ReloadLength < CurTime() - self.ReloadStart then
			self.Weapon:FinishReload()
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
   bullet.Force  = 10
   bullet.Damage = dmg

   self.Owner:FireBullets( bullet )
end

function SWEP:DryFire(setnext)
   if CLIENT and LocalPlayer() == self.Owner then
      self:EmitSound( self.DrySound )
   end

   setnext(self, CurTime() + 0.2)

end

function SWEP:CanPrimaryAttack()

   if self.Weapon:Clip1() <= 0 then 
      self:DryFire(self.SetNextPrimaryFire)
	  self:Reload()
      return false
   end
   if self.Reloading then
      self:DryFire(self.SetNextPrimaryFire)
      return false
	 end
   return true
end

function SWEP:CanSecondaryAttack()
   if not IsValid(self.Owner) then return end

   if self.Weapon:Clip2() <= 0 then
      self:DryFire(self.SetNextSecondaryFire)
      return false
   end
   return true
end

function SWEP:DoImpactEffect( trace, damageType )
	if (trace.Entity:GetClass() == "ep_ghost_shield") then
		return true
	else
		return false
	end
end

function SWEP:GetViewModelPosition( pos, ang )
   if not self:GetScoped() then return pos, ang end

   local mul = 1.0

	if self:GetScoped() then
		mul = math.Clamp( (CurTime() - self.ScopeInTime) / 0.25, 0, 1 )
	end
   
	if not self:GetScoped() then mul = 1 - mul end
	
	pos = pos + self.ZoomPos.x * ang:Right() * mul
	pos = pos + self.ZoomPos.y * ang:Forward() * mul
	pos = pos + self.ZoomPos.z * ang:Up() * mul

	return pos, ang
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Scoped" )
	self:NetworkVar( "Bool", 1, "Reloading" )
	self:NetworkVar( "Float", 2, "Reloadstart" )
	self:NetworkVar( "Float", 3, "Reloadtime" )
end