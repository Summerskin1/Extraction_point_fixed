if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName			= "4k12 'WebCaster' Launcher"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 2
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Fires electrical darts that form a beam on impact"
   SWEP.PrimaryInstruction = "N/A"
   SWEP.SecondaryInstruction = "Fire cluster round"
   SWEP.CamPos = Vector(45,25,10)
   SWEP.LookPos = Vector(3,0,6)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = ")"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 4
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.26
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 10
SWEP.Primary.MaxClips       = 10

SWEP.BodyDamage = 40
SWEP.HeadDamage = 110

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0.002
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-3.0, -6, 0.5)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2.2
SWEP.ReloadCritStart	= 1.5
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 2
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Crossbow.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_crossbow.mdl"
--SWEP.ViewModel			= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"

SWEP.Tracer				= "snipe_smoke"

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim =  ACT_VM_RELOAD

SWEP.Distance = 100000

if CLIENT then

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
		
		amt = self.Primary.Clips/(self.Primary.MaxClips)
		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.8, wide*0.8*amt, tall*0.1 )
		
		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.8, wide*0.8, tall*0.1 )
		
	end
	
end

function SWEP:PrimaryAttack(worldsnd)
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() then return end
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end
 
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
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	if (!SERVER) then return end;
	
	local ent = ents.Create ("ep_bowdart");
 
	ent.Parent = self.Owner
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 4+self.Owner:GetAngles():Right()*6+self.Owner:GetAngles():Up()*-6);
	local tr = self.Owner:GetEyeTrace()
	ent:SetAngles((tr.HitPos-ent:GetPos()):Angle());
	ent:SetBounces(true)
	ent:Spawn();
	
	local phys = ent:GetPhysicsObject();
	phys:SetVelocity(ent:GetForward() * 2700+VectorRand()*100)
	
	self:TakePrimaryAmmo( 1 )
end

function SWEP:SecondaryAttack(worldsnd)
	
	
	if not self:CanPrimaryAttack() or self.Weapon:Clip1() < 5 then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay*3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay*3 )
	
	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		self.Weapon:EmitSound( "Weapon_SMG1.Double", self.Primary.SoundLevel )
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		sound.Play("Weapon_SMG1.Double", self:GetPos(), self.Primary.SoundLevel)
	end
 
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
	self.Weapon:SendWeaponAnim(self.PrimaryAnim)
	if (!SERVER) then return end;
	
	local ent = ents.Create ("ep_mirv");
 
	ent.Parent = self.Owner
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 24);
	ent:SetAngles(self.Owner:GetAimVector():Angle());
	ent:SetBounces(true)
	ent:Spawn();
	
	local phys = ent:GetPhysicsObject();
	if self:GetScoped() then
		phys:SetVelocity(ent:GetForward() * 2000+VectorRand()*50)
	else
		phys:SetVelocity(ent:GetForward() * 2000+VectorRand()*150)
	end
	ent:SetAngles(self.Owner:GetAimVector():Angle()+Angle(90,0,0));
	
	self:TakePrimaryAmmo( 5 )
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
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector( self.Primary.Cone, self.Primary.Cone, 0 )
	bullet.Tracer = 1
	bullet.TracerName = "snipe_smoke"
	bullet.Force  = 200
	bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)
		util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 150, 30 )
		local effectdata = EffectData()
		effectdata:SetStart( tr.HitPos )
		effectdata:SetOrigin( tr.HitPos )
		util.Effect( "Explosion", effectdata )
	end

   self.Owner:FireBullets( bullet )
end
