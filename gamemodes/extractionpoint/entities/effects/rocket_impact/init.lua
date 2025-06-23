
--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	NumParticles = 20
		
	local vPos = data:GetOrigin()
	local angle = data:GetAngles()
	local vel = Vector(0,0,0)
	if data:GetEntity():IsValid() then
		vel = data:GetEntity():GetVelocity()
	end
	local emitter = ParticleEmitter( vPos )
	
		for i=0, NumParticles do
			local particle = emitter:Add( "particle/smokesprites_0006", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( ((angle:Forward()*math.Rand(400,-1600))+ang:Forward()*math.Rand(-700,700)) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(20,25) )
				particle:SetEndSize( math.Rand(100,150) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor(40+bright,40+bright, 40+bright) 	
				particle:SetAirResistance( 600 )
				--particle:SetGravity( ang:Forward()*-200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		for i=0, NumParticles*2 do
			local particle = emitter:Add( "particle/smokesprites_0006", vPos )
			if (particle) then
				local ang = angle:Right():Angle()
				ang:RotateAroundAxis(angle:Forward(),math.Rand(0,360))
				particle:SetVelocity( VectorRand( )*200+(ang:Forward()*math.Rand(950,1200) )) 
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(20,25) )
				particle:SetEndSize( math.Rand(70,120) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor(40+bright,40+bright, 40+bright) 
				particle:SetAirResistance( 500 )
				--particle:SetGravity( ang:Forward()*-200 )
				--particle:SetCollide( false )
				--particle:SetBounce( 0.3 )
				
			end
		end
		for i=0, NumParticles do
			local particle = emitter:Add( "particle/smokesprites_0006", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( ((angle:Forward()*math.Rand(400,-1600))+ang:Forward()*math.Rand(-700,700)) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 0.3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(70,95) )
				particle:SetEndSize( math.Rand(100,120) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor(180+bright,160+bright, 120+bright) 
				particle:SetAirResistance( 600 )
				--particle:SetGravity( ang:Forward()*-200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				
			end
			
		end
		for i=0, NumParticles*2 do
			local particle = emitter:Add( "particle/smokesprites_0006", vPos )
			if (particle) then
				local ang = angle:Right():Angle()
				ang:RotateAroundAxis(angle:Forward(),math.Rand(0,360))
				particle:SetVelocity( VectorRand( )*200+(ang:Forward()*math.Rand(950,1200) )) 
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 0.3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(40,45) )
				particle:SetEndSize( math.Rand(60,70) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor(180+bright,160+bright, 120+bright) 	
				particle:SetAirResistance( 500 )
				--particle:SetGravity( ang:Forward()*-200 )
				--particle:SetCollide( false )
				--particle:SetBounce( 0.3 )
				
			end
		end
		for i=0, NumParticles do
			local particle = emitter:Add( "effects/yellowflare", vPos )
			if (particle) then
				local ang = AngleRand()
				particle:SetVelocity( ((vel*math.Rand(-0.2,0.1))+ang:Forward()*math.Rand(0,250))*4 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 0.2 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(50,150) )
				particle:SetEndSize( 50 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor( 255,math.Rand( 200,220),math.Rand( 140,180 ) ) 
				particle:SetAirResistance( 600 )
				--particle:SetGravity( ang:Forward()*-200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
				particle:SetRoll( math.Rand( -90, 90 ) ) 
				
			end
		end
		for i=0, NumParticles do
			local particle = emitter:Add( "effects/yellowflare", vPos )
			if (particle) then
				local ang = angle:Right():Angle()
				ang:RotateAroundAxis(angle:Forward(),math.Rand(0,360))
				particle:SetVelocity( VectorRand( )*200+(ang:Forward()*math.Rand(1000,1100) )) 
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 0.2 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(50,150) )
				particle:SetEndSize( 50 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand( 0,40 )
				particle:SetColor( 255,math.Rand( 200,220),math.Rand( 140,180 ) ) 
				particle:SetAirResistance( 500 )
				particle:SetRoll( math.Rand( -90, 90 ) ) 
				--particle:SetGravity( ang:Forward()*-200 )
				--particle:SetCollide( false )
				--particle:SetBounce( 0.3 )
				
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
