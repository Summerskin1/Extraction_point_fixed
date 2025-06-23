if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "duel"


if CLIENT then
   SWEP.PrintName			= "SWAT Shield"
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc = "SWAT Personal Shield"
   SWEP.PrimaryInstruction = "Carry a defensive shield in front of you"
   SWEP.SecondaryInstruction = "N/A"
   SWEP.CamPos = Vector(25,25,10)
   SWEP.LookPos = Vector(0,0,0.5)

   SWEP.Slot				= 3
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
SWEP.ViewModelFOV		= 4
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= ""

SWEP.shieldEnt			= "ep_ghost_shield"

SWEP.Shield				= nil
SWEP.FakeShield			= nil
SWEP.ShieldAngle = 90
SWEP.DeployTime = 0
SWEP.SpeedMult = 0.8
SWEP.CrouchLerp = 0
SWEP.HideAmmo = true
function SWEP:Deploy()
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
			self.FakeShield = ClientsideModel( "models/props_combine/combine_barricade_short01a.mdl", RENDERGROUP_OPAQUE)
			self.DeployTime = CurTime()
		end
		if SERVER then
			self.Shield = ents.Create("ep_swat_shield")
			self.Shield:SetOwner(self.Owner)
			self.Shield:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*80)
			local ang = self.Owner:GetAimVector():Angle()
			ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle )
			self.Shield:SetAngles( ang )
			self.Shield:SetGravity(0)
			self.Shield:Spawn()
			print("test");
		end
	end
    return true
end

function SWEP:Think()
	if SERVER then
		if self.Shield:IsValid() then
			local ang = self.Owner:GetAimVector():Angle()
			ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle )

			ang.x = math.Clamp(ang.x,-180,10)
			self.Shield:SetAngles( ang )
			if (self.Owner:Crouching()) then
				self.Shield:SetPos(self.Owner:GetPos()+Vector(0,0,35)+self.Owner:GetAimVector()+ang:Forward()*30+ang:Up()*10)
			else
				self.Shield:SetPos(self.Owner:GetPos()+Vector(0,0,50)+self.Owner:GetAimVector()+ang:Forward()*30+ang:Up()*10)
			end
		end
	end

end

function SWEP:Holster()
	if SERVER then
		if self.Shield and self.Shield:IsValid() then
			if (self.Owner:Alive()) then
				self.Shield:Remove()
			end
		end
	else
		if self.FakeShield and self.FakeShield:IsValid() then
			self.FakeShield:Remove()
		end
	end
	return true
end
function SWEP:OnRemove()
		if self.FakeShield and self.FakeShield:IsValid() then
			self.FakeShield:Remove()
		end
end

function SWEP:ViewModelDrawn()
	if CLIENT then
		if self.FakeShield:IsValid() then
			local ang = self.Owner:GetAimVector():Angle()
			local del = Lerp((CurTime()-self.DeployTime)*3,1,0)

			ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle + math.Clamp(1-(del*del),0,1 )*45 - 45 )
			--ang:RotateAroundAxis( self.Owner:GetAimVector(), self.ShieldAngle)
			ang.x = math.Clamp(ang.x,-180,10)
			self.FakeShield:SetAngles( ang )
			if (self.Owner:Crouching()) then
				self.CrouchLerp = math.Clamp(self.CrouchLerp+0.03,0,1)
			else
				self.CrouchLerp = math.Clamp(self.CrouchLerp-0.03,0,1)
			end
			self.FakeShield:SetPos(self.Owner:GetPos()+Vector(0,0,Lerp(self.CrouchLerp,50,35))+self.Owner:GetAimVector()+ang:Forward()*30+ang:Up()*10)
		end
	end
end

function SWEP:Reload()
    return false
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end
