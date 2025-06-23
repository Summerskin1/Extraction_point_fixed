ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Gas Nade"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "gassin cunts"
ENT.Instructions	= "Pull pin hold breath"
ENT.MinDamage		= 1
ENT.MaxDamage		= 5

ENT.Gas = false
ENT.GasStart = 0
ENT.RemoveTime = 0

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
	self.Gas		= false
	self:SetDetonateTime(CurTime()+0.5)
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/weapons/w_eq_smokegrenade_thrown.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox`
	self:SetElasticity(-100)
	self:SetFriction(500)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(true)
	end
	
	--self:SetLife(4)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(50, 120, 50), false, 4, 1, 0.2, 1/5*0.5, "trails/smoke.vmt");
	end
	self.Gas = false
end


function ENT:Use( activator, caller )

end


function ENT:Think()
	if self:GetDetonateTime() < CurTime() and !self.Gas then
		self:Detonate()
	end
	if self.Gas == true then
		local targets = ents.FindInSphere(self:GetPos(),160)
		for k,v in pairs(targets) do
			if v:IsValid() and v:IsPlayer() then
				if SERVER then
					local dmginfo = DamageInfo()
					dmginfo:SetDamage(math.Clamp(1500/((v:GetPos()-self:GetPos()):Length()),4,40))
					dmginfo:SetDamageType( DMG_ACID )
					dmginfo:SetAttacker( self.Owner )
					dmginfo:SetInflictor( self.Owner )
					dmginfo:SetDamageForce(Vector(0,0,0))
					v:TakeDamageInfo( dmginfo )
				end
			end
		end
		if CLIENT then
			self.SmokeTimer = self.SmokeTimer or CurTime() + 0.1
			if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
			self.SmokeTimer = CurTime() + 0.003
			local pos = self:GetPos()
			local Ang = self.Entity:GetUp()
			local emitter = self:GetEmitter( pos, false ) 
				local particle = emitter:Add( "particle/smokesprites_0006", pos )
					particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 
					particle:SetGravity( (AngleRand():Forward()*math.random(400,60))) 			
					particle:SetDieTime( math.random( 1, 2 ) ) 			
					particle:SetStartAlpha( 255 ) 	
					particle:SetEndAlpha( 0 )		
					particle:SetStartSize( math.random(5,10) ) 			
					particle:SetEndSize( math.random(40,70) ) 			
					particle:SetRoll( math.random(0,360) ) 			
					particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
					particle:SetColor( math.random(39,50), math.random(80,110), math.random(39,50) ) 			
					--particle:VelocityDecay( false )		
					particle:SetAirResistance( 200 )
					particle:SetCollide( true )
					particle:SetBounce( 1 )
		end
	end
    self:NextThink( CurTime() + 0.5 )
    return true
end	

function ENT:GetEmitter( Pos, b3D ) 
	if ( self.Emitter ) then	 
		if ( self.EmitterIs3D == b3D && self.EmitterTime > CurTime() ) then 
			return self.Emitter 
		end 
		end 
	self.Emitter = ParticleEmitter( Pos, b3D ) 
	self.EmitterIs3D = b3D 
	self.EmitterTime = CurTime() + 2 
	return self.Emitter 
end  

function ENT:Detonate()
	if self.Gas then return end
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetEntity( self )
	
	self.Gas = true
	--util.Effect( "gas_area", effectdata )	 //Flak asploud
	if SERVER then
		self.Entity:EmitSound("weapons/flaregun/fire.wav")
		timer.Simple( 10, function() 
			if self && self:IsValid() then
				self:Remove()
			end
		end )
	end
end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "DetonateTime" );
	self:NetworkVar( "Bool", 1, "Dead" );

end

