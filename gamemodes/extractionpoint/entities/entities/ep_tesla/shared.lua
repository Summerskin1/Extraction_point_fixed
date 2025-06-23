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
		util.SpriteTrail(self, 0, Color(50, 120, 255), false, 20, 4, 0.2, 1/5*0.5, "trails/physbeam.vmt");
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

function ENT:Think()
	if SERVER then
		if (self:GetLife() <= 0 and !self:GetDead()) then
			-- Remove it properly in 1 second
			self:SetDead(true)
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			util.Effect( "plasma_die", ed, true, true )
			
			self:EmitSound( "ep/plasma_phaseout.wav" )
			
			local targets = ents.FindInSphere(self:GetPos(),self:BoundingRadius()*8)
			for k,v in pairs(targets) do
				if v:IsValid() and v:IsPlayer() then
					if SERVER then
						v:TakeDamage( 15, self.Parent, self.Parent )
					end
				end
			end
			
		else
			self:SetLife(self:GetLife() - 1)
		end
	end
	
	if CLIENT then
	
	
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 50
			dlight.g = 150
			dlight.b = 255
			dlight.Brightness = 1
			dlight.Size = 64
			dlight.Decay = 1000
			dlight.DieTime = CurTime() + 1
		end
	
		self.SmokeTimer = self.SmokeTimer or 0 
		if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
		self.SmokeTimer = CurTime() + 0.01 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "sprites/light_glow02_add", pos ) 
			particle:SetVelocity( VectorRand( ) * 30 ) 
			particle:SetDieTime( 0.3 ) 
			particle:SetStartAlpha( math.Rand( 75, 200 ) ) 
			particle:SetStartSize( math.Rand( 10,20 ) ) 
			particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand( -0.2, 0.2 ) ) 
			particle:SetColor( 40, 150, 250 ) 
	end 					
	local closest
	local nclosest
	
	local cdist = 400
	for k,v in ipairs( ents.FindInSphere( self:GetPos(), 400 )) do 
		local dist = (v:GetPos() - self:GetPos()):Length()
		if dist < cdist and (v:IsPlayer() or v:GetClass() == "prop_physics") then
			cdist = dist
			nclosest = closest
			closest = v
		end
	end
	
	if !SERVER then return end
	if math.Rand(1,5) > 2 then return end
	
		if closest != nil and closest:IsValid() and self:IsValid() then
			bullet = {}
			bullet.Num=1
			bullet.Src=self:GetPos()
			bullet.Dir = (closest:GetPos()-self:GetPos()+Vector(0,0,30))
			bullet.Spread=Vector(0.1,0.1,0.1)
			bullet.TracerName = "tool_tracer"
			bullet.Tracer=1
			bullet.Force=10
			bullet.Damage=5
			self.Entity:FireBullets(bullet)
		end
		if nclosest != nil and nclosest:IsValid() and self:IsValid() then
			bullet = {}
			bullet.Num=1
			bullet.Src=self:GetPos()
			bullet.Dir = (nclosest:GetPos()-self:GetPos())
			bullet.Spread=Vector(0.1,0.1,0.1)
			bullet.TracerName = "tesla_beam"
			bullet.Tracer=1
			bullet.Force=10
			bullet.Damage=5
			self.Entity:FireBullets(bullet)
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
	if ent:IsValid() and ent:IsPlayer() and ent != self.Parent and self:GetLife() > 0  then
		if SERVER then
			ent:TakeDamage( 18, self.Parent, self.Parent )
			self:SetLife(0)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNoDraw(true)
			self:SetNotSolid(true)
			-- Play on client end?  self:EmitSound( "ep/plasma_hit.wav" )
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