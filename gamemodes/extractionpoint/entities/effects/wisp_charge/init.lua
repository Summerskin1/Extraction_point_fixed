
EFFECT.Mat = Material( "trails/laser.vmt" )

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()
	self.EndPosition = data:GetOrigin()
	self.Thick = 90
	self.Start = CurTime()
	self.End = CurTime()+1.2
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
	if self.End < CurTime() then
		self.Emitter:Finish()
		return false			
	end
	self.LastEmit = self.LastEmit or 0
	local mult = 1*(1+CurTime()-self.Start)
	if self.LastEmit < CurTime() then
		self.LastEmit = CurTime()+0.04
			local particle = self.Emitter:Add( "particle/smokesprites_0006", self.Owner:GetPos() ) 
			 local mag = math.Rand(2,3)
			 local vel = (AngleRand():Forward() * 30 * mag*mult)
			 vel.z = vel.z/2
			particle:SetVelocity( self.Owner:GetVelocity() ) 
			particle:SetLifeTime( 0 ) 
			particle:SetDieTime( math.Rand(0.3,0.5) ) 
			particle:SetStartAlpha( 100 ) 
			particle:SetEndAlpha( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetStartSize( (10-mag)*2*mult ) 
			particle:SetEndSize( (10-mag)*5*mult ) 
			particle:SetColor( 250,220,150 ) 
			particle:SetAirResistance( 150 )
			particle:SetGravity( Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
			particle:SetCollide( true )
			for i=0,5 do
				local particle = self.Emitter:Add( "sprites/light_glow02_add", self.Owner:GetPos() ) 
				 local mag = math.Rand(2,3)
				 local vel = (AngleRand():Forward() * 150 * mag)
				 vel.z = vel.z/4
				particle:SetVelocity( self.Owner:GetVelocity() ) 
				particle:SetLifeTime( 0 ) 
				particle:SetDieTime( math.Rand(0.5,1.5) ) 
				particle:SetStartAlpha( 255 ) 
				particle:SetEndAlpha( 0 ) 
				particle:SetStartSize( (10-mag)*mult) 
				particle:SetEndSize( 0 ) 
				particle:SetColor( 250,220,150 ) 
				particle:SetAirResistance( 100 )
				particle:SetGravity( Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
				particle:SetCollide( true )		
			end

	end
	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
end
