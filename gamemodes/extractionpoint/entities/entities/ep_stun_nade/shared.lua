ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Stun Grenade"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to slow bitches"
ENT.Instructions	= "Throw and run."

function ENT:Initialize()

	self.Glow		= Material( "sprites/light_glow02_add" )
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/weapons/w_eq_fraggrenade_thrown.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(10)
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(true)
	end
	
	self:SetLife(4)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(50, 40, 120), false, 4, 1, 0.2, 1/5*0.5, "trails/physbeam.vmt");
	end
end

local function RemoveEntity(ent)
	if (ent:IsValid() and SERVER) then
		ent:Remove()
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
			--self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
			ed:SetEntity(self.Entity)
			ed:SetStart(self:GetPos())
			ed:SetOrigin(self:GetPos() + Vector(0,0,250))
			util.Effect( "stun_explode", ed, true, true )	
			
			if SERVER then
				util.BlastDamage(self:GetOwner(), self:GetOwner(), self:GetPos(), 250, 50)
			end
			local targets = ents.FindInSphere(self:GetPos(),250)
			for k,v in pairs(targets) do
				if v:IsValid() and v:IsPlayer() then
					if SERVER then
						player_manager.RunClass( v, "SlowDebuff", 5 )
					end
				end
			end
			
		else
			self:SetLife(self:GetLife() - 1)
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Life" );
	self:NetworkVar( "Bool", 0, "Dead" );
end

function ENT:OwnerDie()
end