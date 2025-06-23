
EFFECT.Mat = Material( "trails/laser" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 100
	self.Start = CurTime()
	self.End = CurTime()+0.1

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
	
	local effectdata = EffectData()
	effectdata:SetStart( self.StartPosition )
	effectdata:SetOrigin( self.EndPosition )
	effectdata:SetScale( 5000 )
	util.Effect( "Tracer", effectdata )
	
	self.Dir = (data:GetOrigin()- data:GetStart()):Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )	
		
	local vPos = self.StartPosition
	
	local emitter = ParticleEmitter( vPos )
	for i=0, 12 do
		local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
		if (particle) then
			local mag = math.Rand(10,70)
			particle:SetVelocity( dir*mag*3+(AngleRand():Forward())*mag+dir*20 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 0.1, 0.3 ) )
			particle:SetStartAlpha( math.Rand( 30,50 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 2, 3)+(mag/25) )
			particle:SetEndSize( math.Rand( 6, 8 ) )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
			local bright = math.Rand(100,120)
			particle:SetColor(bright+120,bright+70,bright)
			--particle:SetLighting(true)
				particle:SetAirResistance( 300 )
			particle:SetGravity( Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
			particle:SetBounce( 0.3 )			
		end
	end	
	local emitter = ParticleEmitter( vPos )
	for i=0, 5 do
		local particle = emitter:Add( "sprites/light_glow02_add", self.StartPosition )
		if (particle) then
			local mag = math.Rand(10,30)
			particle:SetVelocity( dir*mag*3+(AngleRand():Forward())*mag+dir*20 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 0.1, 0.1 ) )
			particle:SetStartAlpha( math.Rand( 60,80 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 8 ,10 ) )
			particle:SetEndSize( 6 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
			local bright = math.Rand(100,120)
			particle:SetColor(bright+120,bright+70,bright)
			--particle:SetLighting(true)
				particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -50 ) )
			particle:SetCollide( false )
			particle:SetBounce( 0.3 )			
		end
	end	
	for i=0, 12 do	
		local particle = emitter:Add( "particle/smokesprites_0006", self.StartPosition )
		if (particle) then
				local mag = math.Rand(10,70)
				particle:SetVelocity( dir*mag*3+(AngleRand():Forward())*mag+dir*20 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 4 ) )
				particle:SetStartAlpha( math.Rand( 30,50 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 2, 3)+(mag/25) )
				particle:SetEndSize( math.Rand( 8,12 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0 )
				local bright = math.Rand(30,60)
				particle:SetColor(bright,bright,bright)
				--particle:SetLighting(true)
				particle:SetAirResistance( 300 )
				particle:SetGravity( Vector( 0, 0, -50 ) )
				particle:SetCollide( false )
				particle:SetBounce( 0.3 )
					
		end
	end	
end


function EFFECT:Think()
	return false
end

