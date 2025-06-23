if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Radio"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.WeaponDesc = "While holding your radio\nyour team can hear you from any\ndistance"
   SWEP.PrimaryInstruction = "N/A"
   SWEP.SecondaryInstruction = "N/A"

   SWEP.Slot				= 5
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.CamPos = Vector(60,40,10)
   SWEP.LookPos = Vector(12,0,2.5)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "*"
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
SWEP.Primary.ClipSize = 100
SWEP.Primary.ClipMax = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false

SWEP.BodyDamage = 43
SWEP.HeadDamage = 90


--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 45
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= ""

SWEP.Cloaked			= false
SWEP.HideAmmo = true

if CLIENT then	
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
		local amt = self:Clip1()/self.Primary.ClipSize
		if self.IconFont == "EP_Wepfont2" then
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y-25+tall*0.25, light, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y+tall*0.25, light, TEXT_ALIGN_CENTER )
		end
	end
		
end
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
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
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end