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
	self:SetModel( "models/weapons/w_eq_flashbang_thrown.mdl" )
	--self:SetMaterial("models/props_lab/Tank_Glass001")
	self:SetColor(Color(255,200,100,200))

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetElasticity(1)
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
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
		local bright = math.Rand( 0,20 )
		util.SpriteTrail(self, 1, Color(100+bright,100+bright, 100+bright), false, 16, 64, 2, 1/128*0.5, "trails/smoke.vmt");
		--util.SpriteTrail(self, 1, Color(255,150,150), true, 128, 0, 0.4, 1/64*0.5, "trails/physbeam.vmt");
		--util.SpriteTrail(self, 1, Color(255,150,150), true, 200, 0, 0.2, 1/64*0.5, "trails/laser.vmt");
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
		--if data.Speed > 300 then
			self:Explode(325,125,data.HitNormal:Angle())
		--end
	end
end

function ENT:Explode(dam,radius,ang) --30, 120 by default
	if SERVER then
		if (!self:GetDead()) then
			print("boom")
		self:EmitSound("weapons/explode3.wav", 100,math.Rand(110,120))
		self:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav", 100,math.Rand(110,120))
			-- Remove it properly in 1 second
			self:SetDead(true)
			timer.Simple( 4, function() RemoveEntity(self) end )

			-- Make it non solid
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			-- Send Effect
			local ed = EffectData()
				ed:SetEntity(self)
				ed:SetOrigin(self:GetPos())
				ed:SetAngles(ang)
			util.Effect( "rocket_impact", ed, true, true )
			util.BlastDamage(self.Entity:GetOwner(),self.Entity:GetOwner(), self:GetPos(), radius, dam)
			util.BlastDamage(self.Entity:GetOwner(),self.Entity:GetOwner(), self:GetPos(), radius*5, dam/3)
			local targets = ents.FindInSphere(self:GetPos(),radius)
			--[[for k,v in pairs(targets) do
				if v:IsValid() then
					if SERVER then
						v:TakeDamage( dam, self.Entity:GetOwner(), self.Entity:GetOwner() )
					end
				end
			end]]--
		end
	end
end

function ENT:Think()
	if SERVER then
		self:SetLife(self:GetLife() - 1)
		if (self:GetLife() <= 0) then
			self:Explode(25,220,Angle(0,0,0))
		end
	end

	if CLIENT then
		self.SmokeTimer = self.SmokeTimer or CurTime() + 0.1
		if ( self.SmokeTimer > CurTime() or self:GetDead() ) then return end
		self.SmokeTimer = CurTime() + 0.0005
		local pos = self:GetPos()
		local emitter = self:GetEmitter( pos, false )
		local particle = emitter:Add( "particle/smokesprites_0006", pos )
			local ang = self.Entity:GetAngles():Right():Angle()
			ang:RotateAroundAxis(self.Entity:GetAngles():Forward(),CurTime()*5000)
			particle:SetVelocity( VectorRand( )*5+(ang:Forward()*25 ))
			particle:SetDieTime( 2 )
			particle:SetStartAlpha( math.Rand( 200, 250 ) )
			particle:SetStartSize( math.Rand( 12,15 ) )
			particle:SetEndSize( math.Rand( 25, 40 ) )
			particle:SetGravity(Vector(0,0,0))
			particle:SetRoll( math.Rand( -90, 90 ) )
			local bright = math.Rand( 0,20 )
			particle:SetColor(40+bright,40+bright, 40+bright)
		local particle = emitter:Add( "effects/yellowflare", pos )
			particle:SetVelocity( VectorRand( )*3)
			particle:SetDieTime( 0.2)
			particle:SetStartAlpha( math.Rand( 200, 250 ) )
			particle:SetStartSize( math.Rand( 60,40 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( CurTime()*-5 )
			particle:SetColor( 255,math.Rand( 200,220),math.Rand( 140,180 ) )
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
	--if ent:IsPlayer() then
		--self:Explode(45,50,Angle(0,0,0))
	--end
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
