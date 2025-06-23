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
	self:SetModel( "models/items/ar2_grenade.mdl" )
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
	
	self:SetLife(8+math.Rand(0,5))
	self:SetDead(false)
	
	if SERVER then
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
	if data.HitEntity:IsValid() then
		--self:Explode(45,50)
		return false
	else
		--create out impact thingo
		local dartpos = data.HitPos
		local dartangle = data.HitNormal:Angle()
			local tr = util.TraceLine({
			start  = dartpos,
			endpos = dartpos+dartangle:Forward()*-10000,
			mask   = MASK_SHOT
			});
		local targpos = tr.HitPos
		if SERVER then
			local trip = ents.Create("ep_bowdart_impact")
			trip:SetOwner(self:GetOwner())
			trip:SetAngles(self:GetAngles())
			trip:SetPos(dartpos-trip:GetForward()*20)
			trip:Spawn() 
			self:EmitSound("weapons/crossbow/hit1.wav", 100, 100)
		end

		--remove it
		self:SetDead(true)
		timer.Simple( 1, function() RemoveEntity(self) end )
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self:SetLocalVelocity(Vector(0,0,0))
		self:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:Explode(dam,radius) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
		self:EmitSound("weapons/explode3.wav", 100,math.Rand(150,180))
		self:EmitSound("npc/strider/strider_step1.wav", 100,math.Rand(110,120))
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
			util.Effect( "shell_explode", ed, true, true )			
			local targets = ents.FindInSphere(self:GetPos(),radius)
			for k,v in pairs(targets) do
				if v:IsValid() then
					if SERVER then
						local trace1 = {start = self:GetPos(), endpos = v:GetPos(), mask = MASK_SHOT}
						local traceRes1 = util.TraceLine(trace1)
						
						local vecPos, ang = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1") or 12)
						local trace2 = {start = self:GetPos(), endpos = vecPos, mask = MASK_SHOT}
						local traceRes2 = util.TraceLine(trace2)
						
						if (traceRes1.Entity == v or traceRes2.Entity == v) then 
							v:TakeDamage( dam, self.Entity:GetOwner(), self.Entity:GetOwner() )
						end
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
			self:Explode(25,220)
		end
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
	if ent:IsPlayer() then	
		if !self:GetDead() then
			self:SetDead(true)
		--create out impact thingo
			for i=0,5 do
				local ed = EffectData()
				ed:SetEntity(self)
				ed:SetStart(self:GetPos())
				ed:SetOrigin(self:GetPos()+AngleRand():Forward()*math.Rand(0,50))
				util.Effect( "wisp_arc", ed, true, true )
			end
			local ed = EffectData()
			ed:SetEntity(self)
			ed:SetStart(self:GetPos())
			ed:SetOrigin(self:GetPos())
			util.Effect( "shell_explode", ed, true, true )
			self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav", 100, 100)
			self:EmitSound("weapons/crossbow/bolt_skewer1.wav", 100, 100)
			ent:TakeDamage( 50, self:GetOwner(), self:GetOwner() )

			--remove it
			self:SetDead(true)
			timer.Simple( 1, function() RemoveEntity(self) end )
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
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
