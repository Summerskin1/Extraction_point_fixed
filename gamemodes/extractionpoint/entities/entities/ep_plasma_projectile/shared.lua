ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/dav0r/hoverball.mdl" )
	self.Entity:SetMaterial("models/props_combine/portalball001_sheet")
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(0,120,255,200))
	self:SetMaterial(self.Glow)
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(1000)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:AddGameFlag(1024)
		phys:AddGameFlag(32768)
	end
	
	self:SetLife(10)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(100, 100, 250), false, 15, 4, 0.1, 1/5*0.5, "trails/laser.vmt");
		util.SpriteTrail(self, 0, Color(255, 150, 60), false, 10, 4, 0.3, 1/5*0.5, "trails/laser.vmt");
		--util.SpriteTrail(self, 0, Color(130, 130, 130), false, 30, 0, 0.3, 1/5*0.5, "trails/laser.vmt");
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
	// Play sound on bounce
	if (data.Speed > 30 && data.DeltaTime > 0.2 ) then
		self:EmitSound( "ep/plasma_bounce.wav" )
	end
end

function ENT:Detonate()
	if self:GetDead() then return end
	if !SERVER then return end
	-- Remove it properly in 1 second
	self:SetDead(true)
	timer.Simple( 1, function() RemoveEntity(self) end )
			
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self:GetPos())
	util.Effect( "plasma_die", ed, true, true )
	-- Make it non solid
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:SetLocalVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	-- Send Effect
		
	self:EmitSound( "ep/plasma_phaseout.wav" )
			
	local targets = ents.FindInSphere(self:GetPos(),self:BoundingRadius()*8)
	for k,v in pairs(targets) do
		if v:IsValid() and v:IsPlayer() then
			if SERVER then
				v:TakeDamage( 20, self.Parent, self.Parent )
			end
		end
	end	
end

function ENT:Think()
	if SERVER then
		if (self:GetLife() <= 0 and !self:GetDead()) then
			self:Detonate()
		else
			self:SetLife(self:GetLife() - 1)
		end
	end
	if CLIENT then
	
	
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 250
			dlight.g = 150
			dlight.b = 60
			dlight.Brightness = 1
			dlight.Size = 64
			dlight.Decay = 1000
			dlight.DieTime = CurTime() + 1
		end
	
		self.SmokeTimer = self.SmokeTimer or 0 
		if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
		self.SmokeTimer = CurTime() + 0.001 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "sprites/light_glow02_add", pos ) 
			particle:SetVelocity( VectorRand( ) * 30 ) 
			particle:SetDieTime( 0.3 ) 
			particle:SetStartAlpha( math.Rand( 255, 255 ) ) 
			particle:SetStartSize( math.Rand( 10,20 ) ) 
			particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand( -0.2, 0.2 ) ) 
			particle:SetColor( 255, 150, 60 ) 
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
	if ent:IsValid() and ent != self.Parent and self:GetLife() > 0 and ent:IsPlayer()  then
		if SERVER then
			ent:TakeDamage( 20*(self:GetVelocity():Length()/3200), self.Parent, self.Parent )
			self:Detonate()
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
	self:NetworkVar( "Int", 0, "Life" );
	self:NetworkVar( "Bool", 0, "Dead" );
end

function ENT:OwnerDie()
end

function ENT:OnTakeDamage(damage)
	self:SetLife(self:GetLife() - damage:GetDamage())
end