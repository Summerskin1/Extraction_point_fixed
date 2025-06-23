
EFFECT.Mat = Material( "trails/laser.vmt" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition = data:GetOrigin()
	self.Thick = 90
	self.Start = CurTime()
	self.End = CurTime()+0.4
	self.BeamsStart = {}
	self.BeamsEnd = {}
	
	
	for i=0, 9 do
		local currentPos = self.StartPosition
		local core = VectorRand()*70
		for j=0, 5 do
			self.BeamsStart[j+i*3] = currentPos
			core.z = core.z/2
			currentPos = currentPos + Vector(math.Rand(-10,10),math.Rand(-10,10),math.Rand(-50,50))+core
			self.BeamsEnd[j+i*3] = currentPos
		end
	end
	
	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,5 do
			
		local particle = self.Emitter:Add( "particle/smokesprites_0006", self.StartPosition ) 
 		 local mag = math.Rand(2,3)
		 local vel = (AngleRand():Forward() * 100 * mag)
		 vel.z = vel.z/2
		particle:SetVelocity( vel ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( math.Rand(0.2,0.4) ) 
	 	particle:SetStartAlpha( 100 ) 
	 	particle:SetEndAlpha( 0 ) 
		particle:SetRoll( math.Rand(0, 360) )
	 	particle:SetStartSize( (10-mag)*4 ) 
	 	particle:SetEndSize( (10-mag)*6 ) 
	 	particle:SetColor( 200,200,255 ) 
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector(0,0,math.Rand(30,50)))
		particle:SetCollide( true )		
	end
	for i=1,20 do
			
		local particle = self.Emitter:Add( "particle/smokesprites_0006", self.StartPosition ) 
 		 local mag = math.Rand(2,3)
		 local vel = (AngleRand():Forward() * 100 * mag)
		 vel.z = vel.z/2
		particle:SetVelocity( vel ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( math.Rand(1.5,3) ) 
	 	particle:SetStartAlpha( 100 ) 
	 	particle:SetEndAlpha( 0 ) 
		particle:SetRoll( math.Rand(0, 360) )
	 	particle:SetStartSize( (10-mag)*4 ) 
	 	particle:SetEndSize( (10-mag)*10 ) 
	 	particle:SetColor( 100,100,150 ) 
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector(0,0,math.Rand(30,50)))
		particle:SetCollide( true )		
	end
	
	for i=1,30 do
			
		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
 		 local mag = math.Rand(1,6)
		 local vel = (AngleRand():Forward() * 300 * mag)
		 vel.z = vel.z/2
		particle:SetVelocity( vel ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( math.Rand(0.2,0.3) ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( 400/mag ) 
	 	particle:SetEndSize( 0 ) 
	 	particle:SetColor( 120,120,255 ) 
		particle:SetAirResistance( 300 )
		particle:SetGravity( VectorRand() * 500+Vector(0,0,-100) )
		particle:SetCollide( false )		
	end
	for i=1,200 do
			
		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
 		 local mag = math.Rand(2,3)
		 local vel = (AngleRand():Forward() * 150 * mag)
		 vel.z = vel.z/4
		particle:SetVelocity( vel ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( math.Rand(0.5,1.5) ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( 10-mag ) 
	 	particle:SetEndSize( 0 ) 
	 	particle:SetColor( 120,120,255 ) 
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
		particle:SetCollide( true )		
	end
	
	
	self.Emitter:Finish()
	data:GetEntity():EmitSound("weapons/stunstick/stunstick_fleshhit1.wav", self.StartPosition, 120, 100)
	data:GetEntity():EmitSound("Stunstick.Impact", self.StartPosition, 120, 100)
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		return false
	end
	
	self.Thick = (self.End-CurTime())*20

	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	for i=0, 9 do
		for j=0, 5 do
			render.DrawBeam( self.BeamsStart[j+i*3], self.BeamsEnd[i+j*3], self.Thick*(3-math.abs(1-j)), 0, 0, Color( 120,120,255, math.Clamp(100*self.Thick,0,255) ) )
			render.DrawBeam( self.BeamsStart[j+i*3], self.BeamsEnd[i+j*3], self.Thick*(3-math.abs(1-j)), 0, 0, Color( 120,120,255, math.Clamp(100*self.Thick,0,255) ) )
		end
	end
end
