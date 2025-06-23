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
	
	self:SetLife(5)
	self:SetDead(false)
	
	if SERVER then
		util.SpriteTrail(self, 0, Color(50, 120, 255), false, 4, 1, 0.2, 1/5*0.5, "trails/physbeam.vmt");
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
			ed:SetOrigin(self.Entity:GetPos())
			ed:SetScale( 1 )
			util.Effect( "Explosion", ed, true, true )
			local owner = self.Entity:GetOwner()
			self.Entity:SetOwner(nil)	

 
			timer.Create( "my_timer", 0.01, 1, function()
				for i=1, 20, 1 do
					bullet = {}
					bullet.Num=1
					if owner:IsValid() then
						bullet.Attacker = owner
					end
					bullet.Src=self:GetPos()
					bullet.Dir=Angle(math.Rand(-90,90),math.Rand(-90,90),math.Rand(-90,30))
					bullet.Spread=Vector(0,0,0)
					bullet.TracerName = "grenade_shrapnel"
					bullet.Tracer=1
					bullet.Force=100
					bullet.Damage=90
					self.Entity:FireBullets(bullet)
				end
			end)
			util.BlastDamage(owner, owner, self:GetPos(), 180, 500)
			
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