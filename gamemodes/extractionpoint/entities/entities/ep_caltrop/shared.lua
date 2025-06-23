ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Caltrop"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points"
ENT.Instructions	= "comes from caltrop grenade"

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/props/cs_office/Snowman_nose.mdl" )
	self.Entity:SetMaterial("Models/effects/comball_tape")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(0)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		--phys:EnableDrag(true)
	end
	if SERVER then
		util.SpriteTrail(self, 0, Color(255, 100, 20), false, 3, 1, 0.2, 1/5*0.5, "trails/physbeam.vmt");
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
	end
end

	
function ENT:Touch(ent)
	if ent:IsValid() and ent:IsPlayer() then
		if SERVER then
			ent:TakeDamage( 14, self.Parent, self.Parent )
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNoDraw(true)
			self:SetNotSolid(true)
			RemoveEntity(self)
		end
	end
end

function ENT:OnTakeDamage(dmg)
	RemoveEntity(self)
end

function ENT:Think()	
	if CLIENT then
		self.SmokeTimer = self.SmokeTimer or CurTime() +0.01
		if ( self.SmokeTimer > CurTime() ) then return end 
		self.SmokeTimer = CurTime() + 0.1 
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false ) 
		local dietime = math.Rand( 1, 2 )
		local sAlpha = math.Rand( 75, 200 )
		local sSize = math.Rand( 1.0,5.0 )
		local particleback = emitter:Add( "particle/smokesprites_0006", pos ) 
			particleback:SetDieTime( dietime ) 
			particleback:SetStartAlpha( sAlpha+50 ) 
			particleback:SetStartSize( sSize/1.5 ) 
			particleback:SetEndSize( 0 ) 
			particleback:SetGravity(Vector(0,0,20))
			particleback:SetRoll( math.Rand( -90, 90 ) ) 
			particleback:SetColor( 20, 20, 20 ) 
			
		local particle = emitter:Add( "sprites/light_glow02_add", pos ) 
			particle:SetDieTime( dietime ) 
			particle:SetStartAlpha( sAlpha ) 
			particle:SetStartSize( sSize ) 
			particle:SetEndSize( 0 ) 
			particle:SetGravity(Vector(0,0,20))
			particle:SetRoll( math.Rand( -90, 90 ) ) 
			particle:SetColor( 255, 150, 30 ) 
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
function ENT:Draw()
	
end

function ENT:Pickup()
end

function ENT:Drop()
end


function ENT:OwnerDie()
end
