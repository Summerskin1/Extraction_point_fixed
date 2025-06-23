if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldTypeAim = "revolver"
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Pincer"
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 0

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.DrawCrosshair   = false

   SWEP.WeaponDesc = "Locks onto target's heads\nOtherwise dumb fire"
   SWEP.PrimaryInstruction = "Fire bullets"
   SWEP.SecondaryInstruction = "Aim down sights"
   SWEP.CamPos = Vector(15,24,3)
   SWEP.LookPos = Vector(2,0,4)
   SWEP.IconLetter = "u"

end

SWEP.Base				= "weapon_ep_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil	= 0.2
SWEP.Primary.Damage = 7
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.019
SWEP.Primary.ClipSize = 32
SWEP.Primary.ClipMax = 180
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = false
SWEP.Primary.Clips       	= 4
SWEP.Primary.MaxClips       = 4

SWEP.ScopeInTime = 0.2
SWEP.ZoomAmt = 1.2
SWEP.ZoomCone = 0.015
SWEP.NormalCone = 0.07
SWEP.ZoomSensitivity = 1.5

SWEP.ZoomPos = Vector(-3, 4, 2)

SWEP.ReloadDown			= false
SWEP.ReloadStart		= 0
SWEP.Reloading			= false
SWEP.ReloadLength		= 3
SWEP.ReloadCritStart	= 1.4
SWEP.ReloadCritEnd		= 1.7
SWEP.ReloadAnimLength	= 2.8
SWEP.ReloadFailed		= false

SWEP.SuccessPoint		= 0
SWEP.LastReload			= 2
SWEP.FinishReloadTime		= 0

SWEP.ReloadWidth = 130

--SWEP.AmmoEnt = "item_ammo_revolver_ep"
SWEP.Primary.Sound			= Sound( "Weapon_usp.SilencedShot" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"


SWEP.CurTarget 			= nil
SWEP.MaxPitchAngle 		= 17
SWEP.MaxYawAngle 		= 17
SWEP.LockRange			= 1100
SWEP.TimeToLock			= 180 --ticks
SWEP.Tracer				= "p_trail"

if SERVER then
	util.AddNetworkString("Lockon")
end

function SWEP:Initialize()
	self:SetScoped( false )
	self:SetLockTime(0)
	self:SetLock(0)
	self:SetWeaponHoldType(self.HoldType)
	self.Target = nil
end

function SWEP:PrimaryAttack(worldsnd)

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
		if self.Primary.Sound2 then
			self.Weapon:EmitSound( self.Primary.Sound2, self.Primary.SoundLevel )
		end
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
		if self.Primary.Sound2 then
			sound.Play(self.Primary.Sound2, self:GetPos(), self.Primary.SoundLevel)
		end
	end
	//self.Weapon:EmitSound( self.Primary.Sound )
	local recoil = self.Primary.Recoil
	if self:GetScoped() then
		if (self:GetLock() == 1) then
			self:ShootLockBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.ZoomCone)
		else
			self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
			self:ShootBullet( math.floor(self.Primary.Damage/1.5), self.Primary.Recoil, self.Primary.NumShots*2, self.ZoomCone )
			self.Owner:LagCompensation( false )
			if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
				local eyeang = self.Owner:EyeAngles()
				eyeang.pitch = eyeang.pitch - recoil
				self.Owner:SetEyeAngles( eyeang )
			end
		end
	else
		if (self:GetLock() == 1) then
			self:ShootLockBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.NormalCone)
		else
			self.Owner:LagCompensation( true ) --Commented out for now to test if this is causing lagspikes.
			self:ShootBullet( math.floor(self.Primary.Damage/1.5), self.Primary.Recoil, self.Primary.NumShots*2, self.NormalCone )
			self.Owner:LagCompensation( false )
			if ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted()) then
				local eyeang = self.Owner:EyeAngles()
				eyeang.pitch = eyeang.pitch - recoil
				self.Owner:SetEyeAngles( eyeang )
			end
		end
	end
	if self:GetScoped() then
		recoil = recoil/2
	end
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * recoil, math.Rand(-0.1,0.1) * recoil, 0 ) )
	self:TakePrimaryAmmo( 2 )
end

function SWEP:ShootLockBullet( dmg, recoil, numbul, cone )

   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

	if SERVER then
	local ed = EffectData()
	local vecPos, ang = self.CurTarget:GetBonePosition(self.CurTarget:LookupBone("ValveBiped.Bip01_Head1") or 12)
	ed:SetStart(self.Owner:GetShootPos())
	ed:SetOrigin(vecPos+Vector(0,0,5))
	ed:SetEntity(self.Weapon)
	util.Effect( self.Tracer or "Tracer", ed, true, true )
	util.Effect( self.Tracer or "Tracer", ed, true, true )
	util.Effect( "BloodImpact", ed, true, true )
	end
   if SERVER then
	if self.CurTarget:IsPlayer() and self.CurTarget:Alive() and self.CurTarget:IsValid() then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(dmg*player_manager.RunClass( self.CurTarget, "HeadShotScale" ))
		dmginfo:SetDamageType( DMG_BULLET )
		dmginfo:SetAttacker( self.Owner )
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamageForce(Vector(0,0,0))
		self.CurTarget:TakeDamageInfo( dmginfo )
		self.Owner:SendLua( 'surface.PlaySound("physics/metal/metal_sheet_impact_bullet2.wav")' )
	end
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
   bullet.Num    = numbul


   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 10
   bullet.Damage = dmg
	bullet.Callback = function(att, tr, dmginfo)
		if tr.Entity and tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() then
			if (tr.HitPos - tr.StartPos):Length() < self.LockRange then
				self:SetLockTime(self:GetLockTime()+20)
			end
		end
	end


   self.Owner:FireBullets( bullet )
end

function SWEP:Think()
	if !self.Owner:KeyDown( IN_RELOAD ) then
		self.ReloadDown = false
	end
	if self.Reloading == true then
		if CLIENT then
			if self.ReloadLength < self.DrawTime - self.ReloadStart then
				net.Start("ReloadResult")
				net.WriteEntity(self.Weapon)
				net.WriteBit(true)
				net.SendToServer()
				self.Weapon:CritReload()
			end
		end
	end
	if SERVER then
		if (self.CurTarget == nil ) then
			local target = self:TargetSearch()
			net.Start("Lockon")
			net.WriteEntity(self.Weapon)
			net.WriteEntity(target)
			net.Send(self.Owner)
			self.CurTarget = target
				self:SetLockTime(self:GetLockTime()-3)
			if self:GetLockTime() <= 0 then
				self:SetLockTime(0)
			else
				self:SetLockTime(self:GetLockTime()-3)
			end
		else
			if self:CheckTarget(self.CurTarget) then
				if self:GetLock() == 0 then
					self:SetLockTime(self:GetLockTime()+1)
					if self:GetLockTime() > self.TimeToLock	then
						--self:SetLockTime(0)
						self:SetLock(1)
						self.Owner:SendLua('surface.PlaySound("npc/turret_floor/ping.wav")')
					end
				end
			else
				self:SetLock(0)
				net.Start("Lockon")
				net.WriteEntity(self.Weapon)
				net.WriteEntity(target)
				net.Send(self.Owner)
				self.CurTarget = target
				--print("lost target")
			end
			if self.CurTarget != nil then
				if !self.CurTarget:Alive() then
						self:SetLockTime(0)
						self:SetLock(0)
				end
			end
		end
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "Lock" );
	self:NetworkVar( "Int", 1, "LockTime" );
	self:NetworkVar( "Bool", 0, "Scoped" )
end

function SWEP:TargetSearch()
	local targets = ents.FindInSphere(self:GetPos(),self.LockRange)
	for k,v in pairs(targets) do
		if v:IsValid() and v:IsPlayer() then
			if v:Team() != self.Owner:Team() then
				if self:CheckTarget(v) then
					return v
				end
			end
		end
	end
	return nil
end

function SWEP:CheckTarget(ply)
	local viewAng = self.Owner:EyeAngles()
	local vecPos, ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine") or 12)
	local vecPos = ply:GetPos()+Vector(0,0,40)
	local trace = {start = self.Owner:EyePos(), endpos = vecPos, filter = self.Owner, mask = MASK_SHOT}
	local traceRes = util.TraceLine(trace)

	--if (traceRes.HitWorld || traceRes.Entity != ply) then
	if (traceRes.HitPos-vecPos):Length() > 30 then
		--print("hits world")
		return false
	end

	--vecPos = vecPos - self:VelPred(self.Owner) + self:VelPred(ply)
	local tgtAngle = (vecPos - self.Owner:EyePos()):Angle()

	local pDif = math.abs(math.AngleDifference(tgtAngle.p, viewAng.p))
	local yDif = math.abs(math.AngleDifference(tgtAngle.y, viewAng.y))

	if (pDif < self.MaxPitchAngle && yDif < self.MaxYawAngle) then
		return true
	end
	return false
end

function SWEP:TargetDir()
	if (self.CurTarget != nil and self.CurTarget:IsValid()) then
		local vecPos, ang = self.CurTarget:GetBonePosition(self.CurTarget:LookupBone("ValveBiped.Bip01_Head1") or 12)
		--vecPos = vecPos - self:VelPred(self.Owner) + self:VelPred(self.CurTarget)
		vecPos = vecPos + Vector(0,0,5)
		return vecPos - self.Owner:GetShootPos()
	end
	return self.Owner:GetAimVector()
end

function SWEP:VelPred(ply)
	return ply:GetAbsVelocity() * 0.012;
end

function SWEP:SetTarget(targ)
	self.CurTarget = targ
end

--Server sends lock signal.
function Lockon()
	local wep = net.ReadEntity()
	local ent = net.ReadEntity()
	if !wep:IsValid() or !ent:IsValid() then return end
	wep:SetTarget(ent)
	if wep.CurTarget == nil then
		wep:SetLock(0)
	else
		wep:SetLock(1)
	end
end
net.Receive("Lockon",Lockon)


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

		--Sec Draw
		local cenOffsetX = (ScrW() / 25)
		local cenOffsetY = (ScrH() / 18)
		local posx = ScrW()/2 + cenOffsetX
		local posy = ScrH()/2 + cenOffsetY
		local offset = draw.GetFontHeight("EPTarget")/2

		local pos
		if (self.CurTarget != nil and self.CurTarget:IsValid()) then
			local vecPos, ang = self.CurTarget:GetBonePosition(self.CurTarget:LookupBone("ValveBiped.Bip01_Head1") or 12)
			vecPos = vecPos + Vector(0,0,5)
			pos = vecPos:ToScreen()
		end

		if (self:GetLockTime() > 0) then
			if (self.CurTarget != nil and self.CurTarget:IsValid()) then
				surface.SetDrawColor( 255, 100, 100, 200 )
				local offtime = (self.TimeToLock-self:GetLockTime())*2
				local percent = math.floor(100-((self.TimeToLock-self:GetLockTime())/6)*10)
				surface.DrawOutlinedRect( (pos.x-((ScrW()/128)+offtime/4)), pos.y-((ScrW()/128)+offtime/4), (ScrW()/math.Clamp(offtime,64,128))+offtime/2, (ScrW()/math.Clamp(offtime,64,128))+offtime/2)
				--draw.SimpleTextOutlined( percent.."%" , "EPTarget", posx , posy + (offset), Color(255, 100, 100, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end
		end

		if (self:GetLock() == 1) then
			if (self.CurTarget != nil and self.CurTarget:IsValid()) then
				surface.SetDrawColor( 255, 10, 10, 200 )
				surface.DrawOutlinedRect( pos.x-(ScrW()/128), pos.y-(ScrW()/128), (ScrW()/64), (ScrW()/64))
				surface.DrawLine( pos.x-(ScrW()/128), pos.y-(ScrW()/128), pos.x+(ScrW()/128)-1, pos.y+(ScrW()/128)-1 )
				surface.DrawLine( pos.x-(ScrW()/128), pos.y+(ScrW()/128)-1, pos.x+(ScrW()/128), pos.y-(ScrW()/128)-1 )
				--draw.SimpleTextOutlined( "LOCKED" , "EPTarget", posx , posy + (offset), font_colors.ghost, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, font_colors.black)
			end
		end
		self:DrawAmmo()
		self:DrawCross()

		local gap = self.ZoomCone*ScrW()/(0.15/self.ZoomAmt)

		--Turn them into ints to prevent ugly drawing.
		gap = math.floor(gap)

		--draw the second crosshair

		local x = math.floor(ScrW() / 2)
		local y = math.floor(ScrH() / 2)
		local offset = math.floor(ScrW()/256)
		gap = math.Clamp(gap, offset*2.1, 500)
		local width = math.floor(math.Clamp(gap/2, offset, 500))
		local leftpos = x - gap
		local rightpos = x + gap
		--Left
		surface.DrawLine( leftpos, y, leftpos - offset, y )
		surface.DrawLine( leftpos, y + width, leftpos, y - width )
		surface.DrawLine( leftpos, y + width, leftpos + offset, y + width )
		surface.DrawLine( leftpos, y - width, leftpos + offset, y - width )

		--Right
		surface.DrawLine( rightpos, y, rightpos + offset, y )
		surface.DrawLine( rightpos, y + width, rightpos, y - width )
		surface.DrawLine( rightpos, y + width, rightpos - offset, y + width )
		surface.DrawLine( rightpos, y - width, rightpos - offset, y - width )

	end

end
