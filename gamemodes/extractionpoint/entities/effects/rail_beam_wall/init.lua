
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 30
	self.Start = CurTime()
	self.End = CurTime()+0.3

	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )			
	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 10 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(0,200)
				particle:SetVelocity( dir*mag*6+(AngleRand():Forward())*mag+dir*20 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 2, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 7, 9 ) )
				particle:SetEndSize( math.Rand( 15, 40 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand(150,250)
				particle:SetColor(bright,bright,bright) 	
				particle:SetLighting(true)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end		
		for i=1,20 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(0,100)
			particle:SetVelocity( dir*mag*15+(AngleRand():Forward())*mag+dir*100 ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.2, 0.4 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( 4 ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 255,255,120 ) 
				
			particle:SetAirResistance( 300 )
			particle:SetGravity( (AngleRand():Forward())*80+ Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
		end
		for i=0, 3 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.EndPosition )
			if (particle) then
				local mag = math.Rand(0,-100)
				particle:SetVelocity( dir*mag*6+(AngleRand():Forward())*mag+dir*20 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 2, 3 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 7, 9 ) )
				particle:SetEndSize( math.Rand( 15, 40 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand(150,250)
				particle:SetColor(bright,bright,bright) 	
				particle:SetLighting(true)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end
		local dlight = DynamicLight( 731 )
		if ( dlight ) then
			dlight.Pos = self.StartPosition
			dlight.r = 255
			dlight.g = 255
			dlight.b = 120
			dlight.Brightness = 1
			dlight.Size = 256
			dlight.Decay = 500
			dlight.DieTime = CurTime() + 0.5
		end
		local dlight = DynamicLight( 732 )
		if ( dlight ) then
			dlight.Pos = self.EndPosition
			dlight.r = 255
			dlight.g = 255
			dlight.b = 120
			dlight.Brightness = 1
			dlight.Size = 256
			dlight.Decay = 500
			dlight.DieTime = CurTime() + 0.5
		end
	
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		return false
	end
	
	self.Thick = (self.End-CurTime())*30

	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*18, 0, 0, Color( 255,255,130, math.Clamp(50*self.Thick,0,255) ) )
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*18, 0, 0, Color( 255,255,130, math.Clamp(50*self.Thick,0,255) ) )
end
