ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/items/ar2_grenade.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(255,200,100,200))
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(1000)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:AddGameFlag(1024)
		phys:AddGameFlag(32768)
	end
	
	self:SetLife(8)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 1, Color(150,100,60), false, 0, 4, 0.5, 1/5*0.5, "trails/smoke.vmt");
		util.SpriteTrail(self, 1, Color(255,200,100), true, 8, 0, 0.2, 1/5*0.5, "trails/laser.vmt");
		util.SpriteTrail(self, 1, Color(255,200,100), true, 8, 0, 0.2, 1/5*0.5, "trails/laser.vmt");
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
	local WasGlass = false
	if data.HitEntity:IsValid() then
		if ( data.HitEntity:GetClass() == "func_breakable_surf" ) then
			data.HitEntity:Fire( "shatter" )
			local phys = self:GetPhysicsObject()
			if (phys:IsValid()) then
				phys:SetVelocity(data.OurOldVelocity)
			end
			WasGlass = true
		elseif ( data.HitEntity:GetClass() == "func_breakable" ) then
			data.HitEntity:Fire( "break" )
		end
	end
	if data.HitEntity:IsValid() then
		self.Entity:SetParent(data.HitEntity)
	end
	--self:SetLocalVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(data.HitPos-data.HitNormal*1)
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	if SERVER then
		self.Entity:EmitSound("weapons/crossbow/bolt_skewer1.wav", 70, 100 )
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
			util.Effect( "Explosion", ed, true, true )			
			local targets = ents.FindInSphere(self:GetPos(),140)
			for k,v in pairs(targets) do
				if v:IsValid() then
					if SERVER then
						local dmginfo = DamageInfo()
						dmginfo:SetDamage( 30 )
						dmginfo:SetDamageType( DMG_CRUSH )
						dmginfo:SetAttacker( self.Entity:GetOwner() )
						v:TakeDamageInfo( dmginfo ) -- I think this lets eidolon regen off this attack.
					end
				end
			end
			
		else
			if (self:GetLife() == 6 or self:GetLife() == 4 or self:GetLife() == 2 or self:GetLife() == 1) then
				self.Entity:EmitSound("npc/turret_floor/ping.wav", 70, 100 )
			end
			self:SetLife(self:GetLife() - 1)
		end
	end
	
	if CLIENT then
	
		if (self:GetLife() == 6 or self:GetLife() == 4 or self:GetLife() == 2 or self:GetLife() == 1) then
			local dlight = DynamicLight( self:EntIndex() )
			if ( dlight ) then
				local r, g, b, a = self:GetColor()
				dlight.Pos = self:GetPos()
				dlight.r = 255
				dlight.g = 200
				dlight.b = 100
				dlight.Brightness = 1
				dlight.Size = 64
				dlight.Decay = 200
				dlight.DieTime = CurTime() + 0.2
			end
	
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "sprites/light_glow02_add", pos ) 
			particle:SetVelocity( VectorRand( )  ) 
			particle:SetDieTime( 0.3 ) 
			particle:SetStartAlpha( math.Rand( 75, 200 ) ) 
			particle:SetStartSize( math.Rand( 10,20 ) ) 
			particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand( -0.2, 0.2 ) ) 
			particle:SetColor( 255,200,100 ) 
		
	end 
		self.SmokeTimer = self.SmokeTimer or 0 
		if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end 
		self.SmokeTimer = CurTime() + 0.003 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local particle = emitter:Add( "particle/smokesprites_0006", pos ) 
			particle:SetVelocity( VectorRand( )*5 ) 
			particle:SetDieTime( 2 ) 
			particle:SetStartAlpha( math.Rand( 75, 200 ) ) 
			particle:SetStartSize( math.Rand( 2,3 ) ) 
			particle:SetEndSize( 6 ) 
			particle:SetGravity(Vector(0,0,20))
			particle:SetRoll( math.Rand( -90, 90 ) ) 
			particle:SetColor( 50, 40, 10 ) 
		end
	self:NextThink( CurTime() + 0.1 )
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
