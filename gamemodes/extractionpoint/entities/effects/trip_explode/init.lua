
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetOrigin()
	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()		
	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 10 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(10,30)*math.Rand(10,30)
				particle:SetVelocity( (AngleRand():Forward()*mag) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 2, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 250 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 10, 90 )+3*(9-mag/100) )
				particle:SetEndSize( math.Rand( 25, 40 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(0.8,1.2)
				particle:SetColor( 48*brt, 38*brt, 28*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 1 )
					
			end
		end		
		for i=0, 10 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(10,30)*math.Rand(10,30)
				particle:SetVelocity( (AngleRand():Forward()*mag) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 0.3 ) )
				particle:SetStartAlpha( math.Rand( 200, 250 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 10, 90 )+3*(9-mag/100) )
				particle:SetEndSize( math.Rand( 25, 40 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(3,4)
				particle:SetColor( 48*brt,38*brt, 18*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 1 )
					
			end
		end		
		for i=1,10 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(0,200)
			particle:SetVelocity( (AngleRand():Forward()*mag) ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.2, 0.3 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(250,300) ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 255,155,55 ) 
			particle:SetAirResistance( 300 )
			particle:SetGravity( (AngleRand():Forward())*80+ Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
		end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
