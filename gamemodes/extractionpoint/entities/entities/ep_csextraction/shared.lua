ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Extraction Point"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Get the Relay here to win!"
ENT.Instructions	= "Retrieve the Relay and bring it to your Extraction Point"

ENT.NextTick = CurTime()

function ENT:Initialize()
 
	self:SetModel( "" )
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_NONE )         -- Toolbox
	self:DrawShadow(false)
	
	local amt = table.Count(player.GetAll())
	self:SetTimeLeft(math.Clamp((amt-1)*10,10,60))
	self:SetCapturing(false)
end
 
function ENT:Use( activator, caller )

end

function Dec(ent)
	if (ent:IsValid() and SERVER) then
		if ent:GetTimeLeft() > 0 then
			ent:SetTimeLeft(ent:GetTimeLeft()-1)
		end
	end
end

function ENT:Think()
	if SERVER then
		local targets = ents.FindInSphere(self:GetPos(),200)
		local plyFound = false
		if CurTime() > self.NextTick then
			for k,v in pairs(targets) do
				if v:IsValid() and v:IsPlayer() and v:Alive() and v:Team() == TEAM_SWAT then
					player_manager.RunClass(v,"AddPoints",1,"Held the extraction point")
					timer.Simple( 1, function() Dec(self) end )
					self.NextTick = CurTime()+1
					self:SetCapturing(true)
					plyFound = true	
				end
			end
			if !plyFound then
				self:SetCapturing(false)
			end
		end
	end
	
	if CLIENT then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos() + Vector(0,0,40)
			dlight.r = 60
			dlight.g = 100
			dlight.b = 240
			dlight.Brightness = 3
			dlight.Size = 512
			dlight.Decay = 1000
			dlight.DieTime = CurTime() + 1
		end
	
		self.SmokeTimer = self.SmokeTimer or 0 
		if ( self.SmokeTimer > CurTime() ) then return end 
		self.SmokeTimer = CurTime() + 0.1 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 	
		pos.y = pos.y - 200
		local totalsegs = 90
		local theta = 2.0 * 3.1415926 / totalsegs
		local c = math.cos(theta)
		local s = math.sin(theta)
		local t = 0
		local x = 15
		local y = 0
		for i=1,totalsegs do
			pos.x = x + pos.x
			pos.y = y + pos.y
			local particle = emitter:Add( "sprites/light_glow02_add", pos ) 
				particle:SetVelocity( Vector(0,0,0) ) 
				particle:SetGravity(Vector( 0, 0, 100 ))
				particle:SetCollide( false )
				particle:SetDieTime( 1 ) 
				particle:SetStartAlpha( math.Rand( 255, 255 ) ) 
				particle:SetStartSize( math.Rand( 10,20 ) ) 
				particle:SetEndSize( 0 ) 
				particle:SetRoll( math.Rand( -0.2, 0.2 ) ) 
				if self:GetCapturing() then
					particle:SetColor( 250, 250, 120 ) 
				else
					particle:SetColor( 100, 160, 240 ) 
				end
				
			t = x
			x = c * x - s * y
			y = s * t + c * y
		end
	end 
end

function ENT:GetEmitter( Pos, b3D ) 
	if ( self.Emitter ) then	 
		if ( self.EmitterIs3D == b3D && self.EmitterTime > CurTime() ) then 
			return self.Emitter 
		end 
		end 
	self.Emitter = ParticleEmitter( Pos, b3D ) 
	self.EmitterIs3D = b3D 
	self.EmitterTime = CurTime() + 2 
	return self.Emitter 
end  

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "TimeLeft" );
	self:NetworkVar( "Bool", 0, "Capturing");
end

function ENT:TimeLeft()
	return self:GetTimeLeft()
end