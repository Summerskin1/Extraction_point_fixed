
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetOrigin()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 100
	self.Start = CurTime()
	self.End = CurTime()+0.3

	local view = owner == LocalPlayer()

	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()
	
	
	self.Dir = (data:GetOrigin()- data:GetStart()):Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
		for i=1,2 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(0,10)
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 0.2, 0.4 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( 1 ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 255,255,120 ) 
				
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
