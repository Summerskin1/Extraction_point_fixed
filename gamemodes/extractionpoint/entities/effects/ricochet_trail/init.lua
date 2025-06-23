
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
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 15
	self.Start = CurTime()+0.3
	self.Bend = AngleRand()
	
	self.Size = math.Rand(0.2,0.8)

	local owner = data:GetEntity().Owner
	local view = owner == LocalPlayer()
	
	self.Angle	 		= (self.StartPosition - self.EndPosition):Angle()
	if data:GetEntity() then
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
			if owner.GetActiveWeapon then --Dunno why the fuck I need to do this but it errors unless I do this so fuck the popo
				local vm = owner:GetActiveWeapon()
				if (!vm || vm == NULL) then return end
				local attachment = vm:GetAttachment( 1 )
				if attachment != nil then
					self.StartPosition = attachment.Pos
				end
			end
		end
	end
	self.Dir = (data:GetOrigin()- data:GetStart()):Normalize()
	self.Entity:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,5 do
			
		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.StartPosition ) 
	 		local rand = math.Rand(5,8)
		 	particle:SetVelocity( VectorRand() * math.Rand(0,100)/rand ) 
		 	particle:SetLifeTime( 0 ) 
		 	particle:SetDieTime( 3/rand ) 
		 	particle:SetStartAlpha( 255 ) 
		 	particle:SetEndAlpha( 255 ) 
		 	particle:SetStartSize( rand ) 
		 	particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-100, 100) )
		 	particle:SetColor( 100+math.Rand(70,90), 100+math.Rand(30,40),  100+math.Rand(20,30) ) 
				
			particle:SetAirResistance( 300 )
			particle:SetGravity( VectorRand() * 20 )
			particle:SetCollide( false )
			particle:SetBounce( 0.8 )
		
			
	end
	timer.Simple(math.Rand(0.08,0.12),function()
	if !self.Emitter then return end
		for i=1,0 do
			
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
		 	particle:SetColor( math.Rand(0,200), math.Rand(50,200),  math.Rand(100,250) ) 
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
	local spline = math.QuadraticBezier3D(self.StartPosition, self.StartPosition , self.EndPosition)
	render.StartBeam(42);
		render.AddBeam(spline(0), self.Thick, 0, Color(255,100+self.Thick*50,100+self.Thick*50));
		for i=0, 40, 1 do
			local point = 44-math.Clamp(self.Start-CurTime()-0.2,0,1)*400
			local shift = 1
			local diff = math.abs(i-point)
			local alpha = math.Clamp(point-i,0,1)
			shift = 300/diff
			render.AddBeam(spline(i/40), self.Thick*1.5, 0,  Color((80+shift)*alpha,(60+shift*0.8)*alpha,(30+shift*0.4)*alpha));
			--render.AddBeam(spline(i/40), self.Thick*1.5, 0,  Color((10+shift)*alpha,(30+shift*0.8)*alpha,(50+shift*0.4)*alpha)); COMMANDER TRACER OH YEAH
		end
		render.AddBeam(spline(1), self.Thick*1.5, 0,  Color(255,100+self.Thick*50,100+self.Thick*50));
	render.EndBeam();
	--render.DrawBeam( self.StartPosition, self.StartPosition + self.Angle:Forward() * 8, self.Thick, 0, 0, Color( 0, 0, 0, 255 ) )
end
