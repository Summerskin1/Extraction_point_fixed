if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Trip Mine"			
   SWEP.Author				= "Cooldown Studios"
   SWEP.PrimaryInstruction = "Place Custom Trip Mine"
   SWEP.SecondaryInstruction = "N/A"

   SWEP.Slot				= 4
   SWEP.SlotPos			= 1

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Trip mines that can be\nplaced on almost any\nsurface"
   SWEP.PrimaryInstruction = "Place Custom Trip Mine"
   SWEP.SecondaryInstruction = "Place Standard Trip Mine"
   SWEP.CamPos = Vector(-40,-40,10)
   SWEP.LookPos = Vector(0,0,7)
   SWEP.IconFont = "EP_Wepfont2"
   SWEP.IconLetter = "w"
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
SWEP.Primary.Clips       	= 3
SWEP.Primary.MaxClips       = 3

SWEP.BodyDamage = 43
SWEP.HeadDamage = 90


--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel			= "models/Items/battery.mdl"

SWEP.MinePos			= nil
SWEP.MineAngle			= nil
SWEP.TargPos			= nil
SWEP.Targeting			= false

local Laser = Material( "sprites/bluelaser1" )
local Impact = Material( "Sprites/light_glow02_add_noz" )

local sndStartPlace = Sound( "buttons/button18.wav" )
local sndFailPlace = Sound( "buttons/button16.wav" )
if CLIENT then
	function SWEP:DrawHUD()
		self:DrawAmmo("")
		self:DrawCross()
	end	
end
function SWEP:Deploy()
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",1)
		if CLIENT then
			self:WeaponInfo()
		end
	end
	if self.Primary.Clips > 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		return true
	else
		return false
	end
end

function SWEP:Holster()
	self:ClearTarget()
	return true
end


function SWEP:Reload()
	self:ClearTarget()
    return false
end

function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() then
	if self.Primary.Clips < 1 then return end
		local traceRes = self.Owner:GetEyeTrace()
		if self.Targeting then
			if (self.Owner:GetShootPos() - self.MinePos):Length() < 300 then
				self.Weapon:SendWeaponAnim(ACT_VM_THROW)
				self.TargPos = traceRes.HitPos
				self:PlaceTrip()
				self:ClearTarget()
				if self.Primary.Clips > 0 then
					timer.Simple( 1, function() 
						if self.Weapon and self.Owner:Alive() then
							self.Owner:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
						end
					end  )
				else
					if SERVER then
						self.Owner:SetActiveWeapon(self.Owner:GetWeapons()[1])
						self.Owner:StripWeapon( "weapon_ep_trip" )
					end
				end
				self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
				self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
			else
				self:ClearTarget()
				timer.Simple( 0.2, function() self.Weapon:SendWeaponAnim(ACT_VM_DRAW) end  )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
				self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
				self.Weapon:EmitSound( sndFailPlace, 100 )
			end
		else
			if (traceRes.HitPos - traceRes.StartPos):Length() < 300 then
				self.Weapon:EmitSound( sndStartPlace, 100 )
				self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
				self.MinePos = traceRes.HitPos
				self.MineAngle = traceRes.HitNormal:Angle()
				self.Targeting = true
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if IsFirstTimePredicted() then
	self:ClearTarget()
	if self.Primary.Clips < 1 then return end
		local traceRes = self.Owner:GetEyeTrace()
		if (traceRes.HitPos - traceRes.StartPos):Length() < 200 then
			--self.Weapon:EmitSound( sndStartPlace, 100 )
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.MinePos = traceRes.HitPos
			self.MineAngle = traceRes.HitNormal:Angle()
			local tr = util.TraceLine({
			start  = self.MinePos,
			endpos = self.MinePos+self.MineAngle:Forward()*10000,
			filter = self.Owner,
			mask   = MASK_SHOT
			});
			self.TargPos = tr.HitPos
			self:PlaceTrip()
		end
	end
end

function SWEP:ClearTarget()
	self.Targeting = false
	self.TargPos = nil
	self.MinePos = nil
	self.MineAngle = nil
end

function SWEP:PlaceTrip()
	if SERVER then
		local trip = ents.Create("ep_trip")
		trip:SetOwner(self.Owner)
		trip:SetPos(self.MinePos)
		trip:SetAngles(self.MineAngle)
		trip:SetAimpos(self.TargPos)
		trip:Spawn()
	end
	self.Primary.Clips = self.Primary.Clips - 1
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:Think()
end

function SWEP:ViewModelDrawn()
	if self.Targeting then	 
		local traceRes = self.Owner:GetEyeTrace()    
		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(Laser)
			render.DrawBeam(self.MinePos, traceRes.HitPos, 2, 0, 12.5, Color(100, 100, 200, 255))
			local Size = math.random() * 1.5
			render.SetMaterial(Impact)
			render.DrawQuadEasy(traceRes.HitPos, (EyePos() - traceRes.HitPos):GetNormal(), 2+Size, 2+Size, Color(100,100,200,255), 0)
		cam.End3D()
	end
end