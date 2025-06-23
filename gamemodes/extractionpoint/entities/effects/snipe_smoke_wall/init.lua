
EFFECT.Mat = Material( "trails/smoke" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 30
	self.Start = CurTime()
	self.End = CurTime()+1.2

	self.Dir = (data:GetOrigin()- data:GetStart()):Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
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
	render.DrawBeam( self.StartPosition+Vector(0,0,(CurTime()-self.Start)*10), self.EndPosition+Vector(0,0,(CurTime()-self.Start)*10), (1+CurTime()-self.Start)*4, 0, 0, Color( 130,130,130, math.Clamp(5*self.Thick,0,255) ) )
end
