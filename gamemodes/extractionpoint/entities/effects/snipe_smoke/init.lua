
EFFECT.Mat = Material( "trails/smoke" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 30
	self.Start = CurTime()
	self.End = CurTime()+1.2

	local owner = data:GetEntity().Owner
	local view = owner == LocalPlayer()

	//If it's the local player we start at the viewmodel
	if ( view ) then
	
		local vm = owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment( 1 )
		if attachment != nil then
			self.StartPosition = attachment.Pos
		end
	
	else
	//If we're viewing another player we start at their weapon
	
		local vm = owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment( 1 )
		if attachment != nil then
			self.StartPosition = attachment.Pos
		end

	end
	
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
