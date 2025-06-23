if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName			= "Knife"			
   SWEP.Author				= "Cooldown Studios"

   SWEP.Slot				= 0
   SWEP.SlotPos			= 0

   SWEP.Icon = "VGUI/ep/sample"
   SWEP.WeaponDesc = "Melee weapon\nCan be parried with good timing!\nBonus damage on a backstab!"
   SWEP.PrimaryInstruction = "Quick attack/Parry"
   SWEP.SecondaryInstruction = "Powerful attack"
   SWEP.CamPos = Vector(45,25,10)
   SWEP.LookPos = Vector(3,0,6)
   SWEP.IconLetter = "j"
end

SWEP.Base				= "weapon_ep_base"


--SWEP.Kind = WEAPON_PISTOL
--SWEP.WeaponID = AMMO_DEAGLE


SWEP.BodyDamage = 40
SWEP.HeadDamage = 110

SWEP.ScopeInTime = 0.1
SWEP.ZoomAmt = 1.3
SWEP.ZoomCone = 0.002
SWEP.NormalCone = 0.03
SWEP.ZoomSensitivity = 2

SWEP.ZoomPos = Vector(-3.0, -6, 0.5)

SWEP.ViewModel			= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ViewModelFlip		= false

SWEP.ViewModelFOV		= 55

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Clips       	= 0
SWEP.Primary.MaxClips       = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HideAmmo = true

SWEP.HitDistance = 130
local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Flesh.BulletImpact" )


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

function SWEP:Initialize()

	self:SetWeaponHoldType( "knife" )

end


function SWEP:Holster()
	if self.Weapon:GetNextPrimaryFire() < CurTime() then 
		return true
	else 
		return false
	end
end
function SWEP:Deploy()
	self:SetScoped( false )
	self.ReloadFailed = false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW ) 
	if CLIENT then
		self:WeaponInfo()
	end
	if IsFirstTimePredicted() then
		player_manager.RunClass(self.Owner,"MultiplyMoveSpeed",1.1)
	end
end


function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.8 )
	self:SetNextSecondaryFire( CurTime() + 0.8 )
	local stab = false
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  
	vm:SetPlaybackRate(0.7)
	local delay = 0.1
	
	if !self:CanPrimaryAttack() then return end
	if !IsFirstTimePredicted() then return end
	
	self.Weapon:SetBlockTime(CurTime())
	timer.Simple( delay, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self || CLIENT ) then return end
		self.Owner:EmitSound( SwingSound )		
		self.Owner:ViewPunch( Angle( -5, -10, -5 ) )
		self:DealDamage( true )
	end )
	timer.Simple( 0.7, function()
		if self and self:IsValid() then 
			self:SendWeaponAnim( ACT_VM_IDLE ) 
		end
	end)
end
function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1.5 )
	self:SetNextSecondaryFire( CurTime() + 1.5 )
	local stab = true
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	self:SendWeaponAnim( ACT_VM_MISSCENTER )  
	vm:SetPlaybackRate(0.7)
	local delay = 0.3
	
	if !self:CanPrimaryAttack() then return end
	if !IsFirstTimePredicted() then return end
	
	timer.Simple( delay, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self || CLIENT ) then return end
		self.Owner:EmitSound( SwingSound )		
		self.Owner:ViewPunch( Angle( -12, 16, -10 ) )
		self.Owner:LagCompensation( false )
		self:DealDamage( false )
		self.Owner:LagCompensation( false )
	end )
	timer.Simple( 1.4, function()
		if self and self:IsValid() then 
			self:SendWeaponAnim( ACT_VM_IDLE ) 
		end
	end)
end

function SWEP:DealDamage( primary )
	local dist = self.HitDistance
	if ( primary ) then
		dist = self.HitDistance*0.7
	else
		dist = self.HitDistance
	end
	if player_manager.RunClass(self.Owner,"RevenantBehaviour") then
		dist = dist*1.3
	end
	
	self.Owner:LagCompensation( true )
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
			filter = self.Owner,
			mins = Vector( -16, -16, -16 ),
			maxs = Vector( 16, 16, 16 )
		} )
	end
	self.Owner:LagCompensation( false )

	if ( tr.Hit ) then 
		--self.Owner:EmitSound( HitSound ) 
		--print(tr.Entity:GetClass())
		if ( tr.Entity:GetClass() == "func_breakable_surf" ) then
			tr.Entity:Fire( "break" )
		end
		if tr.Entity:IsPlayer() || tr.Entity:IsNPC() then
			if self.Owner:OnGround() then
				local relative = (tr.Entity:GetPos()-self.Owner:GetPos())
				if ( primary ) then
					local lunge = relative/relative:Length()*300
					if player_manager.RunClass(self.Owner,"RevenantBehaviour") then --Bonus lunge distance.
						lunge = lunge*3
					end
					lunge.z = 0
					self.Owner:SetVelocity(lunge)
				else
					local lunge = relative/relative:Length()*700
					if player_manager.RunClass(self.Owner,"RevenantBehaviour") then --Bonus lunge distance.
						lunge = lunge*3
					end
					lunge.z = 0
					self.Owner:SetVelocity(lunge)
				end
			end
		else
			--self.Weapon:EmitSound( "ambient/machines/slicer3.wav", 60, math.Rand(70,80 )) Removed because chengs got foncuszx
			local phys = tr.Entity:GetPhysicsObject()
			if phys then
				if primary then
					phys:ApplyForceOffset( self.Owner:GetAimVector()*300, self.Owner:GetShootPos() ) 
				else
					phys:ApplyForceOffset( self.Owner:GetAimVector()*1500, self.Owner:GetShootPos() ) 
				end
			end
		end
	end
	if ( IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 || tr.Entity:GetClass() == "ep_swat_shield") ) then
		local dmginfo = DamageInfo()
		local backstab = false
		local parry = false
		if tr.Entity:GetClass() == "ep_swat_shield" then
			self.Weapon:EmitSound("physics/metal/metal_solid_impact_bullet4.wav" )
			parry = true
		end
		if tr.Entity:IsPlayer() then
			local ang1 = tr.Entity:GetAimVector():Angle().y
			local ang2 = self.Owner:GetAimVector():Angle().y
			if math.abs(ang1-ang2) < 40 || math.abs(ang1-ang2) > 320  then
				backstab = true
				self.Weapon:EmitSound( "ambient/machines/slicer1.wav" )
			end
			if !backstab then
				local gun = tr.Entity:GetActiveWeapon()
				if gun:GetClass() == "weapon_ep_knife" then
					if (math.abs(ang1-ang2) > 120 && math.abs(ang1-ang2) < 230)  then --If they're in the parry angle.
						if primary then
							if gun:GetBlockTime()+0.25 > CurTime() then
								parry = true
								self.Weapon:EmitSound( "physics/metal/metal_solid_impact_bullet4.wav")
							end
						else
							if gun:GetBlockTime()+0.5 > CurTime() then
								parry = true
								self.Weapon:EmitSound("physics/metal/metal_solid_impact_bullet4.wav" )
							end
						end
					end
				end
			end
			--Friendly fire protection, disabled for now to allow knifefights
			--if tr.Entity:Team() == self.Owner:Team() then
				--parry = true
				--backstab = false
			--end
		end
		dmginfo:SetDamage( 25 )
		if tr.Entity:IsNPC() then
			dmginfo:SetDamage( 15 ) -- Weaker vs npcs
		end
		if backstab then
			dmginfo:SetDamage( 35 )
			if player_manager.RunClass(tr.Entity,"RevenantBehaviour") then --Bonus damage on revenant backstabs.
				dmginfo:SetDamage( 150 )
			end
		end
		if ( primary ) then
		--	dmginfo:SetDamageForce( self.Owner:GetRight() * 49125 + self.Owner:GetForward() * 99984 ) -- Yes we need those specific numbers
		--else
		--	dmginfo:SetDamageForce( self.Owner:GetUp() * 51589 + self.Owner:GetForward() * 100128 )
			dmginfo:SetDamageForce( self.Owner:GetRight() * 500 + self.Owner:GetForward() * 5000 ) -- Yes we need those specific numbers
			if parry then
				--Disorientating recoil when we get parried on a power swing.
				self.Owner:ViewPunch( Angle( math.Rand(-10,10), math.Rand(-10,10), 0 ) )
				if ((not game.SinglePlayer()) and IsFirstTimePredicted()) then
					local eyeang = self.Owner:EyeAngles()
					eyeang.pitch = eyeang.pitch + math.Rand(-1,1)
					eyeang.yaw = eyeang.yaw + math.Rand(-1,1)
					self.Owner:SetEyeAngles( eyeang )
				end
			end
		else
			dmginfo:SetDamageForce( self.Owner:GetUp() * 100 + self.Owner:GetForward() * 8000 )
			dmginfo:SetDamage( 70 )
			if tr.Entity:IsNPC() then
				dmginfo:SetDamage( 40 ) -- Weaker vs npcs
			end
			if backstab then
				dmginfo:SetDamage( 130 )
				if player_manager.RunClass(tr.Entity,"RevenantBehaviour") then --Bonus damage on revenant backstabs.
					dmginfo:SetDamage( 600 )
				end
					
				local ed = EffectData()
					ed:SetOrigin(tr.Entity:GetPos()+Vector(0,0,20))
				util.Effect("bloodimpact",ed)
				local ed = EffectData()
					ed:SetOrigin(tr.Entity:GetPos()+Vector(0,0,25))
				util.Effect("bloodimpact",ed)
				local ed = EffectData()
					ed:SetOrigin(tr.Entity:GetPos()+Vector(0,0,30))
				util.Effect("bloodimpact",ed)
			end
			if parry then
				--Disorientating recoil when we get parried on a power swing.
				self.Owner:ViewPunch( Angle( math.Rand(-50,50), math.Rand(-50,50), 0 ) )
				if ((not game.SinglePlayer()) and IsFirstTimePredicted()) then
					local eyeang = self.Owner:EyeAngles()
					eyeang.pitch = eyeang.pitch + math.Rand(-10,10)
					eyeang.yaw = eyeang.yaw + math.Rand(-10,10)
					self.Owner:SetEyeAngles( eyeang )
					self:SetNextPrimaryFire(CurTime()+2.5)
				end
			end
		end
		if parry then
			dmginfo:SetDamage(0) 
			local ed = EffectData()
				ed:SetStart(self.Owner:GetShootPos()+self.Owner:GetAimVector()*20)
				ed:SetOrigin(self.Owner:GetShootPos()+self.Owner:GetAimVector()*20)
			util.Effect("cball_bounce",ed)
		elseif (tr.Entity:IsPlayer() || tr.Entity:IsNPC()) then
			self.Weapon:EmitSound( "ambient/machines/slicer4.wav", 40, math.Rand(110,160) )
			local ed = EffectData()
				ed:SetOrigin(tr.HitPos+Vector(0,0,10))
			util.Effect("bloodimpact",ed)
		end
		if (!tr.Entity:IsPlayer() && !tr.Entity:IsNPC()) then
			dmginfo:SetDamage( 100 ) --Massive damage to non players, to break shit first try.
		end
		dmginfo:SetInflictor( self )
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		tr.Entity:TakeDamageInfo( dmginfo )
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "BlockTime" )
	self:NetworkVar( "Bool", 1, "Scoped" )
end
