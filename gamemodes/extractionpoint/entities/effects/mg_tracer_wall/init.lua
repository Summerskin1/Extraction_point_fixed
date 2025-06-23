
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
	
	
	local effectdata = EffectData()
	effectdata:SetStart( self.StartPosition )
	effectdata:SetOrigin( self.EndPosition )
	effectdata:SetScale( 8000 )
	util.Effect( "AR2Tracer", effectdata )
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 3 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				local mag = math.Rand(5,30)
				particle:SetVelocity( dir*mag*10+(AngleRand():Forward())*mag+dir )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 3,5 ) )
				particle:SetEndSize( math.Rand( 7, 9 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand(150,250)
				particle:SetColor(bright,bright,bright) 	
				particle:SetLighting(true)
				particle:SetAirResistance( 200 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end		
		for i=0, 3 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.EndPosition )
			if (particle) then
				local mag = math.Rand(0,-30)
				particle:SetVelocity( dir*mag*3+(AngleRand():Forward())*mag+dir )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 3,5 ) )
				particle:SetEndSize( math.Rand( 7, 9 ) )
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
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*1, 0, 0, Color( 120,140,60, math.Clamp(50*self.Thick,0,255) ) )
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*1, 0, 0, Color( 100,120,150, math.Clamp(50*self.Thick,0,255) ) )
end
