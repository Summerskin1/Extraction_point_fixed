ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "G.H.O.S.T Defence Shield"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

ENT.Bounces			= true

function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/Items/combine_rifle_ammo01.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(255,200,100,200))
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(1)
	
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

function ENT:SetBounces(bool)
	self.Bounces = bool
	if bool then
		self:SetLife(1)
	end
end


function ENT:PhysicsCollide( data, physobj )
	if self.Bounces then
		if data.Speed > 1900 then
			self:Explode()
		end
	end
end

function ENT:Explode()
	if SERVER then
		if (!self:GetDead()) then
		self:EmitSound("weapons/explode3.wav", 100,math.Rand(120,130))
		self:EmitSound("npc/strider/strider_step1.wav", 100,math.Rand(110,120))
			-- Remove it properly in 1 second
			self:SetDead(true)
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			for i=1,4,1 do
				local ent = ents.Create ("ep_shell");
			 
				ent.Parent = self.Owner
				ent:SetOwner(self.Owner)
				ent:SetPos(self.Entity:GetPos());
				ent:SetAngles(AngleRand());
				ent:SetBounces(true)
				ent:Spawn();
				
				local phys = ent:GetPhysicsObject();
				phys:SetVelocity(ent:GetAngles():Forward()*200)
			end
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
			util.Effect( "shell_explode", ed, true, true )			
			local targets = ents.FindInSphere(self:GetPos(),140)
			for k,v in pairs(targets) do
				if v:IsValid() then
					if SERVER then
						v:TakeDamage( 10, self.Entity:GetOwner(), self.Entity:GetOwner() )
					end
				end
			end
		end
	end
end

function ENT:Think()
	if SERVER then
		self:SetLife(self:GetLife() - 1)
		if (self:GetLife() <= 0) then
			self:Explode()
		end
	end
	
	if CLIENT then
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
