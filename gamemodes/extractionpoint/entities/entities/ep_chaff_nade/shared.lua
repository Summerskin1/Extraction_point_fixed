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
		util.SpriteTrail(self, 0, Color(80,80,120), false, 4, 1, 0.2, 1/5*0.5, "trails/smoke.vmt");
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
		if CLIENT then
			self.SmokeTimer = self.SmokeTimer or CurTime() + 0.1
			if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
			local pos = self:GetPos()
			local Ang = self.Entity:GetUp()
			local emitter = self:GetEmitter( pos, false ) 
				if LocalPlayer():Team() == TEAM_SWAT then
					self.SmokeTimer = CurTime() + 0.03
					
						local particle = emitter:Add( "particle/smokesprites_0006", pos )
						particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 
						particle:SetGravity( (AngleRand():Forward()*math.random(400,60))) 				
						particle:SetDieTime( math.random( 3, 4 ) ) 			
						particle:SetStartAlpha( 80 ) 	
						particle:SetEndAlpha( 0 )		
						particle:SetStartSize( math.random(5,10) ) 			
						particle:SetEndSize( math.random(60,80) ) 			
						particle:SetRoll( math.random(0,360) ) 			
						particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
						particle:SetColor( math.random(39,50), math.random(39,50), math.random(60,90) ) 			
						--particle:VelocityDecay( false )		
						particle:SetAirResistance( 120 )
						particle:SetCollide( true )
						particle:SetBounce( 1 )
						
					for i=0,1 do
						local particle = emitter:Add( "effects/yellowflare", pos ) 
						particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 
						particle:SetGravity( (AngleRand():Forward()*math.random(400,60))) 						
						particle:SetDieTime( math.random( 3, 4 ) ) 			
						particle:SetStartAlpha( 255 ) 	
						particle:SetEndAlpha( 0 )		
						particle:SetStartSize( math.random(1,2) ) 			
						particle:SetEndSize( math.random(0,1) ) 			
						particle:SetRoll( math.random(0,360) ) 			
						particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
						particle:SetColor( math.random(150,160), math.random(150,160), math.random(220,255) ) 			
						--particle:VelocityDecay( false )		
						particle:SetAirResistance( 200 )
						particle:SetCollide( false )
						particle:SetBounce( 1 )
					end
				else
					for i=0,1 do
						self.SmokeTimer = CurTime() + 0.02
						local particle = emitter:Add( "particle/smokesprites_0006", pos )
						particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 
						particle:SetGravity( (AngleRand():Forward()*math.random(400,60))) 				
						particle:SetDieTime( math.random( 3, 4 ) ) 			
						particle:SetStartAlpha( 255 ) 	
						particle:SetEndAlpha( 0 )		
						particle:SetStartSize( math.random(5,10) ) 			
						particle:SetEndSize( math.random(160,230) ) 			
						particle:SetRoll( math.random(0,360) ) 			
						particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
						particle:SetColor( math.random(39,50), math.random(39,50), math.random(60,90) ) 			
						--particle:VelocityDecay( false )		
						particle:SetAirResistance( 90 )
						particle:SetCollide( true )
						particle:SetBounce( 1 )
					end
					for i=0,1 do
						local particle = emitter:Add( "effects/yellowflare", pos ) 
						particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 
						particle:SetGravity( (AngleRand():Forward()*math.random(400,60))) 						
						particle:SetDieTime( math.random( 6, 7 ) ) 			
						particle:SetStartAlpha( 255 ) 	
						particle:SetEndAlpha( 0 )		
						particle:SetStartSize( math.random(1,2) ) 			
						particle:SetEndSize( math.random(0,1) ) 			
						particle:SetRoll( math.random(0,360) ) 			
						particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
						particle:SetColor( math.random(150,160), math.random(150,160), math.random(220,255) ) 			
						--particle:VelocityDecay( false )		
						particle:SetAirResistance( 200 )
						particle:SetCollide( false )
						particle:SetBounce( 1 )
					end
				end
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
		timer.Simple( 20, function() 
			if self then
				self:Remove()
			end
		end )
	end
end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "DetonateTime" );
	self:NetworkVar( "Bool", 1, "Dead" );

end

