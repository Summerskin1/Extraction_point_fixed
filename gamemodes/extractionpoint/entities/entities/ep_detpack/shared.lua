ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
	self.Armed		= false
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/weapons/w_slam.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(-100)
	self:SetFriction(500)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(true)
	end
	
	self:SetLife(4)
	self:SetDead(false)
	
	self.Owner = self.Entity:GetOwner()
	self.Entity:SetOwner(nil)	
	self.Entity:EmitSound( "npc/roller/mine/rmine_predetonate.wav", 100, 100 )
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(255, 100, 100), false, 4, 1, 0.2, 1/5*0.5, "trails/physbeam.vmt");
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
	end
end

function ENT:Use( activator, caller )
	if player_manager.RunClass(activator,"Defuse") then
		player_manager.RunClass(activator,"AddPoints",20,"Defused a Detpack")
		self.Entity:EmitSound("buttons/button5.wav")
		self:Remove()
	end
end

function ENT:Explode()
		-- Remove it properly in 1 second
		if self:GetDead() then return end
			self:SetDead(true)
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			--self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
			ed:SetEntity(self.Entity)
			ed:SetOrigin(self.Entity:GetPos())
			ed:SetScale( 1 )
			util.Effect( "Explosion", ed, true, true )
			local owner = self.Owner

			util.BlastDamage(owner, owner, self:GetPos(), 400, 200)
end

function ENT:Think()
	if CLIENT then
		self.SmokeTimer = self.SmokeTimer or CurTime() + 1
		if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
		self:EmitSound( "npc/turret_floor/ping.wav", 80 )
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 250
			dlight.g = 150
			dlight.b = 40
			dlight.Brightness = 2
			dlight.Size = 64
			dlight.Decay = 500
			dlight.DieTime = CurTime() + 1
		end
		self.SmokeTimer = CurTime() + 2
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "effects/yellowflare", pos ) 
			particle:SetVelocity( VectorRand( )*3) 
			particle:SetDieTime( 0.2) 
			particle:SetStartAlpha( math.Rand( 254, 244 ) ) 
			particle:SetStartSize( math.Rand( 60,40 ) ) 
			particle:SetEndSize( 30 ) 
			particle:SetRoll( CurTime()*-5 ) 
			--particle:SetColor( 255,math.Rand( 200,220),math.Rand( 20,40 ) ) 
		local particle = emitter:Add( "effects/yellowflare", pos ) 
			particle:SetVelocity( VectorRand( )*3) 
			particle:SetDieTime( 0.2) 
			particle:SetStartAlpha( math.Rand( 254, 244 ) ) 
			particle:SetStartSize( math.Rand( 60,40 ) ) 
			particle:SetEndSize( 20 ) 
			particle:SetRoll( CurTime()*-5 ) 
			--particle:SetColor( 255,math.Rand( 200,220),math.Rand( 20,40 ) ) 
		end
	self:NextThink( CurTime() + 0.01 )
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
	self.Armed = true
end

function ENT:PhysicsCollide( data, physobj )
	self.Armed = true
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsValid() then
		local activator = dmg:GetAttacker()
		if activator:Team() == TEAM_SWAT then
			if !self:GetDead() then
				player_manager.RunClass(activator,"AddPoints",5,"Destroyed a Detpack")
			end
		end
	end
	self:Explode()
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Life" );
	self:NetworkVar( "Bool", 0, "Dead" );
end

function ENT:OwnerDie()
end