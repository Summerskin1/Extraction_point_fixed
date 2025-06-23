ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "pincer dart"
ENT.Author			= "Cooldown Studios"
ENT.Contact			= "NA"
ENT.Purpose			= "Used to block choke points and defend the Ghost"
ENT.Instructions	= "Use the GDS to place the shield down"

function ENT:Initialize()
 
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( "models/items/ar2_grenade.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(100,160,30,140))
	
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(10)
	self:SetGravity(1)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:AddGameFlag(1024)
		phys:AddGameFlag(32768)
	end
	
	self:SetLife(60)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 1, Color(255,200,100,150), true, 8, 0, 0.4, 1/5*0.8, "trails/laser.vmt");
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
	if data.HitEntity:IsValid() then
		self.Entity:SetParent(data.HitEntity)
		if data.HitEntity:IsPlayer() then
			self.Gun:SetLock(1)
		end
	end
	--self:SetLocalVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(data.HitPos-data.HitNormal*1)
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	if SERVER then
		self.Entity:EmitSound("weapons/crossbow/bolt_skewer1.wav", 30, 50 )
	end
end

function ENT:Think()
	if SERVER then
		if (self:GetLife() <= 0 and !self:GetDead()) then
			-- Remove it properly in 1 second
			self:SetDead(true)
			self.Gun:SetLock(0)
			timer.Simple( 1, function() RemoveEntity(self) end )
			
			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
		else
			self:SetLife(self:GetLife() - 1)
		end
	end
	
	if CLIENT then
	
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = r
			dlight.g = g
			dlight.b = b
			dlight.Brightness = 1
			dlight.Size = 64
			dlight.Decay = 500
			dlight.DieTime = CurTime() + 1
		end
	end
	self:NextThink( CurTime() + 0.1 )
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
