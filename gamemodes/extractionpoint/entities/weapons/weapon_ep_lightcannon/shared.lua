if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"
SWEP.HoldTypeAim = "ar2"

if CLIENT then
   SWEP.PrintName			= "45mm LC-24"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Fires a deadly accurate explosive round"
   SWEP.PrimaryInstruction = "Fire cannon round"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(50,25,5)
   SWEP.LookPos = Vector(8,0,7)
   SWEP.IconLetter = "m"
end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 9
SWEP.Primary.Damage = 32
SWEP.Primary.Delay = 1.2
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 20
SWEP.Primary.MaxClips       = 20

SWEP.BodyDamage = 32
SWEP.HeadDamage = 64

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0.002
SWEP.NormalCone = 0.1
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-4.0, -1, 2)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 2
SWEP.ReloadCritStart	= 0.7
SWEP.ReloadCritEnd		= 0.9
SWEP.ReloadAnimLength	= 3.5
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Tracer				= "snipe_smoke"

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
	bullet.Tracer = 1
	bullet.TracerName = "snipe_smoke"
	bullet.Force  = 200
	bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)
		util.BlastDamage( self.Weapon, self.Owner, tr.HitPos, 130, 40 )
		local effectdata = EffectData()
		local explodepos = (self.Owner:GetShootPos()-tr.HitPos)
		explodepos:Normalize()
		effectdata:SetStart( tr.HitPos+explodepos*10 )
		effectdata:SetOrigin( tr.HitPos+explodepos*10 )
		util.Effect( "shell_explode", effectdata )
		local Pos1 = tr.HitPos + tr.HitNormal
		local Pos2 = tr.HitPos - tr.HitNormal
		util.Decal("FadingScorch", Pos1, Pos2)
	end

   self.Owner:FireBullets( bullet )
end
