if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "shotgun"

if CLIENT then
   SWEP.PrintName			= "5T 'Boomer' Cannon"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   
   SWEP.DrawCrosshair   = false
   
   SWEP.WeaponDesc = "Fires an explosive round that\ndetonates 10 meters away"
   SWEP.PrimaryInstruction = "Fires explosive round"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(50,26,10)
   SWEP.LookPos = Vector(10,0,6)
   SWEP.IconLetter = "B"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "smg1" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 4
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.11
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 60
SWEP.Primary.MaxClips = 0
SWEP.Primary.Clips = 0
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true

SWEP.BodyDamage = 14
SWEP.HeadDamage = 32

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.1
SWEP.ZoomCone = 0.02
SWEP.NormalCone = 0.05
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-5.5, -4, 1)

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
SWEP.Primary.Sound			= Sound( "WaterExplosionEffect.Sound" )
SWEP.Primary.Sound2			= Sound( "NPC_Strider.FireMinigun" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

if CLIENT then

	function SWEP:DrawHUD()
		
		-- Color presets
		local bg_colors = {
			background_main = Color(0, 0, 10, 200),
			default = Color(100,100,100,200),
			ghost = Color(200, 120, 40, 200),
			swat = Color(80, 80, 200, 200)
		};

		local font_colors = {
			default = Color(255, 255, 255, 255),
			black = Color(0,0,0,255),
			ghost = Color(250, 190, 80, 255),
			swat = Color(150, 150, 250, 255)
		};
	
		local clip = self.Weapon:Clip1()
		local ammo = self.Weapon:Ammo1()
		
		local right = (ScrW() / 13)
		local posx = ScrW() - right
		local posy = ScrH() - (ScrH() / 16)
		local offset = draw.GetFontHeight("EPAmmo")/2
		
		--Draw Ammo
		if self.Owner:Team() == TEAM_GHOST then
			surface.SetDrawColor( bg_colors.ghost )
			surface.SetAlphaMultiplier(0.6)
			draw.RoundedBoxEx( 16, posx, posy, right, offset*3, bg_colors.ghost,true,false,true,false )
			surface.SetAlphaMultiplier(1) 
			draw.SimpleTextOutlined( clip .. " ◊ " .. ammo, "EPAmmo", posx + offset/2, posy + offset/2, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end
		if self.Owner:Team() == TEAM_SWAT then
			surface.SetDrawColor( bg_colors.swat )
			surface.SetAlphaMultiplier(0.6)
			draw.RoundedBoxEx( 16, posx, posy, right, offset*3, bg_colors.swat,true,false,true,false )
			surface.SetAlphaMultiplier(1) 
			draw.SimpleTextOutlined(clip .. " ◊ " .. ammo, "EPAmmo", posx + offset/2, posy + offset/2, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end
		
		self:DrawCross()
	end
	function SWEP:DrawDetails(x, y, wide, tall, alpha, selected)
		--local alphamod = math.Rand(0.5,0.8) -- make it flicker.
		local alphamod = 0.7
		local dark, light
		if self.Owner:Team() == TEAM_SWAT then
			dark = Color( 30, 40, 60, alpha/2 )
			if selected then
				light = Color(150, 200, 250, alpha*alphamod)
			else
				light = Color(90, 120, 170, alpha*alphamod)
			end
		else
			dark = Color( 30, 30, 30, alpha/2 )
			if selected then
				light = Color(255, 190, 80, alpha*alphamod)
			else
				light = Color(160, 110, 40, alpha*alphamod)
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

	self.reloadtimer =  CurTime() + wep:SequenceDuration()

	self.dt.Reloading = true

	return true
end

function SWEP:PerformReload()
	local ply = self.Owner
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

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
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
		end
	end
	self.dt.Reloading = false
    self.reloadtimer = 0
	self:SetScoped( false )
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end
   
   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = 1

   bullet.Src    = self.Owner:GetShootPos()
   if self:GetScoped() then
		bullet.Dir    = self.Owner:GetAimVector()
   else
		bullet.Dir    = self.Owner:GetAimVector()+Vector( math.Rand(-cone, cone),math.Rand(-cone, cone), 0 )
   end
   bullet.Spread = Vector( self.Primary.Cone, self.Primary.Cone, 0 )
   bullet.Tracer = 0
   bullet.TracerName = "boomer_tracer"
   bullet.Force  = 10
   bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)
		if (tr.StartPos - tr.HitPos):Length() < 800 then
			util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 160, 20 )
			local effectdata = EffectData()
			effectdata:SetStart( tr.StartPos )
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetEntity( self.Weapon )
			util.Effect( "boomer_tracer", effectdata )
		else
			local hit = tr.HitPos - tr.StartPos
			hit:Normalize()
			hit = hit*800
			util.BlastDamage( self.Weapon, self.Owner, tr.StartPos+hit, 140, 20 )
			local effectdata = EffectData()
			effectdata:SetStart( tr.StartPos )
			effectdata:SetOrigin( tr.StartPos+hit )
			effectdata:SetEntity( self.Weapon )
			util.Effect( "boomer_tracer", effectdata )
		end
	end

   self.Owner:FireBullets( bullet )
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 1, "Reloading")
	self:NetworkVar( "Bool", 0, "Scoped" )
end
