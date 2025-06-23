
--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	NumParticles = 12
		
	local vPos = data:GetOrigin()
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "effects/spark", vPos )
			if (particle) then
			
				particle:SetVelocity( Vector(math.Rand(-80,80),math.Rand(-80,80),math.Rand(-80,80)) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.3, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 3, 6 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(15, 225, 80) 	
				particle:SetAirResistance( 200 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		
	emitter:Finish()
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	return false
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()
end
