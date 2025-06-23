
EFFECT.Mat = Material( "effects/tool_tracer" )

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
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*10, 0, 0, Color( 100,130,255, math.Clamp(50*self.Thick,0,255) ) )
	render.DrawBeam( self.StartPosition, self.EndPosition, (1+CurTime()-self.Start)*10, 0, 0, Color( 200,200,255, math.Clamp(50*self.Thick,0,255) ) )
end
