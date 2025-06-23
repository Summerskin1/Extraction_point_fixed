
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetOrigin()
	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()		
	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 5 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(20,30)
				local vel = AngleRand():Forward()*(mag*mag)
				vel.z = vel.z/2
				particle:SetVelocity( vel )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 1 ) )
				particle:SetStartAlpha( 55 )
				particle:SetEndAlpha( 0 )
				local size = math.Rand(20,40)
				particle:SetStartSize( size )
				particle:SetEndSize( size*2 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(0.8,3)
				particle:SetColor( 50*brt, 50*brt, 50*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 500 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( true )
				particle:SetBounce( 1 )
					
			end
		end		
		for i=0, 15 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(20,30)
				local vel = AngleRand():Forward()*(mag*mag)
				vel.z = vel.z/2
				particle:SetVelocity( vel )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.6, 1 ) )
				particle:SetStartAlpha( 25 )
				particle:SetEndAlpha( 0 )
				local size = math.Rand(20,30)
				particle:SetStartSize( size )
				particle:SetEndSize( size*1.6 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(3,4)
				particle:SetColor( 50*brt, 50*brt, 50*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 500 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( true )
				particle:SetBounce( 1 )
					
					
			end
		end		
		for i=1,10 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(200,400)
			local vel = AngleRand():Forward()*(mag)
			vel.z = vel.z/2
			particle:SetVelocity( vel )
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.2, 0.1 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(100,125) ) 
			particle:SetEndSize( 0 ) 
			local col = math.Rand(0,255)
			particle:SetColor( col,math.Rand(150,200),255 - col ) 
			particle:SetAirResistance( 300 )
			particle:SetGravity( (AngleRand():Forward())*140+ Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
		end
		for i=1,1 do
			local particle = emitter:Add( "effects/strider_pinch_dudv", self.StartPosition ) 
			 
			local mag = math.Rand(200,400)
			local vel = AngleRand():Forward()*(mag)
			vel.z = vel.z/2
			particle:SetVelocity( vel )
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.2, 0.2 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(50,125) ) 
			particle:SetEndSize( 0 ) 
			local col = math.Rand(0,255)
			particle:SetColor( col,math.Rand(150,200),255 - col ) 
			particle:SetAirResistance( 300 )
			particle:SetGravity( (AngleRand():Forward())*140+ Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
		end
		for i=1,100 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(1000,2000)
			local vel = AngleRand():Forward()*(mag)
			vel.z = vel.z/2
			particle:SetVelocity( vel )
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.5, 1 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(5,7) ) 
			particle:SetEndSize( 0 ) 
			local col = math.Rand(0,255)
			particle:SetColor( col,math.Rand(150,200),255 - col ) 
			particle:SetAirResistance( 600 )
			--particle:SetGravity( AngleRand():Forward()*mag )
			particle:SetCollide( false )
		end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
