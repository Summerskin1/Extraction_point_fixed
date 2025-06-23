
EFFECT.Mat = Material( "trails/laser.vmt" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 30
	self.Start = CurTime()+0.2

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
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,6 do
			
		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
 		 
		particle:SetVelocity( VectorRand() * 20 ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( 0.5 ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( 4 ) 
	 	particle:SetEndSize( 0 ) 
	 	particle:SetColor( 255, 220, 150 ) 
			
		particle:SetAirResistance( 250 )
		particle:SetGravity( VectorRand() * 20 )
		particle:SetCollide( false )
		
		for i=1,3 do
			
			local particle = self.Emitter:Add( "sprites/light_glow02_add", self.EndPosition ) 
	 		 
		 	particle:SetVelocity( VectorRand() * 50 ) 
		 	particle:SetLifeTime( 0 ) 
		 	particle:SetDieTime( 0.5 ) 
		 	particle:SetStartAlpha( 255 ) 
		 	particle:SetEndAlpha( 0 ) 
		 	particle:SetStartSize(  math.random(7,10) ) 
		 	particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-100, 100) )
		 	particle:SetColor( 255, 220, 150 ) 
				
			particle:SetAirResistance( 300 )
			particle:SetGravity( VectorRand() * 20 )
			particle:SetCollide( false )
			particle:SetBounce( 0.8 )
			
		end
			
	end
	
	self.Emitter:Finish()
	
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		return false
	end
	
	self.Thick = (self.Start-CurTime())*30

	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPosition, self.EndPosition, self.Thick, 0, 0, Color( 255, 220, 150, 255 ) )
end
