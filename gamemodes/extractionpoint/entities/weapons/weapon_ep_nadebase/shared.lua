if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "Frag Grenade"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.PrimaryInstruction = "Toss grenade"
   SWEP.SecondaryInstruction = "N/A"
   
   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 6
SWEP.Primary.Damage = 43
SWEP.Primary.Delay = 1.5
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 3
SWEP.Primary.ClipMax = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Clips       	= 1
SWEP.Primary.MaxClips       = 1
SWEP.Primary.Automatic = false

SWEP.GrenadeEntity = "ep_frag_grenade"

SWEP.BodyDamage = 43
SWEP.HeadDamage = 90


--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 80
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.SpeedMult = 1

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
function SWEP:Deploy()
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
		end
	end
	if self.Primary.Clips > 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	end
    return true
end

function SWEP:Holster()
	if SERVER and self.Primary.Clips < 1 then
		SafeRemoveEntity(self)
		--Disabled to prevent CTD
		--self.Owner:StripWeapon( self.Weapon:GetClass() ) 
	end
	return true
end

function SWEP:OwnerDie()
	if SERVER then
		if self.Primary.Clips > 0 then
				local nade = ents.Create(self.GrenadeEntity)
				nade:SetOwner(self.Owner)
				nade:SetPos(self.Owner:GetShootPos())
				nade:SetGravity(1)
				nade:SetFriction(0.3)
				nade:Spawn()
				nade:PhysWake()
				local phys = nade:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(self.Owner:GetAimVector() * 100 + VectorRand()*100)
				end
		end
	end
end

function SWEP:Reload()
    return false
end

function SWEP:PrimaryAttack()
	if self.Primary.Clips < 1 then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if IsFirstTimePredicted() then
		self.Primary.Clips = self.Primary.Clips -1
	end
	timer.Simple( 0.2, function()
		if self.Weapon and self.Weapon:IsValid() and self.Weapon:Clip1() > 0 then
			if SERVER then
				local nade = ents.Create(self.GrenadeEntity)
				nade:SetOwner(self.Owner)
				nade:SetPos(self.Owner:GetShootPos())
				nade:SetGravity(1)
				nade:SetFriction(0.3)
				nade:Spawn()
				nade:PhysWake()
				local phys = nade:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(self.Owner:GetAimVector() * 1000 + Vector(0,0,100))
					phys:AddAngleVelocity(Vector(300,math.random(-100,100),math.random(-100,100)))
				end
					
				
			end
		end
	end )
	timer.Simple( 0.8, function()
		if self.Weapon and self.Weapon:IsValid() and self.Primary.Clips > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN) 
		end
	end )
	
end

function SWEP:SecondaryAttack()
	if self.Primary.Clips < 1 then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if IsFirstTimePredicted() then
		self.Primary.Clips = self.Primary.Clips -1
	end
	timer.Simple( 0.2, function()
		if self.Weapon and self.Weapon:IsValid() and self.Weapon:Clip1() > 0 then
			if SERVER then
				local nade = ents.Create(self.GrenadeEntity)
				nade:SetOwner(self.Owner)
				nade:SetPos(self.Owner:GetShootPos()+Vector(0,0,-10))
				nade:SetGravity(1)
				nade:SetFriction(0.3)
				nade:Spawn()
				nade:PhysWake()
				local phys = nade:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(self.Owner:GetAimVector() * 500 + Vector(0,0,20))
					phys:AddAngleVelocity(Vector(200,math.random(-50,50),math.random(-50,50)))
				end
					
				
			end
		end
	end )
	timer.Simple( 0.8, function()
		if self.Weapon and self.Weapon:IsValid() and self.Primary.Clips > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN) 
		end
	end )
	
end
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Think()
end
