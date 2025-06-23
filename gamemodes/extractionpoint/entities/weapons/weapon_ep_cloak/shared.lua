if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Cloak"	
   SWEP.Author				= "Cooldown Studios"
   SWEP.Slot				= 3
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.PrimaryInstruction = "Cloak yourself"		
   SWEP.SecondaryInstruction = "N/A"
   SWEP.WeaponDesc = "Allows you to go almost fully\ninvisible"
   SWEP.CamPos = Vector(70,40,10)
   SWEP.LookPos = Vector(10,0,0)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "{C}"
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

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/v_slam.mdl"
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
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y-25+tall*0.35, light, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IconLetter, self.IconFont, x + wide*0.5, y+tall*0.35, light, TEXT_ALIGN_CENTER )
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
	self:DeCloak()
	return true
end


function SWEP:Reload()
    return false
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	if ( !IsFirstTimePredicted() ) then return end
	if self.Cloaked then
		self:DeCloak()
		self.Weapon:EmitSound( "buttons/button19.wav", 100, 100 )
	else
		self:Cloak()
		self.Weapon:EmitSound( "buttons/button19.wav", 100, 100 )
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end

function SWEP:Cloak()
	self.Cloaked = true
	if !self.Owner:IsValid() then return end
	mdl = self.Owner:GetViewModel()
	if CLIENT then
		if mdl:IsValid() then
			mdl:SetMaterial("models/effects/vol_light001")
			mdl:SetColor(Color(255,255,255,80))
		end
	end
	self.Owner:SetMaterial("models/effects/vol_light001")
	self.Owner:SetColor(Color(255,255,255,80))
	self.Owner:DrawShadow(false)
end
function SWEP:OwnerDie()
	self:DeCloak()
end
function SWEP:DeCloak()
	self.Cloaked = false
	if !self.Owner:IsValid() then return end
	mdl = self.Owner:GetViewModel()
	if CLIENT then
		if mdl:IsValid() then
			if player_manager.RunClass( self.Owner, "PoltergeistBehaviour" ) then
				mdl:SetMaterial("")
			else
				mdl:SetMaterial("")
			end
			mdl:SetColor(Color(255,255,255,255))
		end
	end
	if player_manager.RunClass( self.Owner, "PoltergeistBehaviour" ) then
		self.Owner:SetMaterial("models/shadertest/predator")
	else
		self.Owner:SetMaterial("")
	end
	self.Owner:SetColor(Color(255,255,255,255))
	self.Owner:DrawShadow(true)
end