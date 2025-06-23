function EFFECT:Init( data )
	self.Position = data:GetOrigin()
	self.data = data
	self.endtime = CurTime()+8
	self.lastEmit = CurTime()
	local Pos = self.Position		
	local Norm = Vector(0,0,1)		 	
		self.emitter = ParticleEmitter( Pos )
		for i=0, 0 do
			local particle = self.emitter:Add( "particle/smokesprites_0006", Pos )
				particle:SetVelocity( (AngleRand()):Forward()*math.random(100,200) )			
				particle:SetDieTime( math.random( 2, 3 ) ) 			
				particle:SetStartAlpha( 255 ) 	
				particle:SetEndAlpha( 0 )		
				particle:SetStartSize( math.random(5,10) ) 			
				particle:SetEndSize( math.random(50,100) ) 			
				particle:SetRoll( math.random(0,360) ) 			
				particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
				particle:SetColor( 39, 80, 39 ) 			
				particle:VelocityDecay( false )		
				particle:SetAirResistance( 200 )
		end

end

function EFFECT:Think( )
	local Pos = Vector(0,0,0)
	local Ang = AngleRand()
	if self.data:GetEntity():IsValid() then
		self.Position = self.data:GetEntity():GetPos()
		--self.Position = self.data:GetOrigin()
		Pos = self.Position	
		Ang = self.data:GetEntity():GetUp()
	else
		self.Position = self.data:GetOrigin()
		Pos = self.Position	
	end
	--if self.lastEmit > CurTime()-0.1 then
		for i=1, 1 do
			local particle = self.emitter:Add( "particle/smokesprites_0006", Pos )
				particle:SetVelocity( (Ang*math.random(200,250))+(AngleRand():Forward()*math.random(100,150))) 			
				particle:SetDieTime( math.random( 1, 2 ) ) 			
				particle:SetStartAlpha( 255 ) 	
				particle:SetEndAlpha( 0 )		
				particle:SetStartSize( math.random(5,10) ) 			
				particle:SetEndSize( math.random(40,70) ) 			
				particle:SetRoll( math.random(0,360) ) 			
				particle:SetRollDelta( math.random( -0.1, 0.1 ) ) 			
				particle:SetColor( math.random(39,50), math.random(80,110), math.random(39,50) ) 			
				particle:VelocityDecay( false )		
				particle:SetAirResistance( 200 )
				particle:SetCollide( true )
				particle:SetBounce( 1 )
		end
	--end
		
	if self.endtime < CurTime() then
		return false
	else
		return true
	end
end


function EFFECT:Render()
end



