if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
  
if CLIENT then	
surface.CreateFont("EPText", {font = "Trebuchet24",
											size = 16,
											weight = 1000})
											
	surface.CreateFont("EPAmmo", {font = "Tahoma",
											size = 32,
											weight = 1000})
		-- Color presets
	local bg_colors = {
		background_main = Color(0, 0, 10, 200),
		default = Color(100,100,100,200),
		ghost = Color(200, 120, 40, 200),
		swat = Color(80, 80, 200, 200),
		target = Color(80, 80, 200, 255)
		}

	local font_colors = {
		default = Color(255, 255, 255, 255),
		black = Color(0,0,0,255),
		ghost = Color(250, 190, 80, 255),
		swat = Color(150, 150, 250, 255),
		target = Color(230, 20, 20, 255)
	};
	local pipparams = {
		["$basetexture"] = "VGUI/circle.vtf",
		["$nodecal"] = 1,
		["$model"] = 1,
		["$additive"] = 1,
		["$nocull"] = 1,
		["$vertexcolor"] = true,
		["$vertexalpha"] = true
		}
	local pip = CreateMaterial("HealthPip","UnlitGeneric",pipparams)
end
   
SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName			= "HP5 Medical Dart"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 3
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Fires a healing dart at your allies"
   SWEP.PrimaryInstruction = "Shoot a friendly to restore 1 pip of health"
   SWEP.SecondaryInstruction = "Shoot yourself to restore 1 pip of health"
   SWEP.CamPos = Vector(33,33,10)
   SWEP.LookPos = Vector(0,0,0)
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 1.2
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0.2
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 100
SWEP.Primary.ClipMax = 160
SWEP.Primary.DefaultClip = 160
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 11
SWEP.HeadDamage = 22

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.4
SWEP.ZoomCone = 0.005
SWEP.NormalCone = 0.02
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-2.5, -4, 2.2)

--Fast reload stuff

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 2.1
SWEP.ReloadCritEnd		= 2.3
SWEP.ReloadAnimLength	= 3.2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_MAC10.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.LastRegenTick		= 0

SWEP.Tracer				= "heal_dart"

if CLIENT then

	local pip = CreateMaterial("HealthPip","UnlitGeneric",pipparams)
	function SWEP:DrawHUD()
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_SWAT and v:Alive()) then
				local src = self.Owner:GetShootPos()
				local hit = v:GetShootPos()
				local tracedata = {}
				tracedata.start = src
				tracedata.endpos = hit
				tracedata.filter = self.Owner
				tracedata.mask = MASK_SOLID_BRUSHONLY
				local trace = util.TraceLine(tracedata)
				if !trace.HitWorld then
					local pos = (v:GetPos()+Vector(0,0,100)):ToScreen()
					--Old Chevron wallhacks
					
					--draw.NoTexture()
					--surface.DrawTexturedRectRotated( pos.x+offset, pos.y, width, height, 45 )
					--surface.DrawTexturedRectRotated( pos.x-offset, pos.y, width, height, 135 )
					--surface.DrawTexturedRectRotated( pos.x+offset, pos.y-(offset*3), width, height, 45 )
					--surface.DrawTexturedRectRotated( pos.x-offset, pos.y-(offset*3), width, height, 135 )
					
					surface.SetDrawColor( bg_colors.swat )	
					local Min,Max = v:GetCollisionBounds()
					local pos = v:GetPos()
					local left,right,up,down
					local scale = (pos+Min):ToScreen().y-(pos+Max):ToScreen().y
					left = (pos):ToScreen().x-0.4*scale
					right = (pos):ToScreen().x+0.4*scale
					down = (pos+Min):ToScreen().y
					up = (pos+Max):ToScreen().y
					
					local xpos = left
					local ypos = up
					local height = ScrH()/96
					local health = v:Health()/100
					surface.SetMaterial(pip)
					for i = 0, v:Health()/25, 1 do
						alpha = (health*4) - (i)
						surface.SetDrawColor( bg_colors.swat.r, bg_colors.swat.g, bg_colors.swat.b, alpha*255 )
						surface.DrawRect( xpos+(height*i*1.1), ypos-height-3, height, height)
						surface.SetDrawColor( 0, 0, 0, alpha*1000 )
						surface.DrawOutlinedRect( xpos+(height*i*1.1), ypos-height-3, height, height)
					end
				end
			end
		end
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
			draw.SimpleTextOutlined( clip, "EPAmmo", posx + offset/2, posy + offset/2, font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end
		if self.Owner:Team() == TEAM_SWAT then
			surface.SetDrawColor( bg_colors.swat )
			surface.SetAlphaMultiplier(0.6)
			draw.RoundedBoxEx( 16, posx, posy, right, offset*3, bg_colors.swat,true,false,true,false )
			surface.SetAlphaMultiplier(1) 
			draw.SimpleTextOutlined(clip, "EPAmmo", posx + offset/2, posy + offset/2, font_colors.swat, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
		end
		
		self:DrawCross()
	end
	
end

function SWEP:Reload()
	return false
end

function SWEP:Holster()
	self.LastRegenTick = CurTime()
	return true
end

function SWEP:Think()
	if (CurTime() - self.LastRegenTick) > 0.1 then
		self.Weapon:SetClip1((CurTime()-self.LastRegenTick)*20 + self.Weapon:Clip1())
		self.LastRegenTick = CurTime()
	end
	if self.Weapon:Clip1() > 100 then 
		self.Weapon:SetClip1(100)
	end
end

function SWEP:CanPrimaryAttack()

   if self.Weapon:Clip1() < 30 then 
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   if self.Reloading then
      return false
	 end
   return true
end
function SWEP:CanSecondaryAttack()

   if self.Weapon:Clip1() < 70 then 
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   if self.Reloading then
      return false
	 end
   return true
end

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() then return end
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		if self.Primary.Sound2 then
			self.Weapon:EmitSound( self.Primary.Sound2, self.Primary.SoundLevel )
		end
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		if self.Primary.Sound2 then
			sound.Play(self.Primary.Sound2, self:GetPos(), self.Primary.SoundLevel)
		end
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
	self:TakePrimaryAmmo( 30 )
end

function SWEP:SecondaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if not self:CanSecondaryAttack() then return end
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		if self.Primary.Sound2 then
			self.Weapon:EmitSound( self.Primary.Sound2, self.Primary.SoundLevel )
		end
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		if self.Primary.Sound2 then
			sound.Play(self.Primary.Sound2, self:GetPos(), self.Primary.SoundLevel)
		end
	end
	player_manager.RunClass( self.Owner, "Heal", 25 )
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self:GetPos())
		ed:SetStart(self:GetPos()+Vector(0,0,1))
	util.Effect( "heal_dart", ed, true, true )
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
	self:TakePrimaryAmmo( 70 )
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
	bullet.Damage = 0
	bullet.Callback = function(att, tr, dmginfo)
		if tr.Entity and tr.Entity:IsPlayer() and tr.Entity:Team() == self.Owner:Team() then
			player_manager.RunClass( tr.Entity, "Heal", 25 )
			if tr.Entity:Health() < player_manager.RunClass(tr.Entity,"GetMaxHealth") then
				player_manager.RunClass(self.Owner,"AddPoints",5,"Healed a teammate")
			end
		end
	end

   self.Owner:FireBullets( bullet )
end
