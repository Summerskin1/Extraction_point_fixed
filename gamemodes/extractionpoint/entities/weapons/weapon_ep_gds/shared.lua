if SERVER then
   AddCSLuaFile( "shared.lua" )
resource.AddFile( "sound/ep/place_defence.wav" )
resource.AddFile( "sound/ep/shield_hit.wav" )
end
   
SWEP.HoldType = "pistol"

if CLIENT then
   SWEP.PrintName			= "G.H.O.S.T Defence System"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc = "Ghost shielding system\nDeploys shields."
   SWEP.PrimaryInstruction = "Deploy a temporary, circular shield"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(25,25,10)
   SWEP.LookPos = Vector(0,0,0.5)

   SWEP.Slot				= 4
   SWEP.SlotPos			= 2

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "[ C  "
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 0.0
SWEP.Primary.Damage = 0.0
SWEP.Primary.Delay = 1.5
SWEP.Primary.Cone = 0.0
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.DefaultClip = 1

SWEP.Primary.Clips	= 0

SWEP.BodyDamage = 0
SWEP.HeadDamage = 0

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "ep/place_defence.wav" )

SWEP.UseHands			= false
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= ""

SWEP.shieldEnt			= "ep_ghost_shield"

SWEP.GModel				= nil
SWEP.ShieldAngle = 0


SWEP.HideAmmo = true
function SWEP:Deploy()
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
			self:WeaponInfo()
			if self:Clip1() >= 1 then
				self.GModel = ClientsideModel( "models/props_interiors/vendingmachinesoda01a_door.mdl", RENDERGROUP_OPAQUE)
				self.GModel:SetMaterial("models/props_combine/portalball001_sheet")
			end
		end
	end
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
    return true
end

function SWEP:Think()
	if CLIENT then
		if self.GModel:IsValid() then
			local ang = self.Owner:GetAimVector():Angle()
			ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle )
			self.GModel:SetAngles( ang )
			self.GModel:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*160)
		end
	end
end

function SWEP:Holster()
	if CLIENT then
		if self.GModel and self.GModel:IsValid() then
			self.GModel:Remove()
		end
	end
	return true
end

function SWEP:ViewModelDrawn()
	if self.GModel and self.GModel:IsValid() then
		self.GModel:SetupBones();
		self.GModel:DrawModel();
	end
end

function SWEP:Reload()
    return false
end

function SWEP:PrimaryAttack()
	if self:Clip1() < 1 then return end
	self:TakePrimaryAmmo( 1 )
	if ( !self:CanPrimaryAttack() ) then return end
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	if SERVER then
		local shield = ents.Create("ep_ghost_shield")
		--shield:SetOwner(self.Owner)
		shield:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*80)
		local ang = self.Owner:GetAimVector():Angle()
		ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle )
		shield:SetAngles( ang )
		shield:SetGravity(0)
		shield:Spawn()
	end
	if CLIENT then
		if self.GModel:IsValid() then
			self.GModel:Remove()
		end
	end
	if ( !IsFirstTimePredicted() ) then return end
	self.Weapon:EmitSound( self.Primary.Sound, 100, 100 )
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() then
		if self:CanSecondaryAttack() then
			if self.ShieldAngle < 90 then
				self.ShieldAngle = 90
			else
				self.ShieldAngle = 0
			end
		end
	end
	self:SetNextSecondaryFire(CurTime()+0.5)
end

function SWEP:DrawHUD()
	
end