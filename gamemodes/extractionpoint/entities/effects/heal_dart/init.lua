
--EFFECT.Mat = Material( "trails/laser" )


function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 100
	self.Start = CurTime()
	self.End = CurTime()+0.3
	if !data:GetEntity() then return end
	local owner = data:GetEntity().Owner
	local view = owner == LocalPlayer()

	local dir = (data:GetOrigin()- data:GetStart())
	dir:Normalize()
	
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
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )	
		for i=1,30 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			 
			local mag = math.Rand(0,100)
			particle:SetVelocity( dir*mag*15 ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 2.1, 2.3 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( 5 ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 40,255,80 ) 
				
			particle:SetAirResistance( 100 )
			particle:SetGravity( (AngleRand():Forward())*80+ Vector( 0, 0, -50 ) )
			particle:SetCollide( true )
		end
		for i=0, 15 do
			
			local particle = emitter:Add( "particle/smokesprites_0006", self.EndPosition )
			if (particle) then
				local mag = math.Rand(0,-250)
				local grav = math.Rand(-100,100)
				particle:SetVelocity( dir*mag )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
				particle:SetStartAlpha( math.Rand( 100, 152 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 7, 9 ) )
				particle:SetEndSize( math.Rand( 16, 18) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-0.1, 0.1) )
				local bright = math.Rand(150,250)
				particle:SetColor(40,bright,80) 	
				particle:SetLighting(true)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, grav )+VectorRand()*40 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end
		
		for i=1,10 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.EndPosition ) 
			 
			local mag = math.Rand(0,-10)
			particle:SetVelocity( dir*mag*15+(AngleRand():Forward())*mag+dir*100 ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand( 2.2, 2.4 )  ) 
			particle:SetStartAlpha( 255 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetStartSize( math.Rand( 6, 12 ) ) 
			particle:SetEndSize( 0 ) 
			particle:SetColor( 40,255,80 ) 
				
			particle:SetAirResistance( 300 )
			particle:SetGravity( (AngleRand():Forward())*80+ Vector( 0, 0, -80 ) )
			particle:SetCollide( true )
		end
		
		local dlight = DynamicLight( 730 )
		if ( dlight ) then
			dlight.Pos = self.EndPosition
			dlight.r = 40
			dlight.g = 255
			dlight.b = 80
			dlight.Brightness = 1
			dlight.Size = 256
			dlight.Decay = 500
			dlight.DieTime = CurTime() + 0.5
		end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end
