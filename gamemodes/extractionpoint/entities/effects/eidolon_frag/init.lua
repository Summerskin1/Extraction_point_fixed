
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetOrigin()
	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()		
	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 20 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(00,400)
				particle:SetVelocity( (AngleRand():Forward()*mag)+Vector(0,0,math.Rand(-100,600) ))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 2, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 250 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 14, 20 ) )
				particle:SetEndSize( math.Rand( 40, 100 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local brt = math.Rand(0.8,1.2)
				particle:SetColor( 48*brt,5*brt, 4*brt ) 
				particle:SetLighting(false)
				particle:SetAirResistance( 500 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
					
			end
		end		
		for i=1,90 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(100,500)
			particle:SetVelocity( (AngleRand():Forward()*mag) ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 1, 2 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand(1,2) ) 
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
