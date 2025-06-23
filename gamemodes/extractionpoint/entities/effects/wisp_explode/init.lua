
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetOrigin()
	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()		
	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 45 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(20,50)
				local vel = AngleRand():Forward()*(mag*mag)
				vel.z = vel.z/2
				particle:SetVelocity( vel )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( 55 )
				particle:SetEndAlpha( 0 )
				local size = math.Rand(20,60)
				particle:SetStartSize( size )
				particle:SetEndSize( size*2 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(0.8,1.2)
				particle:SetColor( 50*brt, 45*brt, 45*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 500 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( true )
				particle:SetBounce( 1 )
					
			end
		end		
		for i=0, 25 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(20,50)
				local vel = AngleRand():Forward()*(mag*mag)
				vel.z = vel.z/2
				particle:SetVelocity( vel )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.6, 1 ) )
				particle:SetStartAlpha( 55 )
				particle:SetEndAlpha( 0 )
				local size = math.Rand(20,60)
				particle:SetStartSize( size )
				particle:SetEndSize( size*1.2 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(1.8,2)
				particle:SetColor( 50*brt, 45*brt, 35*brt ) 
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
			particle:SetDieTime( math.Rand( 0.2, 0.4 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(700,925) ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 220,200,140 ) 
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
			particle:SetDieTime( math.Rand( 0.5, 0.6 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(10,15) ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 220,200,140 )
			particle:SetAirResistance( 200 )
			--particle:SetGravity( AngleRand():Forward()*mag )
			particle:SetCollide( false )
		end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
