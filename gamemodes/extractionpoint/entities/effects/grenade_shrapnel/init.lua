
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	local effectdata = EffectData()
	effectdata:SetStart( self.StartPosition )
	effectdata:SetOrigin( self.EndPosition )
	effectdata:SetScale( math.Rand(2000,6000) )
	util.Effect( "Tracer", effectdata )
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
				local mag = math.Rand(100,200)
				particle:SetVelocity( dir*mag*6+(VectorRand()*30) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.3, 1 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 9, 12 )*((200-mag)/100) )
				particle:SetEndSize( math.Rand( 9, 12 )*((200-mag)/30) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand(10,20)
				particle:SetColor(50+bright,50+bright,50+bright) 	
				particle:SetLighting(true)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( true )
				particle:SetBounce( 0.3 )
					
			end
		end		
		local dlight = DynamicLight( 760 )
		if ( dlight ) then
			dlight.Pos = self.StartPosition
			dlight.r = 255
			dlight.g = 255
			dlight.b = 120
			dlight.Brightness = 1
			dlight.Size = 500
			dlight.Decay = 2000
			dlight.DieTime = CurTime() + 1
		end
end

function EFFECT:Think()
		return false
end

function EFFECT:Render()
end
