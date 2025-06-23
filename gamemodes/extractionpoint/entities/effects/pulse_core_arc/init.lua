EFFECT.Mat = Material( "trails/laser.vmt" )
EFFECT.Angle = nil

function math.QuadraticBezier(p1, p2, p3)
	return function(t)
		t = math.Clamp(t, 0, 1);
		return (1-t)*(1-t)*p1
		+ 2*(1-t)*t*p2
		+ t*t*p3;
	end
end

function math.QuadraticBezier3D(p1, p2, p3)
	local x = math.QuadraticBezier(p1.x, p2.x, p3.x);
	local y = math.QuadraticBezier(p1.y, p2.y, p3.y);
	local z = math.QuadraticBezier(p1.z, p2.z, p3.z);
	return function(t)
		return Vector(x(t), y(t), z(t));
	end
end

function EFFECT:Init( data )
	self.StartPosition 	= data:GetStart()+Vector(0,0,0)
	self.EndPosition	= data:GetOrigin()
	self.Thick = 15
	self.Start = CurTime()+0.3
	self.Bend = AngleRand()
	self.Angle	 = AngleRand()
	self.Size = math.Rand(0.2,0.8)

	self.Dir = (data:GetOrigin()- data:GetStart()):Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,15 do
			
	 	local rand = math.Rand(1,20)
		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
 		 
		particle:SetVelocity( VectorRand() * math.Rand(0,20) ) 
	 	particle:SetLifeTime( 0 ) 
		 particle:SetDieTime( 2/rand ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( rand ) 
	 	particle:SetEndSize( 0 ) 
		local col = math.Rand(0,255)
		particle:SetColor( col,math.Rand(150,200),255 - col ) 
			
		particle:SetAirResistance( 250 )
		particle:SetGravity( VectorRand() * 20 )
		particle:SetCollide( false )
		
			
	end
	timer.Simple(math.Rand(0.08,0.12),function()
	if !self.Emitter then return end
		for i=1,30 do
			
			local particle = self.Emitter:Add( "sprites/light_glow02_add", self.EndPosition ) 
	 		local rand = math.Rand(10,20)
		 	particle:SetVelocity( VectorRand() * math.Rand(0,1000)/rand ) 
		 	particle:SetLifeTime( 0 ) 
		 	particle:SetDieTime( 3/rand ) 
		 	particle:SetStartAlpha( 255 ) 
		 	particle:SetEndAlpha( 255 ) 
		 	particle:SetStartSize( rand ) 
		 	particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-100, 100) )
			local col = math.Rand(0,255)
			particle:SetColor( col,math.Rand(150,200),255 - col ) 
				
			particle:SetAirResistance( 300 )
			particle:SetGravity( VectorRand() * 20 )
			particle:SetCollide( false )
			particle:SetBounce( 0.8 )
			
		end
	end)
	
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		if self.Emitter then
			self.Emitter:Finish()
		end
		return false
	end
	
	self.Thick = ((self.Start-CurTime()))*50

	return true
end

function EFFECT:Render()
	if self.Angle == nil or self.StartPosition == nil or self.EndPosition == nil then return end
	render.SetMaterial( self.Mat )
	--local spline = math.QuadraticBezier3D(self.StartPosition, self.StartPosition + self.Angle:Forward() * 400 , self.EndPosition)
	local half = (self.StartPosition - self.EndPosition):Length()*self.Size
	local spline = math.QuadraticBezier3D(self.StartPosition, self.StartPosition + self.Angle:Forward() * 0.2 * half + self.Bend:Forward()*half/2 , self.EndPosition)
	render.StartBeam(42);
		local col = math.Rand(0,255)
		render.AddBeam(spline(0), self.Thick, 0,  Color(col,math.Rand(150,200),255 - col));
		for i=0, 40, 1 do
			local point = 44-math.Clamp(self.Start-CurTime()-0.2,0,1)*400
			local shift = 1
			local diff = math.abs(i-point)
			local alpha = math.Clamp(point-i,0,1)
			shift = 400/diff
			local col = math.Rand(0,255)
			render.AddBeam(spline(i/40)+VectorRand()*0.3, self.Thick, 0,  Color(col,math.Rand(150,200),255 - col));
		end
		local col = math.Rand(0,255)
		render.AddBeam(spline(1), self.Thick, 0,  Color(col,math.Rand(150,200),255 - col));
	render.EndBeam();
	--render.DrawBeam( self.StartPosition, self.StartPosition + self.Angle:Forward() * 8, self.Thick, 0, 0, Color( 0, 0, 0, 255 ) )
end
