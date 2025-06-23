
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
	self.Angle	 		= owner:EyeAngles( )

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
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		if self.Emitter then
			self.Emitter:Finish()
		end
		return false
	end
	
	self.Thick = ((self.Start-CurTime()))*20

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
			shift = 400/diff
			render.AddBeam(spline(i/40), self.Thick, 0,  Color((30+shift*1)*alpha,(30+shift*0.8)*alpha,(10+shift*0.4)*alpha));
		end
		render.AddBeam(spline(1), self.Thick, 0,  Color(255,100+self.Thick*50,100+self.Thick*50));
	render.EndBeam();
	--render.DrawBeam( self.StartPosition, self.StartPosition + self.Angle:Forward() * 8, self.Thick, 0, 0, Color( 0, 0, 0, 255 ) )
end
