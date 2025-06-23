
EFFECT.Mat = Material( "trails/laser.vmt" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition = data:GetOrigin()
	self.Thick = 90
	self.Start = CurTime()
	--self.End = CurTime()+1.2
	self.BeamsStart = {}
	self.BeamsEnd = {}
	self.Owner = data:GetEntity()
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	
end
function EFFECT:Think()
	if !self.Owner or !self.Owner:IsValid() then
		self.Emitter:Finish()
		return false			
	end
	self.LastEmit = self.LastEmit or 0
	local mult = 2
	if self.LastEmit < CurTime() then
		self.LastEmit = CurTime()+0.02
			local particle = self.Emitter:Add( "effects/strider_pinch_dudv", self.Owner:GetPos() ) 
			 local mag = math.Rand(2,3)
			 local vel = (AngleRand():Forward() * 30 * mag*mult)
			 vel.z = vel.z/2
			particle:SetVelocity( self.Owner:GetVelocity() ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand(0.3,0.5) ) 
			particle:SetStartAlpha( 20 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetStartSize( 20 ) 
			particle:SetEndSize( 0 ) 
			local col = math.Rand(50,250)
			particle:SetColor( col,math.Rand(50,250),250 - col ) 
			particle:SetAirResistance( 150 )
			--particle:SetGravity( Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
			particle:SetCollide( true )
			for i=0,1 do
				local particle = self.Emitter:Add( "sprites/light_glow02_add", self.Owner:GetPos() ) 
				 local mag = math.Rand(2,3)
				 local vel = Vector(math.Rand(-40,40),math.Rand(-40,40),math.Rand(-40,40))
				 
				particle:SetVelocity(vel) 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( math.Rand(0.5,1.5) ) 
				particle:SetStartAlpha( 255 ) 
				particle:SetEndAlpha( 0 ) 
				particle:SetStartSize( math.Rand(1,3)) 
				particle:SetEndSize( 0 ) 
				local col = math.Rand(0,255)
				particle:SetColor( col,math.Rand(150,200),255 - col ) 
				particle:SetAirResistance( 100 )
				particle:SetGravity( -vel * math.Rand(1,3))
				particle:SetCollide( true )		
				particle:SetNextThink( 1e99 ) -- Makes sure the think hook is used on all particles of the particle emitter
				particle:SetThinkFunction( function( pa )
					local color = math.Rand(0,255)
					pa:SetColor( color,math.Rand(150,200),255 - color ) 
					pa:SetNextThink( 1e99 ) -- Makes sure the think hook is actually ran.
				end )
			end
			for i=0,2 do
				local particle = self.Emitter:Add( "sprites/light_glow02_add", self.Owner:GetPos() ) 
				 local mag = math.Rand(2,3)
				 local vel = Vector(math.Rand(-40,40),math.Rand(-40,40),math.Rand(-40,40))
				 
				particle:SetVelocity(vel) 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( math.Rand(0.1,0.2) ) 
				particle:SetStartAlpha( 255 ) 
				particle:SetEndAlpha( 0 ) 
				particle:SetStartSize( math.Rand(10,32)) 
				particle:SetEndSize( 0 ) 
				local col = math.Rand(0,255)
				particle:SetColor( col,math.Rand(150,200),255 - col ) 
				particle:SetAirResistance( 100 )
				particle:SetGravity( -vel * math.Rand(1,3))
				particle:SetCollide( true )		
				particle:SetNextThink( 1e99 ) -- Makes sure the think hook is used on all particles of the particle emitter
				particle:SetThinkFunction( function( pa )
					local color = math.Rand(0,255)
					pa:SetColor( color,math.Rand(150,200),255 - color ) 
					pa:SetNextThink( 1e99 ) -- Makes sure the think hook is actually ran.
				end )
			end

	end
	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
end
