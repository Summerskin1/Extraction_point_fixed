
--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	NumParticles = 50
		
	local vPos = data:GetOrigin()
	local vel = Vector(0,0,0)
	if data:GetEntity():IsValid() then
		vel = data:GetEntity():GetVelocity()
	end
	local emitter = ParticleEmitter( vPos )
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "sprites/light_glow02_add", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( (vel*math.Rand(-0.3,1.0))+ang:Forward()*200 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 14 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(250, 150, 60) 	
				particle:SetAirResistance( 200 )
				particle:SetGravity( ang:Forward()*-200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		for i=0, NumParticles do
		
			local particle = emitter:Add( "sprites/light_glow02_add", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( (vel*math.Rand(-0.1,0.7))+ang:Forward()*150 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 40 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(250, 150, 60) 	
				particle:SetAirResistance( 200 )
				particle:SetGravity( ang:Forward()*-200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		for i=0, NumParticles/2 do
		
			local particle = emitter:Add( "sprites/light_glow02_add", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( (vel*math.Rand(-0.1,0.3))+ang:Forward()*50 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 40 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(100, 100, 255) 	
				particle:SetAirResistance( 200 )
				particle:SetGravity( ang:Forward()*-100 )
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
