
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 200
	self.Start = CurTime()
	self.End = CurTime()+0.3
	
	if !data:GetEntity():IsValid() then return end
	local owner = data:GetEntity():GetOwner()
	if owner == nil then return end
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
	
	local effectdata = EffectData()
	effectdata:SetStart( self.StartPosition )
	effectdata:SetOrigin( self.EndPosition )
	effectdata:SetScale( 7000 )
	util.Effect( "AirboatGunTracer", effectdata )
	
	self.Dir = (self.StartPosition- self.EndPosition)
	self.Dir:Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
		for i=0, 8 do
			local particle = emitter:Add( "particle/smokesprites_0006" , self.StartPosition )
			if (particle) then
				local mag = math.Rand(0,50)
				particle:SetVelocity( dir*mag*3+(AngleRand():Forward()*(80-mag)))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 1 ) )
				particle:SetStartAlpha( math.Rand( 50, 100 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 4,6 ) )
				particle:SetEndSize( 15 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )	
				particle:SetColor(150,150,150)
				particle:SetAirResistance( 200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end
		for i=1,50 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
			if (particle) then
				local mag = math.Rand(0,100)
				particle:SetVelocity( dir*mag*5+(AngleRand():Forward()*(120-mag)))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 2 ) )
				particle:SetStartAlpha( math.Rand( 50, 100 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 1,2 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetColor(255,200,100)
				particle:SetRollDelta( 0 )	
				particle:SetAirResistance( 200 )
				particle:SetGravity( AngleRand():Forward()*40 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end
		for i=0, 2 do
			local particle = emitter:Add( "effects/strider_pinch_dudv" , self.StartPosition )
			if (particle) then
				local mag = math.Rand(0,50)
				particle:SetVelocity( dir*mag*10+(AngleRand():Forward()*(80-mag)))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 0.3 ) )
				particle:SetStartAlpha( math.Rand( 20, 40 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 10,20 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )	
				particle:SetAirResistance( 200 )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
			end
		end
		for i=0, 10 do
			local particle = emitter:Add( "particle/smokesprites_0006", self.EndPosition )
			if (particle) then
				local mag = math.Rand(-0,-40)
				particle:SetVelocity( dir*mag*5+2*(AngleRand():Forward()*(60+mag)))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 1 ) )
				particle:SetStartAlpha( math.Rand( 30,60 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( (mag+250)/30 )
				particle:SetEndSize( (mag+250)/10 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(150,150,150)
				particle:SetAirResistance( 200 )
				particle:SetCollide( true )
				particle:SetBounce( 0.3 )
			end
		end
		for i=0, (self.StartPosition-self.EndPosition):Length()/5 do
			local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
			if (particle) then
				--particle:SetVelocity( dir*math.Rand(0,5)+(AngleRand():Forward()*math.Rand(3,20)))
				particle:SetPos( self.StartPosition - self.Dir*math.Rand(0,(self.StartPosition-self.EndPosition):Length()))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0, 1.0 ) )
				particle:SetStartAlpha( math.Rand( 5,30 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(3,8) )
				particle:SetEndSize( 12 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				particle:SetColor(150,150,150)
				particle:SetAirResistance( 200 )
			end
		end
		for i=1,100 do
			local particle = emitter:Add( "sprites/light_glow02_add", self.EndPosition ) 
			if (particle) then
				local mag = math.Rand(-0,-130)
				particle:SetVelocity( dir*mag*1+2*(AngleRand():Forward()*(130+mag)))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.3, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 30,60 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 1,2 )  )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetColor(255,200,100)
				particle:SetRollDelta( 0 )
				particle:SetAirResistance( 200 )
				particle:SetGravity( AngleRand():Forward()*40 )
				particle:SetCollide( true )
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

end
