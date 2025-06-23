ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Pincer Projectile"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "the projectile fired by the Pincer"
ENT.Instructions	= "N/A"

local function SetSolid(ent)
	if (ent:IsValid() and SERVER) then
		ent:SetNotSolid(false)
	end
end

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/props_lab/huladoll.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(0,255,800,200))
	self:SetMaterial(self.Glow)
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:AddGameFlag(1024)
		phys:AddGameFlag(32768)
	end
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(10, 255, 80), false, 20, 4, 0.2, 1/5*0.5, "trails/physbeam.vmt");
		timer.Simple( 0.06, function() SetSolid(self) end )
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
	end
end

function ENT:Use( activator, caller )
end

function ENT:PhysicsCollide( data, physobj )
	if SERVER then
		timer.Simple( 1, function() RemoveEntity(self) end )
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self:SetLocalVelocity(Vector(0,0,0))
		self:SetMoveType(MOVETYPE_NONE)
	
	-- Send Effect
		local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self:GetPos())
		util.Effect( "pincer_hit", ed, true, true )
		
		local targets = ents.FindInSphere(self:GetPos(),self:BoundingRadius()*12)
		for k,v in pairs(targets) do
			if v:IsValid() and v:IsPlayer() then
				if SERVER then
					v:TakeDamage( 10, self.Parent, self.Parent )
				end
			end
		end
	end
	
end

function ENT:Think()
	if SERVER then
		local phys = self:GetPhysicsObject()
		if self.Target != nil and self.Target:IsValid() then
			self.TargetPos = self.Target:GetPos()
			
			if (phys:IsValid()) then
				local angToTarget = (self.TargetPos - phys:GetPos()):Angle()
				local myAngle = phys:GetVelocity():Angle()
				
				local angleDifs = Vector(math.abs(myAngle.p - angToTarget.p), math.abs(myAngle.y - angToTarget.y), math.abs(myAngle.r - angToTarget.r))
				
				if (angleDifs.x <= 1 and angleDifs.y <= 1 and angleDifs.z <= 1) then
					phys:SetVelocity(phys:GetVelocity()*200)
				else
					if (angleDifs.x > 1) then
						myAngle.p = math.ApproachAngle(myAngle.p, angToTarget.p, self.CurveStrength )
					end
					if (angleDifs.y > 1) then
						myAngle.y = math.ApproachAngle(myAngle.y, angToTarget.y, self.CurveStrength )
					end
					if (angleDifs.z > 1) then
						myAngle.r = math.ApproachAngle(myAngle.r, angToTarget.r, self.CurveStrength )
					end
					
					phys:SetVelocity(myAngle:Forward() * self.Speed)
				end
			end
		else
			if (phys:IsValid()) then
				phys:SetVelocity(phys:GetVelocity()*200)
			end
		end
	end
	
	if CLIENT then
	
	
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 50
			dlight.g = 255
			dlight.b = 100
			dlight.Brightness = 1
			dlight.Size = 32
			dlight.Decay = 1000
			dlight.DieTime = CurTime() + 1
		end
	
		self.SmokeTimer = self.SmokeTimer or 0 
		if ( self.SmokeTimer > CurTime()) then return end 
		self.SmokeTimer = CurTime() + 0.01 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "effects/spark", pos ) 
			particle:SetVelocity(Vector(0,0,0)) 
			particle:SetDieTime( 0.2 ) 
			particle:SetStartAlpha( math.Rand( 75, 200 ) ) 
			particle:SetStartSize( math.Rand( 1,2 ) ) 
			particle:SetEndSize( 0 ) 
			particle:SetRoll( self:GetVelocity():Angle().p ) 
			particle:SetColor( 10, 250, 60 ) 
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
	
function ENT:Touch(ent)
	if ent:IsValid() and ent:IsPlayer() and ent != self.Parent then
		if SERVER then
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNotSolid(true)
			
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			util.Effect( "pincer_hit", ed, true, true )
			
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			local targets = ents.FindInSphere(self:GetPos(),self:BoundingRadius()*12)
			for k,v in pairs(targets) do
				if v:IsValid() and v:IsPlayer() then
					if SERVER then
						v:TakeDamage( 10, self.Parent, self.Parent )
					end
				end
			end
		end
	end
end

function ENT:Draw()
end

function ENT:Pickup()
end

function ENT:Drop()
end

function ENT:SetupDataTables()
end

function ENT:OwnerDie()
end

function ENT:OnTakeDamage(damage)
end