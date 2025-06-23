if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "rpg"

if CLIENT then
   SWEP.PrintName			= "13-AT Launcher"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Disposable Anti-Tank Launcher\nMust be fired from the crouching position.\nIt's heavy design slows you down."
   SWEP.PrimaryInstruction = "Launch Anti-Tank round"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(-55,-75,15)
   SWEP.LookPos = Vector(16,0,6)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = ";"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 20
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.3
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Clips       	= 0
SWEP.Primary.MaxClips       = 0

SWEP.BodyDamage = 40
SWEP.HeadDamage = 110

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0.002
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 2

SWEP.SpeedMult = 0.7

SWEP.ZoomPos = Vector(-3.0, -6, 0.5)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 4.2
SWEP.ReloadCritStart	= 1.5
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 3
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "weapons/explode3.wav" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_rpg.mdl"
--SWEP.ViewModel			= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Tracer				= "snipe_smoke"

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.SecondaryAnim = ACT_VM_SECONDARYATTACK
SWEP.ReloadAnim =  ACT_VM_RELOAD

SWEP.Distance = 100000
SWEP.HideAmmo = true

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

		if self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() then
			draw.SimpleTextOutlined("YOU CANNOT FIRE UNLESS CROUCHING", "EPAmmo", ScrW()/2, ScrH()/2, font_colors.swat, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, font_colors.black)
		end
		self:DrawAmmo()
		self:DrawCross()
	end

end

function SWEP:Holster()
	if SERVER and self:Clip1() < 1 and self.Primary.Clips < 1 then
		SafeRemoveEntity(self)
		--Disabled to prevent CTD
		--self.Owner:StripWeapon( self.Weapon:GetClass() )

    local ent = ents.Create ("prop_physics");

    ent.Parent = self.Owner
    ent:SetOwner(self.Owner)
    ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 12+self.Owner:GetAngles():Right()*10);
    ent:SetModel(self.Weapon.WorldModel)
    ent:SetAngles(self.Owner:EyeAngles() + Angle(0,180,0))
    ent:Spawn();
    local phys = ent:GetPhysicsObject();
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    phys:SetVelocity(ent:GetForward() * -80+VectorRand()*5)
	end
	return true
end

function SWEP:CanPrimaryAttack()
	if !self.Owner:Crouching() or !self.Owner:OnGround() then
		self.Weapon:EmitSound( Sound( "buttons/button9.wav" ))
		return false
	end
	--if self.Owner:GetVelocity():Length() > 100 then
		--self.Weapon:EmitSound( Sound( "buttons/button9.wav" ))
		--return false
	--end
	if self.Weapon:Clip1() <= 0 then
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
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel, 180 )
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

	local ent = ents.Create ("ep_rocket");

	ent.Parent = self.Owner
	ent:SetOwner(self.Owner)
	ent:SetPos(self.Owner:GetShootPos());
	local tr = self.Owner:GetEyeTrace()
	ent:SetAngles((tr.HitPos-ent:GetPos()):Angle());
	ent:SetBounces(true)
	ent:Spawn();

	local phys = ent:GetPhysicsObject();
	phys:SetVelocity(ent:GetForward() * 2700+VectorRand()*100)

	self:TakePrimaryAmmo( 1 )
end

function SWEP:SecondaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() or self.Weapon:Clip1() < 5 then return end

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
		phys:SetVelocity(ent:GetForward() * 3000+VectorRand()*50)
	else
		phys:SetVelocity(ent:GetForward() * 3000+VectorRand()*150)
	end

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
