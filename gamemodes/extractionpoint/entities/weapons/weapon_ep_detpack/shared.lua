if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName			= "Remotely Detonated Explosive"			
   SWEP.Author				= "Cooldown Studios"
   
   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.PrimaryInstruction = "Toss/place detpack"
   SWEP.SecondaryInstruction = "Detonate detpack"
   SWEP.WeaponDesc = "An explosive pack that may be\nplaced and remotely detonated"
   SWEP.CamPos = Vector(25,25,10)
   SWEP.LookPos = Vector(0,0,0.5)
   SWEP.IconLetter = "C "
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 6
SWEP.Primary.Damage = 43
SWEP.Primary.Delay = 0.6
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 43
SWEP.HeadDamage = 90


--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"

SWEP.Bomb				= nil

SWEP.HideAmmo = true


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
		local amt = self:Clip1()/self.Primary.ClipSize
		if self.IconFont == "EP_Wepfont2" then
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5+7, y-25+tall*0.25, light, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5+7, y+tall*0.25, light, TEXT_ALIGN_CENTER )
		end
		
		surface.SetDrawColor(light )
		surface.DrawRect(x+wide*0.1, y+tall*0.7, wide*0.8*amt, tall*0.1 )
		
		surface.SetDrawColor( dark )
		surface.DrawOutlinedRect(x+wide*0.1, y+tall*0.7, wide*0.8, tall*0.1 )
		
	end
		
end

local sin,cos,rad = math.sin,math.cos,math.rad
local function GenerateCircle(x,y,radius,quality)
    local circle = {};
    local tmp = 0;
	local s,c;
    for i=1,quality do
        tmp = rad(i*360)/quality;
		s = sin(tmp);
		c = cos(tmp);
        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
    end
    return circle;
end

function SWEP:Deploy()
	if self.Weapon:Clip1() > 0 then
		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_THROW_DRAW   ) 
	else
		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW )
	end
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",self.SpeedMult)
		if CLIENT then
			self:WeaponInfo()
		end
	end
    return true
end

function SWEP:Holster()
	return true
end


function SWEP:Reload()
    return false
end

function SWEP:PrimaryAttack() 
	if self.Weapon:Clip1() < 1 then return end
	local traceRes = self.Owner:GetEyeTrace()
	if (traceRes.HitPos - traceRes.StartPos):Length() < 200 then
		if SERVER then
			local nade = ents.Create("ep_detpack")
			nade:SetOwner(self.Owner)
			nade:SetGravity(1)
			nade:SetFriction(0.3)
			nade:SetOwner(self.Owner)
			nade:SetPos(traceRes.HitPos+traceRes.HitNormal*2)
			nade:SetAngles(traceRes.HitNormal:Angle()+Angle(90,0,0))
			nade:Spawn()
			self.Bomb = nade
		end
	self:TakePrimaryAmmo( 1 )
	self.Weapon:SendWeaponAnim(ACT_SLAM_THROW_THROW2)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
end
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Weapon:EmitSound( "buttons/button18.wav", 100, 100 )
	if self.Bomb and self.Bomb:IsValid() then
		self.Bomb:Explode()
	end
	self:SetNextSecondaryFire(CurTime()+1.5)
end

function SWEP:Think()
end
